import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/app_log.dart';
import '../../../../data/repositories/restaurant_repository.dart';
import 'restaurant_state.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantState>((ref) {
  return RestaurantNotifier(locator<RestaurantRepository>());
});

class RestaurantNotifier extends StateNotifier<RestaurantState> {
  final RestaurantRepository _repo;

  RestaurantNotifier(this._repo) : super(const RestaurantState());

  Future<String?> load({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(
        status: RestaurantLoadStatus.loading,
        clearError: true,
      );
    }

    try {
      final restaurant = await _repo.getMyRestaurant();
      if (!mounted) return null;
      if (restaurant == null) {
        state = state.copyWith(
          status: RestaurantLoadStatus.none,
          clearRestaurant: true,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          status: RestaurantLoadStatus.loaded,
          restaurant: restaurant,
          clearError: true,
        );
      }
      return null;
    } catch (e, s) {
      AppLog.e('STORE', 'load', 'failed', e, s);
      if (!mounted) return null;
      final message = AppError.message(e);
      if (silent && state.status == RestaurantLoadStatus.loaded) {
        state = state.copyWith(errorMessage: message);
      } else {
        state = state.copyWith(
          status: RestaurantLoadStatus.error,
          errorMessage: message,
        );
      }
      return message;
    }
  }

  Future<String?> setOpen(bool value) async {
    if (state.isUpdatingOpen) return null;
    final current = state.restaurant;
    if (current == null || current.id == null) {
      return 'Restaurant is not loaded yet.';
    }

    final previous = current;
    state = state.copyWith(
      restaurant: current.copyWith(isOpen: value),
      isUpdatingOpen: true,
      clearError: true,
    );

    try {
      final updated = await _repo.updateStatus(current.id!, isOpen: value);
      if (!mounted) return null;
      state = state.copyWith(
        restaurant: updated ?? state.restaurant,
        isUpdatingOpen: false,
      );
      return null;
    } catch (e, s) {
      AppLog.e('STORE', 'setOpen', 'failed', e, s);
      if (!mounted) return null;
      state = state.copyWith(
        restaurant: previous,
        isUpdatingOpen: false,
      );
      return AppError.message(e);
    }
  }

  Future<String?> setBusy(bool value) async {
    if (state.isUpdatingBusy) return null;
    final current = state.restaurant;
    if (current == null || current.id == null) {
      return 'Restaurant is not loaded yet.';
    }

    final previous = current;
    state = state.copyWith(
      restaurant: current.copyWith(isBusy: value),
      isUpdatingBusy: true,
      clearError: true,
    );

    try {
      final updated = await _repo.updateStatus(current.id!, isBusy: value);
      if (!mounted) return null;
      state = state.copyWith(
        restaurant: updated ?? state.restaurant,
        isUpdatingBusy: false,
      );
      return null;
    } catch (e, s) {
      AppLog.e('STORE', 'setBusy', 'failed', e, s);
      if (!mounted) return null;
      state = state.copyWith(
        restaurant: previous,
        isUpdatingBusy: false,
      );
      return AppError.message(e);
    }
  }
}
