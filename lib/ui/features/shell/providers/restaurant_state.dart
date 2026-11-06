import '../../../../data/models/restaurant.dart';

enum RestaurantLoadStatus { loading, loaded, none, error }

class RestaurantState {
  final RestaurantLoadStatus status;
  final RestaurantModel? restaurant;
  final bool isUpdatingOpen;
  final bool isUpdatingBusy;
  final String? errorMessage;

  const RestaurantState({
    this.status = RestaurantLoadStatus.loading,
    this.restaurant,
    this.isUpdatingOpen = false,
    this.isUpdatingBusy = false,
    this.errorMessage,
  });

  RestaurantState copyWith({
    RestaurantLoadStatus? status,
    RestaurantModel? restaurant,
    bool? isUpdatingOpen,
    bool? isUpdatingBusy,
    String? errorMessage,
    bool clearRestaurant = false,
    bool clearError = false,
  }) {
    return RestaurantState(
      status: status ?? this.status,
      restaurant: clearRestaurant ? null : (restaurant ?? this.restaurant),
      isUpdatingOpen: isUpdatingOpen ?? this.isUpdatingOpen,
      isUpdatingBusy: isUpdatingBusy ?? this.isUpdatingBusy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isApproved =>
      restaurant?.status?.trim().toLowerCase() == 'approved';
  bool get isOpen => restaurant?.isOpen ?? false;
  bool get isBusy => restaurant?.isBusy ?? false;
}
