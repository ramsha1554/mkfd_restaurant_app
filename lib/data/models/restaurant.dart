// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

@freezed
class RestaurantModel with _$RestaurantModel {
  const factory RestaurantModel({
    @JsonKey(name: '_id') String? id,
    String? name,
    String? description,
    List<String>? cuisineType,
    String? phone,
    String? email,
    RestaurantAddress? address,
    RestaurantLocation? location,
    double? minimumOrder,
    double? deliveryFee,
    int? preparationTime,
    Map<String, dynamic>? operatingHours,
    String? status,
    bool? isOpen,
    bool? isBusy,
    double? averageRating,
    int? totalRatings,
    String? logo,
    String? coverImage,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
}

@freezed
class RestaurantAddress with _$RestaurantAddress {
  const factory RestaurantAddress({
    String? street,
    String? city,
    String? postcode,
    String? country,
  }) = _RestaurantAddress;

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) =>
      _$RestaurantAddressFromJson(json);
}

@freezed
class RestaurantLocation with _$RestaurantLocation {
  const factory RestaurantLocation({
    String? type,
    List<num>? coordinates,
  }) = _RestaurantLocation;

  factory RestaurantLocation.fromJson(Map<String, dynamic> json) =>
      _$RestaurantLocationFromJson(json);
}
