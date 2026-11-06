import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/app_log.dart';
import '../../../../data/models/order.dart';
import '../../../../data/models/pagination_meta.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../shell/providers/restaurant_provider.dart';
import '../models/order_filter.dart';
import 'orders_state.dart';

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final notifier = OrdersNotifier(locator<OrderRepository>());
  final initial = ref.read(restaurantProvider).restaurant?.id;
  if (initial != null) notifier.setRestaurantId(initial);
  ref.listen<String?>(
    restaurantProvider.select((state) => state.restaurant?.id),
    (previous, next) => notifier.setRestaurantId(next),
  );
  return notifier;
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository _repo;

  OrdersNotifier(this._repo) : super(const OrdersState());

  Future<void> setRestaurantId(String? id) async {
    if (id == state.restaurantId) return;
    if (id == null) {
      state = const OrdersState();
      return;
    }
    state = OrdersState(restaurantId: id);
    await load();
  }

  Future<void> load({bool silent = false}) async {
    final id = state.restaurantId;
    if (id == null) return;
    if (!silent) {
      state = state.copyWith(
        status: OrdersLoadStatus.loading,
        clearError: true,
      );
    }

    final activeFuture = _fetchActive(id);
    final allFuture = _fetchHistory(id, OrderFilter.all);

    final active = await activeFuture;
    final all = await allFuture;
    if (!mounted) return;

    final history = Map<OrderFilter, OrdersHistoryPage>.from(state.history);
    history[OrderFilter.all] = all.toPage(previous: state.history[OrderFilter.all]);
    final truncated = _withActiveTruncation(state.truncatedStatuses, active);

    if (active.allFailed && state.activeOrders.isEmpty) {
      state = state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: AppError.message(active.error!),
        history: history,
        isStale: false,
      );
      return;
    }

    state = state.copyWith(
      status: OrdersLoadStatus.loaded,
      activeOrders: active.orders,
      history: history,
      truncatedStatuses: truncated,
      isStale: active.anyFailed,
      lastUpdated: active.allFailed ? state.lastUpdated : DateTime.now(),
      clearError: true,
    );
  }

  Future<void> selectFilter(OrderFilter value) async {
    if (state.filter == value) return;
    state = state.copyWith(filter: value);
    if (!value.isHistory) return;
    final page = state.history[value];
    if (page == null || !page.isLoaded) {
      await loadHistory(value);
    }
  }

  Future<void> loadHistory(OrderFilter value) async {
    final id = state.restaurantId;
    if (id == null || !value.isHistory) return;

    final previous = state.history[value];
    state = state.copyWith(
      history: {
        ...state.history,
        value: (previous ?? const OrdersHistoryPage()).copyWith(
          isLoading: true,
          clearError: true,
        ),
      },
    );

    final result = await _fetchHistory(id, value, previous: previous);
    if (!mounted) return;

    final truncated = Set<String>.from(state.truncatedStatuses);
    for (final status in value.historyStatuses) {
      truncated.remove(status);
    }
    truncated.addAll(result.truncated);

    state = state.copyWith(
      history: {
        ...state.history,
        value: result.toPage(previous: previous),
      },
      truncatedStatuses: truncated,
    );
  }

  Future<String?> refresh() async {
    final id = state.restaurantId;
    if (id == null) return null;

    final activeFuture = _fetchActive(id);
    final filter = state.filter;
    final currentHistory = state.history[filter];
    final refreshHistory =
        filter.isHistory && (currentHistory?.isLoaded ?? false);
    final historyFuture = refreshHistory
        ? _fetchHistory(id, filter, previous: currentHistory)
        : null;

    final active = await activeFuture;
    final history = historyFuture == null ? null : await historyFuture;
    if (!mounted) return null;

    var truncated = _withActiveTruncation(state.truncatedStatuses, active);
    final pages = Map<OrderFilter, OrdersHistoryPage>.from(state.history);
    if (history != null) {
      pages[filter] = history.toPage(previous: currentHistory);
      for (final status in filter.historyStatuses) {
        truncated.remove(status);
      }
      truncated = {...truncated, ...history.truncated};
    }

    if (active.allFailed && state.activeOrders.isEmpty) {
      final message = AppError.message(active.error!);
      state = state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: message,
        history: pages,
        truncatedStatuses: truncated,
      );
      return message;
    }

    state = state.copyWith(
      status: OrdersLoadStatus.loaded,
      activeOrders: active.orders,
      history: pages,
      truncatedStatuses: truncated,
      isStale: active.anyFailed || (history?.anyFailed ?? false),
      lastUpdated: active.allFailed ? state.lastUpdated : DateTime.now(),
      clearError: true,
    );

    return active.anyFailed ? AppError.message(active.error!) : null;
  }

  Future<void> refreshActive() async {
    final id = state.restaurantId;
    if (id == null) return;

    final active = await _fetchActive(id);
    if (!mounted) return;

    if (active.allFailed && state.activeOrders.isEmpty) {
      state = state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: AppError.message(active.error!),
      );
      return;
    }

    state = state.copyWith(
      activeOrders: active.orders,
      truncatedStatuses: _withActiveTruncation(state.truncatedStatuses, active),
      isStale: active.anyFailed,
      lastUpdated: active.allFailed ? state.lastUpdated : DateTime.now(),
      clearError: true,
    );
  }

  Future<String?> loadMore() async {
    final value = state.filter;
    if (value != OrderFilter.all && value != OrderFilter.delivered) return null;
    final page = state.history[value];
    if (page == null ||
        !page.isLoaded ||
        !page.hasMore ||
        page.isLoadingMore) {
      return null;
    }
    final id = state.restaurantId;
    if (id == null) return null;

    state = state.copyWith(
      history: {
        ...state.history,
        value: page.copyWith(isLoadingMore: true, clearError: true),
      },
    );

    final nextPage = (page.pagination?.page ?? 1) + 1;
    final result = await _fetchHistory(id, value, page: nextPage);
    if (!mounted) return null;

    if (result.allFailed) {
      final message = AppError.message(result.error!);
      state = state.copyWith(
        history: {
          ...state.history,
          value: page.copyWith(
            isLoadingMore: false,
            errorMessage: message,
          ),
        },
      );
      return message;
    }

    final merged = <String, OrderModel>{};
    for (final order in page.orders) {
      merged[_orderKey(order)] = order;
    }
    for (final order in result.orders) {
      merged[_orderKey(order)] = order;
    }

    final truncated = Set<String>.from(state.truncatedStatuses);
    for (final status in value.historyStatuses) {
      truncated.remove(status);
    }
    truncated.addAll(result.truncated);

    state = state.copyWith(
      history: {
        ...state.history,
        value: OrdersHistoryPage(
          orders: _sort(merged.values),
          pagination: result.pagination,
          isLoaded: true,
          isLoading: false,
          isLoadingMore: false,
        ),
      },
      truncatedStatuses: truncated,
    );
    return null;
  }

  Future<String?> accept(String orderId) =>
      _runAction(orderId, () => _repo.confirm(orderId));

  Future<String?> startPreparing(String orderId) =>
      _runAction(orderId, () => _repo.markPreparing(orderId));

  Future<String?> markReady(String orderId) =>
      _runAction(orderId, () => _repo.markReady(orderId));

  Future<String?> reject(String orderId, String reason) => _runAction(
        orderId,
        () => _repo.reject(orderId, reason),
        removeOnSuccess: true,
        reloadHistory: OrderFilter.cancelled,
      );

  Future<String?> _runAction(
    String orderId,
    Future<OrderModel?> Function() action, {
    bool removeOnSuccess = false,
    OrderFilter? reloadHistory,
  }) async {
    if (state.inFlightIds.contains(orderId)) return null;
    state = state.copyWith(
      inFlightIds: {...state.inFlightIds, orderId},
    );

    try {
      final updated = await action();
      if (!mounted) return null;

      var active = state.activeOrders;
      if (removeOnSuccess) {
        active = active.where((order) => order.id != orderId).toList();
      } else if (updated != null) {
        active = active
            .map((order) => order.id == orderId ? updated : order)
            .toList();
      }

      final inFlight = Set<String>.from(state.inFlightIds)..remove(orderId);
      var history = state.history;
      if (removeOnSuccess && reloadHistory != null && updated != null) {
        final page = state.history[reloadHistory];
        if (page != null && page.isLoaded) {
          history = {
            ...state.history,
            reloadHistory: page.copyWith(
              orders: _sort([
                updated,
                ...page.orders.where((order) => order.id != updated.id),
              ]),
            ),
          };
        }
      }
      state = state.copyWith(
        activeOrders: _sort(active),
        inFlightIds: inFlight,
        history: history,
      );

      if (!removeOnSuccess && updated == null) {
        await refreshActive();
      }

      if (reloadHistory != null &&
          (state.history[reloadHistory]?.isLoaded ?? false)) {
        await loadHistory(reloadHistory);
      }
      return null;
    } catch (e, s) {
      AppLog.e('ORDER', 'action', 'failed', e, s);
      if (!mounted) return null;
      state = state.copyWith(
        inFlightIds: Set<String>.from(state.inFlightIds)..remove(orderId),
      );
      return AppError.message(e);
    }
  }

  Future<_ActiveFetchResult> _fetchActive(String restaurantId) async {
    final previous = state.activeOrders;
    final previousTruncated = state.truncatedStatuses;

    final outcomes = await Future.wait(
      kActiveOrderStatuses.map((status) async {
        try {
          final page = await _repo.fetchOrders(
            restaurantId: restaurantId,
            status: status,
            page: 1,
            limit: 50,
          );
          return _StatusOutcome.success(status, page);
        } catch (e) {
          return _StatusOutcome.failure(status, e);
        }
      }),
    );

    final successes = outcomes.where((outcome) => outcome.page != null);
    final failures = outcomes.where((outcome) => outcome.page == null);

    if (successes.isEmpty) {
      return _ActiveFetchResult(
        orders: previous,
        truncated: previousTruncated
            .where(kActiveOrderStatuses.contains)
            .toSet(),
        allFailed: true,
        anyFailed: true,
        error: failures.first.error,
      );
    }

    final merged = <String, OrderModel>{};
    final truncated = <String>{};
    for (final outcome in successes) {
      final page = outcome.page!;
      for (final order in page.orders) {
        merged[_orderKey(order)] = order;
      }
      if (page.pagination.hasNext) {
        truncated.add(outcome.status);
      }
    }

    final failedStatuses =
        failures.map((outcome) => outcome.status).toSet();
    for (final order in previous) {
      final status = order.rawStatus?.toLowerCase();
      if (status != null && failedStatuses.contains(status)) {
        merged.putIfAbsent(_orderKey(order), () => order);
      }
    }
    for (final status in failedStatuses) {
      if (previousTruncated.contains(status)) truncated.add(status);
    }

    return _ActiveFetchResult(
      orders: _sort(merged.values),
      truncated: truncated,
      allFailed: false,
      anyFailed: failures.isNotEmpty,
      error: failures.isNotEmpty ? failures.first.error : null,
    );
  }

  Future<_HistoryFetchResult> _fetchHistory(
    String restaurantId,
    OrderFilter filter, {
    int page = 1,
    OrdersHistoryPage? previous,
  }) async {
    if (filter == OrderFilter.cancelled) {
      return _fetchCancelled(restaurantId, previous: previous);
    }

    final status = filter.historyStatuses.isEmpty
        ? null
        : filter.historyStatuses.first;
    try {
      final result = await _repo.fetchOrders(
        restaurantId: restaurantId,
        status: status,
        page: page,
        limit: 25,
      );
      return _HistoryFetchResult(
        orders: result.orders,
        pagination: result.pagination,
        truncated: status != null && result.pagination.hasNext
            ? {status}
            : const {},
        anyFailed: false,
        allFailed: false,
      );
    } catch (e) {
      return _HistoryFetchResult(
        orders: previous?.orders ?? const [],
        pagination: previous?.pagination ??
            PaginationMeta(page: page, limit: 25, count: 0),
        truncated: const {},
        anyFailed: true,
        allFailed: true,
        error: e,
      );
    }
  }

  Future<_HistoryFetchResult> _fetchCancelled(
    String restaurantId, {
    OrdersHistoryPage? previous,
  }) async {
    const statuses = ['cancelled', 'rejected'];
    final outcomes = await Future.wait(
      statuses.map((status) async {
        try {
          final result = await _repo.fetchOrders(
            restaurantId: restaurantId,
            status: status,
            page: 1,
            limit: 25,
          );
          return _StatusOutcome.success(status, result);
        } catch (e) {
          return _StatusOutcome.failure(status, e);
        }
      }),
    );

    final successes = outcomes.where((outcome) => outcome.page != null);
    final failures = outcomes.where((outcome) => outcome.page == null);

    if (successes.isEmpty) {
      return _HistoryFetchResult(
        orders: previous?.orders ?? const [],
        pagination: previous?.pagination ??
            const PaginationMeta(page: 1, limit: 25, count: 0),
        truncated: const {},
        anyFailed: true,
        allFailed: true,
        error: failures.first.error,
      );
    }

    final merged = <String, OrderModel>{};
    final truncated = <String>{};
    var hasNext = false;
    for (final outcome in successes) {
      final result = outcome.page!;
      for (final order in result.orders) {
        merged[_orderKey(order)] = order;
      }
      if (result.pagination.hasNext) {
        truncated.add(outcome.status);
        hasNext = true;
      }
    }

    final failedStatuses =
        failures.map((outcome) => outcome.status).toSet();
    for (final order in previous?.orders ?? const <OrderModel>[]) {
      final status = order.rawStatus?.toLowerCase();
      if (status != null && failedStatuses.contains(status)) {
        merged.putIfAbsent(_orderKey(order), () => order);
      }
    }

    final orders = _sort(merged.values);
    return _HistoryFetchResult(
      orders: orders,
      pagination: PaginationMeta(
        page: 1,
        limit: 25,
        total: orders.length,
        hasNextPage: hasNext,
        hasPrevPage: false,
      ),
      truncated: truncated,
      anyFailed: failures.isNotEmpty,
      allFailed: false,
      error: failures.isNotEmpty ? failures.first.error : null,
    );
  }

  Set<String> _withActiveTruncation(
    Set<String> current,
    _ActiveFetchResult active,
  ) {
    final truncated = Set<String>.from(current);
    for (final status in kActiveOrderStatuses) {
      truncated.remove(status);
    }
    truncated.addAll(active.truncated);
    return truncated;
  }

  static String _orderKey(OrderModel order) {
    return order.id ?? order.orderNumber ?? '${order.rawStatus}_${order.hashCode}';
  }

  static List<OrderModel> _sort(Iterable<OrderModel> orders) {
    final list = orders.toList();
    list.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = DateTime.tryParse(b.createdAt ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return list;
  }
}

class _StatusOutcome {
  final String status;
  final OrdersPage? page;
  final Object? error;

  const _StatusOutcome.success(this.status, this.page) : error = null;

  const _StatusOutcome.failure(this.status, this.error) : page = null;
}

class _ActiveFetchResult {
  final List<OrderModel> orders;
  final Set<String> truncated;
  final bool allFailed;
  final bool anyFailed;
  final Object? error;

  const _ActiveFetchResult({
    required this.orders,
    required this.truncated,
    required this.allFailed,
    required this.anyFailed,
    this.error,
  });
}

class _HistoryFetchResult {
  final List<OrderModel> orders;
  final PaginationMeta pagination;
  final Set<String> truncated;
  final bool anyFailed;
  final bool allFailed;
  final Object? error;

  const _HistoryFetchResult({
    required this.orders,
    required this.pagination,
    required this.truncated,
    required this.anyFailed,
    required this.allFailed,
    this.error,
  });

  OrdersHistoryPage toPage({OrdersHistoryPage? previous}) {
    if (allFailed) {
      return (previous ?? const OrdersHistoryPage()).copyWith(
        isLoading: false,
        errorMessage: AppError.message(error!),
      );
    }
    return OrdersHistoryPage(
      orders: orders,
      pagination: pagination,
      isLoaded: true,
    );
  }
}
