// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) {
  return _RestaurantModel.fromJson(json);
}

/// @nodoc
mixin _$RestaurantModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get cuisineType => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  RestaurantAddress? get address => throw _privateConstructorUsedError;
  RestaurantLocation? get location => throw _privateConstructorUsedError;
  double? get minimumOrder => throw _privateConstructorUsedError;
  double? get deliveryFee => throw _privateConstructorUsedError;
  int? get preparationTime => throw _privateConstructorUsedError;
  Map<String, dynamic>? get operatingHours =>
      throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  bool? get isOpen => throw _privateConstructorUsedError;
  bool? get isBusy => throw _privateConstructorUsedError;
  double? get averageRating => throw _privateConstructorUsedError;
  int? get totalRatings => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  String? get coverImage => throw _privateConstructorUsedError;

  /// Serializes this RestaurantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantModelCopyWith<RestaurantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantModelCopyWith<$Res> {
  factory $RestaurantModelCopyWith(
    RestaurantModel value,
    $Res Function(RestaurantModel) then,
  ) = _$RestaurantModelCopyWithImpl<$Res, RestaurantModel>;
  @useResult
  $Res call({
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
  });

  $RestaurantAddressCopyWith<$Res>? get address;
  $RestaurantLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$RestaurantModelCopyWithImpl<$Res, $Val extends RestaurantModel>
    implements $RestaurantModelCopyWith<$Res> {
  _$RestaurantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? cuisineType = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? minimumOrder = freezed,
    Object? deliveryFee = freezed,
    Object? preparationTime = freezed,
    Object? operatingHours = freezed,
    Object? status = freezed,
    Object? isOpen = freezed,
    Object? isBusy = freezed,
    Object? averageRating = freezed,
    Object? totalRatings = freezed,
    Object? logo = freezed,
    Object? coverImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            cuisineType: freezed == cuisineType
                ? _value.cuisineType
                : cuisineType // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as RestaurantAddress?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as RestaurantLocation?,
            minimumOrder: freezed == minimumOrder
                ? _value.minimumOrder
                : minimumOrder // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryFee: freezed == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double?,
            preparationTime: freezed == preparationTime
                ? _value.preparationTime
                : preparationTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOpen: freezed == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isBusy: freezed == isBusy
                ? _value.isBusy
                : isBusy // ignore: cast_nullable_to_non_nullable
                      as bool?,
            averageRating: freezed == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalRatings: freezed == totalRatings
                ? _value.totalRatings
                : totalRatings // ignore: cast_nullable_to_non_nullable
                      as int?,
            logo: freezed == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverImage: freezed == coverImage
                ? _value.coverImage
                : coverImage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestaurantAddressCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $RestaurantAddressCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RestaurantLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $RestaurantLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RestaurantModelImplCopyWith<$Res>
    implements $RestaurantModelCopyWith<$Res> {
  factory _$$RestaurantModelImplCopyWith(
    _$RestaurantModelImpl value,
    $Res Function(_$RestaurantModelImpl) then,
  ) = __$$RestaurantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
  });

  @override
  $RestaurantAddressCopyWith<$Res>? get address;
  @override
  $RestaurantLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$RestaurantModelImplCopyWithImpl<$Res>
    extends _$RestaurantModelCopyWithImpl<$Res, _$RestaurantModelImpl>
    implements _$$RestaurantModelImplCopyWith<$Res> {
  __$$RestaurantModelImplCopyWithImpl(
    _$RestaurantModelImpl _value,
    $Res Function(_$RestaurantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? cuisineType = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? minimumOrder = freezed,
    Object? deliveryFee = freezed,
    Object? preparationTime = freezed,
    Object? operatingHours = freezed,
    Object? status = freezed,
    Object? isOpen = freezed,
    Object? isBusy = freezed,
    Object? averageRating = freezed,
    Object? totalRatings = freezed,
    Object? logo = freezed,
    Object? coverImage = freezed,
  }) {
    return _then(
      _$RestaurantModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        cuisineType: freezed == cuisineType
            ? _value._cuisineType
            : cuisineType // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as RestaurantAddress?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as RestaurantLocation?,
        minimumOrder: freezed == minimumOrder
            ? _value.minimumOrder
            : minimumOrder // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryFee: freezed == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double?,
        preparationTime: freezed == preparationTime
            ? _value.preparationTime
            : preparationTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        operatingHours: freezed == operatingHours
            ? _value._operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOpen: freezed == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isBusy: freezed == isBusy
            ? _value.isBusy
            : isBusy // ignore: cast_nullable_to_non_nullable
                  as bool?,
        averageRating: freezed == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalRatings: freezed == totalRatings
            ? _value.totalRatings
            : totalRatings // ignore: cast_nullable_to_non_nullable
                  as int?,
        logo: freezed == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverImage: freezed == coverImage
            ? _value.coverImage
            : coverImage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantModelImpl implements _RestaurantModel {
  const _$RestaurantModelImpl({
    @JsonKey(name: '_id') this.id,
    this.name,
    this.description,
    final List<String>? cuisineType,
    this.phone,
    this.email,
    this.address,
    this.location,
    this.minimumOrder,
    this.deliveryFee,
    this.preparationTime,
    final Map<String, dynamic>? operatingHours,
    this.status,
    this.isOpen,
    this.isBusy,
    this.averageRating,
    this.totalRatings,
    this.logo,
    this.coverImage,
  }) : _cuisineType = cuisineType,
       _operatingHours = operatingHours;

  factory _$RestaurantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  final List<String>? _cuisineType;
  @override
  List<String>? get cuisineType {
    final value = _cuisineType;
    if (value == null) return null;
    if (_cuisineType is EqualUnmodifiableListView) return _cuisineType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? phone;
  @override
  final String? email;
  @override
  final RestaurantAddress? address;
  @override
  final RestaurantLocation? location;
  @override
  final double? minimumOrder;
  @override
  final double? deliveryFee;
  @override
  final int? preparationTime;
  final Map<String, dynamic>? _operatingHours;
  @override
  Map<String, dynamic>? get operatingHours {
    final value = _operatingHours;
    if (value == null) return null;
    if (_operatingHours is EqualUnmodifiableMapView) return _operatingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? status;
  @override
  final bool? isOpen;
  @override
  final bool? isBusy;
  @override
  final double? averageRating;
  @override
  final int? totalRatings;
  @override
  final String? logo;
  @override
  final String? coverImage;

  @override
  String toString() {
    return 'RestaurantModel(id: $id, name: $name, description: $description, cuisineType: $cuisineType, phone: $phone, email: $email, address: $address, location: $location, minimumOrder: $minimumOrder, deliveryFee: $deliveryFee, preparationTime: $preparationTime, operatingHours: $operatingHours, status: $status, isOpen: $isOpen, isBusy: $isBusy, averageRating: $averageRating, totalRatings: $totalRatings, logo: $logo, coverImage: $coverImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._cuisineType,
              _cuisineType,
            ) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.minimumOrder, minimumOrder) ||
                other.minimumOrder == minimumOrder) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            const DeepCollectionEquality().equals(
              other._operatingHours,
              _operatingHours,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(_cuisineType),
    phone,
    email,
    address,
    location,
    minimumOrder,
    deliveryFee,
    preparationTime,
    const DeepCollectionEquality().hash(_operatingHours),
    status,
    isOpen,
    isBusy,
    averageRating,
    totalRatings,
    logo,
    coverImage,
  ]);

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantModelImplCopyWith<_$RestaurantModelImpl> get copyWith =>
      __$$RestaurantModelImplCopyWithImpl<_$RestaurantModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantModelImplToJson(this);
  }
}

abstract class _RestaurantModel implements RestaurantModel {
  const factory _RestaurantModel({
    @JsonKey(name: '_id') final String? id,
    final String? name,
    final String? description,
    final List<String>? cuisineType,
    final String? phone,
    final String? email,
    final RestaurantAddress? address,
    final RestaurantLocation? location,
    final double? minimumOrder,
    final double? deliveryFee,
    final int? preparationTime,
    final Map<String, dynamic>? operatingHours,
    final String? status,
    final bool? isOpen,
    final bool? isBusy,
    final double? averageRating,
    final int? totalRatings,
    final String? logo,
    final String? coverImage,
  }) = _$RestaurantModelImpl;

  factory _RestaurantModel.fromJson(Map<String, dynamic> json) =
      _$RestaurantModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get name;
  @override
  String? get description;
  @override
  List<String>? get cuisineType;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  RestaurantAddress? get address;
  @override
  RestaurantLocation? get location;
  @override
  double? get minimumOrder;
  @override
  double? get deliveryFee;
  @override
  int? get preparationTime;
  @override
  Map<String, dynamic>? get operatingHours;
  @override
  String? get status;
  @override
  bool? get isOpen;
  @override
  bool? get isBusy;
  @override
  double? get averageRating;
  @override
  int? get totalRatings;
  @override
  String? get logo;
  @override
  String? get coverImage;

  /// Create a copy of RestaurantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantModelImplCopyWith<_$RestaurantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RestaurantAddress _$RestaurantAddressFromJson(Map<String, dynamic> json) {
  return _RestaurantAddress.fromJson(json);
}

/// @nodoc
mixin _$RestaurantAddress {
  String? get street => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get postcode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;

  /// Serializes this RestaurantAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantAddressCopyWith<RestaurantAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantAddressCopyWith<$Res> {
  factory $RestaurantAddressCopyWith(
    RestaurantAddress value,
    $Res Function(RestaurantAddress) then,
  ) = _$RestaurantAddressCopyWithImpl<$Res, RestaurantAddress>;
  @useResult
  $Res call({String? street, String? city, String? postcode, String? country});
}

/// @nodoc
class _$RestaurantAddressCopyWithImpl<$Res, $Val extends RestaurantAddress>
    implements $RestaurantAddressCopyWith<$Res> {
  _$RestaurantAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = freezed,
    Object? city = freezed,
    Object? postcode = freezed,
    Object? country = freezed,
  }) {
    return _then(
      _value.copyWith(
            street: freezed == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            postcode: freezed == postcode
                ? _value.postcode
                : postcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestaurantAddressImplCopyWith<$Res>
    implements $RestaurantAddressCopyWith<$Res> {
  factory _$$RestaurantAddressImplCopyWith(
    _$RestaurantAddressImpl value,
    $Res Function(_$RestaurantAddressImpl) then,
  ) = __$$RestaurantAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? street, String? city, String? postcode, String? country});
}

/// @nodoc
class __$$RestaurantAddressImplCopyWithImpl<$Res>
    extends _$RestaurantAddressCopyWithImpl<$Res, _$RestaurantAddressImpl>
    implements _$$RestaurantAddressImplCopyWith<$Res> {
  __$$RestaurantAddressImplCopyWithImpl(
    _$RestaurantAddressImpl _value,
    $Res Function(_$RestaurantAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestaurantAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = freezed,
    Object? city = freezed,
    Object? postcode = freezed,
    Object? country = freezed,
  }) {
    return _then(
      _$RestaurantAddressImpl(
        street: freezed == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        postcode: freezed == postcode
            ? _value.postcode
            : postcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantAddressImpl implements _RestaurantAddress {
  const _$RestaurantAddressImpl({
    this.street,
    this.city,
    this.postcode,
    this.country,
  });

  factory _$RestaurantAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantAddressImplFromJson(json);

  @override
  final String? street;
  @override
  final String? city;
  @override
  final String? postcode;
  @override
  final String? country;

  @override
  String toString() {
    return 'RestaurantAddress(street: $street, city: $city, postcode: $postcode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantAddressImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, street, city, postcode, country);

  /// Create a copy of RestaurantAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantAddressImplCopyWith<_$RestaurantAddressImpl> get copyWith =>
      __$$RestaurantAddressImplCopyWithImpl<_$RestaurantAddressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantAddressImplToJson(this);
  }
}

abstract class _RestaurantAddress implements RestaurantAddress {
  const factory _RestaurantAddress({
    final String? street,
    final String? city,
    final String? postcode,
    final String? country,
  }) = _$RestaurantAddressImpl;

  factory _RestaurantAddress.fromJson(Map<String, dynamic> json) =
      _$RestaurantAddressImpl.fromJson;

  @override
  String? get street;
  @override
  String? get city;
  @override
  String? get postcode;
  @override
  String? get country;

  /// Create a copy of RestaurantAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantAddressImplCopyWith<_$RestaurantAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RestaurantLocation _$RestaurantLocationFromJson(Map<String, dynamic> json) {
  return _RestaurantLocation.fromJson(json);
}

/// @nodoc
mixin _$RestaurantLocation {
  String? get type => throw _privateConstructorUsedError;
  List<num>? get coordinates => throw _privateConstructorUsedError;

  /// Serializes this RestaurantLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantLocationCopyWith<RestaurantLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantLocationCopyWith<$Res> {
  factory $RestaurantLocationCopyWith(
    RestaurantLocation value,
    $Res Function(RestaurantLocation) then,
  ) = _$RestaurantLocationCopyWithImpl<$Res, RestaurantLocation>;
  @useResult
  $Res call({String? type, List<num>? coordinates});
}

/// @nodoc
class _$RestaurantLocationCopyWithImpl<$Res, $Val extends RestaurantLocation>
    implements $RestaurantLocationCopyWith<$Res> {
  _$RestaurantLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = freezed, Object? coordinates = freezed}) {
    return _then(
      _value.copyWith(
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            coordinates: freezed == coordinates
                ? _value.coordinates
                : coordinates // ignore: cast_nullable_to_non_nullable
                      as List<num>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestaurantLocationImplCopyWith<$Res>
    implements $RestaurantLocationCopyWith<$Res> {
  factory _$$RestaurantLocationImplCopyWith(
    _$RestaurantLocationImpl value,
    $Res Function(_$RestaurantLocationImpl) then,
  ) = __$$RestaurantLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? type, List<num>? coordinates});
}

/// @nodoc
class __$$RestaurantLocationImplCopyWithImpl<$Res>
    extends _$RestaurantLocationCopyWithImpl<$Res, _$RestaurantLocationImpl>
    implements _$$RestaurantLocationImplCopyWith<$Res> {
  __$$RestaurantLocationImplCopyWithImpl(
    _$RestaurantLocationImpl _value,
    $Res Function(_$RestaurantLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestaurantLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = freezed, Object? coordinates = freezed}) {
    return _then(
      _$RestaurantLocationImpl(
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        coordinates: freezed == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<num>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantLocationImpl implements _RestaurantLocation {
  const _$RestaurantLocationImpl({this.type, final List<num>? coordinates})
    : _coordinates = coordinates;

  factory _$RestaurantLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantLocationImplFromJson(json);

  @override
  final String? type;
  final List<num>? _coordinates;
  @override
  List<num>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RestaurantLocation(type: $type, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantLocationImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._coordinates,
              _coordinates,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_coordinates),
  );

  /// Create a copy of RestaurantLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantLocationImplCopyWith<_$RestaurantLocationImpl> get copyWith =>
      __$$RestaurantLocationImplCopyWithImpl<_$RestaurantLocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantLocationImplToJson(this);
  }
}

abstract class _RestaurantLocation implements RestaurantLocation {
  const factory _RestaurantLocation({
    final String? type,
    final List<num>? coordinates,
  }) = _$RestaurantLocationImpl;

  factory _RestaurantLocation.fromJson(Map<String, dynamic> json) =
      _$RestaurantLocationImpl.fromJson;

  @override
  String? get type;
  @override
  List<num>? get coordinates;

  /// Create a copy of RestaurantLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantLocationImplCopyWith<_$RestaurantLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
