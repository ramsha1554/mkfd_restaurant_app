import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/core/error/app_error.dart';
import 'package:mk_food_restaurant/data/models/restaurant.dart';
import 'package:mk_food_restaurant/data/repositories/restaurant_repository.dart';
import 'package:mk_food_restaurant/ui/features/shell/providers/restaurant_provider.dart';
import 'package:mk_food_restaurant/ui/features/shell/providers/restaurant_state.dart';

RestaurantModel _restaurant({
  bool isOpen = true,
  bool isBusy = false,
  String status = 'approved',
}) {
  return RestaurantModel(
    id: 'r1',
    name: 'Spice Garden',
    status: status,
    isOpen: isOpen,
    isBusy: isBusy,
  );
}

class _FakeRestaurantRepository implements RestaurantRepository {
  RestaurantModel? restaurant;
  Object? error;
  int updateCalls = 0;

  @override
  Future<RestaurantModel?> getMyRestaurant() async {
    if (error != null) throw error!;
    return restaurant;
  }

  @override
  Future<RestaurantModel?> updateStatus(
    String id, {
    bool? isOpen,
    bool? isBusy,
  }) async {
    updateCalls++;
    if (error != null) throw error!;
    restaurant = restaurant?.copyWith(
      isOpen: isOpen ?? restaurant?.isOpen,
      isBusy: isBusy ?? restaurant?.isBusy,
    );
    return restaurant;
  }
}

void main() {
  test('loads the restaurant', () async {
    final repo = _FakeRestaurantRepository()..restaurant = _restaurant();
    final notifier = RestaurantNotifier(repo);

    await notifier.load();

    expect(notifier.state.status, RestaurantLoadStatus.loaded);
    expect(notifier.state.restaurant?.name, 'Spice Garden');
    expect(notifier.state.isApproved, isTrue);
  });

  test('reports none when the owner has no restaurant', () async {
    final repo = _FakeRestaurantRepository();
    final notifier = RestaurantNotifier(repo);

    await notifier.load();

    expect(notifier.state.status, RestaurantLoadStatus.none);
    expect(notifier.state.restaurant, isNull);
  });

  test('toggles store open optimistically', () async {
    final repo = _FakeRestaurantRepository()..restaurant = _restaurant();
    final notifier = RestaurantNotifier(repo);
    await notifier.load();

    final error = await notifier.setOpen(false);

    expect(error, isNull);
    expect(repo.updateCalls, 1);
    expect(notifier.state.restaurant?.isOpen, isFalse);
    expect(notifier.state.isUpdatingOpen, isFalse);
  });

  test('rolls back the open toggle when the request fails', () async {
    final repo = _FakeRestaurantRepository()..restaurant = _restaurant();
    final notifier = RestaurantNotifier(repo);
    await notifier.load();

    repo.error = const NetworkException('offline');
    final error = await notifier.setOpen(false);

    expect(error, isNotNull);
    expect(notifier.state.restaurant?.isOpen, isTrue);
    expect(notifier.state.isUpdatingOpen, isFalse);
  });
}
