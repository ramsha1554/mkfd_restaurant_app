import '../../../../data/models/order.dart';
import '../../../../data/models/pagination_meta.dart';
import '../models/order_filter.dart';

enum OrdersLoadStatus { idle, loading, loaded, error }

class OrdersHistoryPage {
  final List<OrderModel> orders;
  final PaginationMeta? pagination;
  final bool isLoaded;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const OrdersHistoryPage({
    this.orders = const [],
    this.pagination,
    this.isLoaded = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => pagination?.hasNext ?? false;

  OrdersHistoryPage copyWith({
    List<OrderModel>? orders,
    PaginationMeta? pagination,
    bool? isLoaded,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrdersHistoryPage(
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class OrdersState {
  final OrdersLoadStatus status;
  final String? restaurantId;
  final List<OrderModel> activeOrders;
  final Map<OrderFilter, OrdersHistoryPage> history;
  final OrderFilter filter;
  final Set<String> inFlightIds;
  final Set<String> truncatedStatuses;
  final bool isStale;
  final bool isOffline;
  final DateTime? lastUpdated;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersLoadStatus.idle,
    this.restaurantId,
    this.activeOrders = const [],
    this.history = const {},
    this.filter = OrderFilter.newOrders,
    this.inFlightIds = const {},
    this.truncatedStatuses = const {},
    this.isStale = false,
    this.isOffline = false,
    this.lastUpdated,
    this.errorMessage,
  });

  OrdersHistoryPage historyFor(OrderFilter value) {
    return history[value] ??
        OrdersHistoryPage(isLoading: status == OrdersLoadStatus.loading);
  }

  int countFor(OrderFilter value) {
    if (value.isActive) {
      return activeOrders.where(value.matches).length;
    }
    final page = history[value];
    if (page == null) return 0;
    if (value == OrderFilter.all || value == OrderFilter.delivered) {
      return page.pagination?.total ?? page.orders.length;
    }
    return page.orders.length;
  }

  bool isTruncated(OrderFilter value) {
    if (value.isActive) {
      return value.activeStatuses.any(truncatedStatuses.contains);
    }
    if (value == OrderFilter.cancelled) {
      return truncatedStatuses.contains('cancelled') ||
          truncatedStatuses.contains('rejected');
    }
    return history[value]?.hasMore ?? false;
  }

  bool get canLoadMore {
    if (filter != OrderFilter.all && filter != OrderFilter.delivered) {
      return false;
    }
    final page = history[filter];
    return page != null &&
        page.isLoaded &&
        page.hasMore &&
        !page.isLoadingMore;
  }

  OrdersState copyWith({
    OrdersLoadStatus? status,
    String? restaurantId,
    bool clearRestaurantId = false,
    List<OrderModel>? activeOrders,
    Map<OrderFilter, OrdersHistoryPage>? history,
    OrderFilter? filter,
    Set<String>? inFlightIds,
    Set<String>? truncatedStatuses,
    bool? isStale,
    bool? isOffline,
    DateTime? lastUpdated,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      restaurantId:
          clearRestaurantId ? null : (restaurantId ?? this.restaurantId),
      activeOrders: activeOrders ?? this.activeOrders,
      history: history ?? this.history,
      filter: filter ?? this.filter,
      inFlightIds: inFlightIds ?? this.inFlightIds,
      truncatedStatuses: truncatedStatuses ?? this.truncatedStatuses,
      isStale: isStale ?? this.isStale,
      isOffline: isOffline ?? this.isOffline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
