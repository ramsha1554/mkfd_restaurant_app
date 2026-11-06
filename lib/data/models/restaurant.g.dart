// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantModelImpl _$$RestaurantModelImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantModelImpl(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  cuisineType: (json['cuisineType'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] == null
      ? null
      : RestaurantAddress.fromJson(json['address'] as Map<String, dynamic>),
  location: json['location'] == null
      ? null
      : RestaurantLocation.fromJson(json['location'] as Map<String, dynamic>),
  minimumOrder: (json['minimumOrder'] as num?)?.toDouble(),
  deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
  preparationTime: (json['preparationTime'] as num?)?.toInt(),
  operatingHours: json['operatingHours'] as Map<String, dynamic>?,
  status: json['status'] as String?,
  isOpen: json['isOpen'] as bool?,
  isBusy: json['isBusy'] as bool?,
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  totalRatings: (json['totalRatings'] as num?)?.toInt(),
  logo: json['logo'] as String?,
  coverImage: json['coverImage'] as String?,
);

Map<String, dynamic> _$$RestaurantModelImplToJson(
  _$RestaurantModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cuisineType': instance.cuisineType,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'location': instance.location,
  'minimumOrder': instance.minimumOrder,
  'deliveryFee': instance.deliveryFee,
  'preparationTime': instance.preparationTime,
  'operatingHours': instance.operatingHours,
  'status': instance.status,
  'isOpen': instance.isOpen,
  'isBusy': instance.isBusy,
  'averageRating': instance.averageRating,
  'totalRatings': instance.totalRatings,
  'logo': instance.logo,
  'coverImage': instance.coverImage,
};

_$RestaurantAddressImpl _$$RestaurantAddressImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantAddressImpl(
  street: json['street'] as String?,
  city: json['city'] as String?,
  postcode: json['postcode'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$$RestaurantAddressImplToJson(
  _$RestaurantAddressImpl instance,
) => <String, dynamic>{
  'street': instance.street,
  'city': instance.city,
  'postcode': instance.postcode,
  'country': instance.country,
};

_$RestaurantLocationImpl _$$RestaurantLocationImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantLocationImpl(
  type: json['type'] as String?,
  coordinates: (json['coordinates'] as List<dynamic>?)
      ?.map((e) => e as num)
      .toList(),
);

Map<String, dynamic> _$$RestaurantLocationImplToJson(
  _$RestaurantLocationImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'coordinates': instance.coordinates,
};
