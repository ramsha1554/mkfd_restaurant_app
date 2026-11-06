// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get orderNumber => throw _privateConstructorUsedError;
  String? get restaurantId => throw _privateConstructorUsedError;
  OrderCustomer? get customer => throw _privateConstructorUsedError;
  OrderDriver? get driver => throw _privateConstructorUsedError;
  List<OrderItem>? get items => throw _privateConstructorUsedError;
  double? get subtotal => throw _privateConstructorUsedError;
  double? get deliveryFee => throw _privateConstructorUsedError;
  double? get driverFee => throw _privateConstructorUsedError;
  double? get platformFee => throw _privateConstructorUsedError;
  double? get commissionRate => throw _privateConstructorUsedError;
  double? get commissionAmount => throw _privateConstructorUsedError;
  double? get restaurantPayout => throw _privateConstructorUsedError;
  double? get total => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get paymentStatus => throw _privateConstructorUsedError;
  OrderStatus? get status => throw _privateConstructorUsedError;
  String? get rawStatus => throw _privateConstructorUsedError;
  List<OrderStatusEvent>? get statusHistory =>
      throw _privateConstructorUsedError;
  OrderAddress? get deliveryAddress => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;
  String? get acceptanceExpiresAt => throw _privateConstructorUsedError;
  String? get paymentExpiresAt => throw _privateConstructorUsedError;
  String? get estimatedDeliveryTime => throw _privateConstructorUsedError;
  String? get actualDeliveryTime => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  bool? get driverWaiting => throw _privateConstructorUsedError;
  bool? get driverArrived => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
    OrderModel value,
    $Res Function(OrderModel) then,
  ) = _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String? orderNumber,
    String? restaurantId,
    OrderCustomer? customer,
    OrderDriver? driver,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? driverFee,
    double? platformFee,
    double? commissionRate,
    double? commissionAmount,
    double? restaurantPayout,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    OrderStatus? status,
    String? rawStatus,
    List<OrderStatusEvent>? statusHistory,
    OrderAddress? deliveryAddress,
    String? specialInstructions,
    String? rejectionReason,
    String? cancellationReason,
    String? acceptanceExpiresAt,
    String? paymentExpiresAt,
    String? estimatedDeliveryTime,
    String? actualDeliveryTime,
    String? createdAt,
    String? updatedAt,
    bool? driverWaiting,
    bool? driverArrived,
  });

  $OrderCustomerCopyWith<$Res>? get customer;
  $OrderDriverCopyWith<$Res>? get driver;
  $OrderAddressCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNumber = freezed,
    Object? restaurantId = freezed,
    Object? customer = freezed,
    Object? driver = freezed,
    Object? items = freezed,
    Object? subtotal = freezed,
    Object? deliveryFee = freezed,
    Object? driverFee = freezed,
    Object? platformFee = freezed,
    Object? commissionRate = freezed,
    Object? commissionAmount = freezed,
    Object? restaurantPayout = freezed,
    Object? total = freezed,
    Object? paymentMethod = freezed,
    Object? paymentStatus = freezed,
    Object? status = freezed,
    Object? rawStatus = freezed,
    Object? statusHistory = freezed,
    Object? deliveryAddress = freezed,
    Object? specialInstructions = freezed,
    Object? rejectionReason = freezed,
    Object? cancellationReason = freezed,
    Object? acceptanceExpiresAt = freezed,
    Object? paymentExpiresAt = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? driverWaiting = freezed,
    Object? driverArrived = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderNumber: freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            restaurantId: freezed == restaurantId
                ? _value.restaurantId
                : restaurantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customer: freezed == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as OrderCustomer?,
            driver: freezed == driver
                ? _value.driver
                : driver // ignore: cast_nullable_to_non_nullable
                      as OrderDriver?,
            items: freezed == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>?,
            subtotal: freezed == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryFee: freezed == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double?,
            driverFee: freezed == driverFee
                ? _value.driverFee
                : driverFee // ignore: cast_nullable_to_non_nullable
                      as double?,
            platformFee: freezed == platformFee
                ? _value.platformFee
                : platformFee // ignore: cast_nullable_to_non_nullable
                      as double?,
            commissionRate: freezed == commissionRate
                ? _value.commissionRate
                : commissionRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            commissionAmount: freezed == commissionAmount
                ? _value.commissionAmount
                : commissionAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            restaurantPayout: freezed == restaurantPayout
                ? _value.restaurantPayout
                : restaurantPayout // ignore: cast_nullable_to_non_nullable
                      as double?,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus?,
            rawStatus: freezed == rawStatus
                ? _value.rawStatus
                : rawStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            statusHistory: freezed == statusHistory
                ? _value.statusHistory
                : statusHistory // ignore: cast_nullable_to_non_nullable
                      as List<OrderStatusEvent>?,
            deliveryAddress: freezed == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as OrderAddress?,
            specialInstructions: freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancellationReason: freezed == cancellationReason
                ? _value.cancellationReason
                : cancellationReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptanceExpiresAt: freezed == acceptanceExpiresAt
                ? _value.acceptanceExpiresAt
                : acceptanceExpiresAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentExpiresAt: freezed == paymentExpiresAt
                ? _value.paymentExpiresAt
                : paymentExpiresAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedDeliveryTime: freezed == estimatedDeliveryTime
                ? _value.estimatedDeliveryTime
                : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            actualDeliveryTime: freezed == actualDeliveryTime
                ? _value.actualDeliveryTime
                : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverWaiting: freezed == driverWaiting
                ? _value.driverWaiting
                : driverWaiting // ignore: cast_nullable_to_non_nullable
                      as bool?,
            driverArrived: freezed == driverArrived
                ? _value.driverArrived
                : driverArrived // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCustomerCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $OrderCustomerCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderDriverCopyWith<$Res>? get driver {
    if (_value.driver == null) {
      return null;
    }

    return $OrderDriverCopyWith<$Res>(_value.driver!, (value) {
      return _then(_value.copyWith(driver: value) as $Val);
    });
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderAddressCopyWith<$Res>? get deliveryAddress {
    if (_value.deliveryAddress == null) {
      return null;
    }

    return $OrderAddressCopyWith<$Res>(_value.deliveryAddress!, (value) {
      return _then(_value.copyWith(deliveryAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
    _$OrderModelImpl value,
    $Res Function(_$OrderModelImpl) then,
  ) = __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String? orderNumber,
    String? restaurantId,
    OrderCustomer? customer,
    OrderDriver? driver,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? driverFee,
    double? platformFee,
    double? commissionRate,
    double? commissionAmount,
    double? restaurantPayout,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    OrderStatus? status,
    String? rawStatus,
    List<OrderStatusEvent>? statusHistory,
    OrderAddress? deliveryAddress,
    String? specialInstructions,
    String? rejectionReason,
    String? cancellationReason,
    String? acceptanceExpiresAt,
    String? paymentExpiresAt,
    String? estimatedDeliveryTime,
    String? actualDeliveryTime,
    String? createdAt,
    String? updatedAt,
    bool? driverWaiting,
    bool? driverArrived,
  });

  @override
  $OrderCustomerCopyWith<$Res>? get customer;
  @override
  $OrderDriverCopyWith<$Res>? get driver;
  @override
  $OrderAddressCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
    _$OrderModelImpl _value,
    $Res Function(_$OrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNumber = freezed,
    Object? restaurantId = freezed,
    Object? customer = freezed,
    Object? driver = freezed,
    Object? items = freezed,
    Object? subtotal = freezed,
    Object? deliveryFee = freezed,
    Object? driverFee = freezed,
    Object? platformFee = freezed,
    Object? commissionRate = freezed,
    Object? commissionAmount = freezed,
    Object? restaurantPayout = freezed,
    Object? total = freezed,
    Object? paymentMethod = freezed,
    Object? paymentStatus = freezed,
    Object? status = freezed,
    Object? rawStatus = freezed,
    Object? statusHistory = freezed,
    Object? deliveryAddress = freezed,
    Object? specialInstructions = freezed,
    Object? rejectionReason = freezed,
    Object? cancellationReason = freezed,
    Object? acceptanceExpiresAt = freezed,
    Object? paymentExpiresAt = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? driverWaiting = freezed,
    Object? driverArrived = freezed,
  }) {
    return _then(
      _$OrderModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderNumber: freezed == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        restaurantId: freezed == restaurantId
            ? _value.restaurantId
            : restaurantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customer: freezed == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as OrderCustomer?,
        driver: freezed == driver
            ? _value.driver
            : driver // ignore: cast_nullable_to_non_nullable
                  as OrderDriver?,
        items: freezed == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>?,
        subtotal: freezed == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryFee: freezed == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double?,
        driverFee: freezed == driverFee
            ? _value.driverFee
            : driverFee // ignore: cast_nullable_to_non_nullable
                  as double?,
        platformFee: freezed == platformFee
            ? _value.platformFee
            : platformFee // ignore: cast_nullable_to_non_nullable
                  as double?,
        commissionRate: freezed == commissionRate
            ? _value.commissionRate
            : commissionRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        commissionAmount: freezed == commissionAmount
            ? _value.commissionAmount
            : commissionAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        restaurantPayout: freezed == restaurantPayout
            ? _value.restaurantPayout
            : restaurantPayout // ignore: cast_nullable_to_non_nullable
                  as double?,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus?,
        rawStatus: freezed == rawStatus
            ? _value.rawStatus
            : rawStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        statusHistory: freezed == statusHistory
            ? _value._statusHistory
            : statusHistory // ignore: cast_nullable_to_non_nullable
                  as List<OrderStatusEvent>?,
        deliveryAddress: freezed == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as OrderAddress?,
        specialInstructions: freezed == specialInstructions
            ? _value.specialInstructions
            : specialInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancellationReason: freezed == cancellationReason
            ? _value.cancellationReason
            : cancellationReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptanceExpiresAt: freezed == acceptanceExpiresAt
            ? _value.acceptanceExpiresAt
            : acceptanceExpiresAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentExpiresAt: freezed == paymentExpiresAt
            ? _value.paymentExpiresAt
            : paymentExpiresAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedDeliveryTime: freezed == estimatedDeliveryTime
            ? _value.estimatedDeliveryTime
            : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        actualDeliveryTime: freezed == actualDeliveryTime
            ? _value.actualDeliveryTime
            : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverWaiting: freezed == driverWaiting
            ? _value.driverWaiting
            : driverWaiting // ignore: cast_nullable_to_non_nullable
                  as bool?,
        driverArrived: freezed == driverArrived
            ? _value.driverArrived
            : driverArrived // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl({
    @JsonKey(name: '_id') this.id,
    this.orderNumber,
    this.restaurantId,
    this.customer,
    this.driver,
    final List<OrderItem>? items,
    this.subtotal,
    this.deliveryFee,
    this.driverFee,
    this.platformFee,
    this.commissionRate,
    this.commissionAmount,
    this.restaurantPayout,
    this.total,
    this.paymentMethod,
    this.paymentStatus,
    this.status,
    this.rawStatus,
    final List<OrderStatusEvent>? statusHistory,
    this.deliveryAddress,
    this.specialInstructions,
    this.rejectionReason,
    this.cancellationReason,
    this.acceptanceExpiresAt,
    this.paymentExpiresAt,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.createdAt,
    this.updatedAt,
    this.driverWaiting,
    this.driverArrived,
  }) : _items = items,
       _statusHistory = statusHistory;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? orderNumber;
  @override
  final String? restaurantId;
  @override
  final OrderCustomer? customer;
  @override
  final OrderDriver? driver;
  final List<OrderItem>? _items;
  @override
  List<OrderItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? subtotal;
  @override
  final double? deliveryFee;
  @override
  final double? driverFee;
  @override
  final double? platformFee;
  @override
  final double? commissionRate;
  @override
  final double? commissionAmount;
  @override
  final double? restaurantPayout;
  @override
  final double? total;
  @override
  final String? paymentMethod;
  @override
  final String? paymentStatus;
  @override
  final OrderStatus? status;
  @override
  final String? rawStatus;
  final List<OrderStatusEvent>? _statusHistory;
  @override
  List<OrderStatusEvent>? get statusHistory {
    final value = _statusHistory;
    if (value == null) return null;
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final OrderAddress? deliveryAddress;
  @override
  final String? specialInstructions;
  @override
  final String? rejectionReason;
  @override
  final String? cancellationReason;
  @override
  final String? acceptanceExpiresAt;
  @override
  final String? paymentExpiresAt;
  @override
  final String? estimatedDeliveryTime;
  @override
  final String? actualDeliveryTime;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final bool? driverWaiting;
  @override
  final bool? driverArrived;

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, restaurantId: $restaurantId, customer: $customer, driver: $driver, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, driverFee: $driverFee, platformFee: $platformFee, commissionRate: $commissionRate, commissionAmount: $commissionAmount, restaurantPayout: $restaurantPayout, total: $total, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, status: $status, rawStatus: $rawStatus, statusHistory: $statusHistory, deliveryAddress: $deliveryAddress, specialInstructions: $specialInstructions, rejectionReason: $rejectionReason, cancellationReason: $cancellationReason, acceptanceExpiresAt: $acceptanceExpiresAt, paymentExpiresAt: $paymentExpiresAt, estimatedDeliveryTime: $estimatedDeliveryTime, actualDeliveryTime: $actualDeliveryTime, createdAt: $createdAt, updatedAt: $updatedAt, driverWaiting: $driverWaiting, driverArrived: $driverArrived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.driverFee, driverFee) ||
                other.driverFee == driverFee) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate) &&
            (identical(other.commissionAmount, commissionAmount) ||
                other.commissionAmount == commissionAmount) &&
            (identical(other.restaurantPayout, restaurantPayout) ||
                other.restaurantPayout == restaurantPayout) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rawStatus, rawStatus) ||
                other.rawStatus == rawStatus) &&
            const DeepCollectionEquality().equals(
              other._statusHistory,
              _statusHistory,
            ) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.acceptanceExpiresAt, acceptanceExpiresAt) ||
                other.acceptanceExpiresAt == acceptanceExpiresAt) &&
            (identical(other.paymentExpiresAt, paymentExpiresAt) ||
                other.paymentExpiresAt == paymentExpiresAt) &&
            (identical(other.estimatedDeliveryTime, estimatedDeliveryTime) ||
                other.estimatedDeliveryTime == estimatedDeliveryTime) &&
            (identical(other.actualDeliveryTime, actualDeliveryTime) ||
                other.actualDeliveryTime == actualDeliveryTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.driverWaiting, driverWaiting) ||
                other.driverWaiting == driverWaiting) &&
            (identical(other.driverArrived, driverArrived) ||
                other.driverArrived == driverArrived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderNumber,
    restaurantId,
    customer,
    driver,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    deliveryFee,
    driverFee,
    platformFee,
    commissionRate,
    commissionAmount,
    restaurantPayout,
    total,
    paymentMethod,
    paymentStatus,
    status,
    rawStatus,
    const DeepCollectionEquality().hash(_statusHistory),
    deliveryAddress,
    specialInstructions,
    rejectionReason,
    cancellationReason,
    acceptanceExpiresAt,
    paymentExpiresAt,
    estimatedDeliveryTime,
    actualDeliveryTime,
    createdAt,
    updatedAt,
    driverWaiting,
    driverArrived,
  ]);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(this);
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel({
    @JsonKey(name: '_id') final String? id,
    final String? orderNumber,
    final String? restaurantId,
    final OrderCustomer? customer,
    final OrderDriver? driver,
    final List<OrderItem>? items,
    final double? subtotal,
    final double? deliveryFee,
    final double? driverFee,
    final double? platformFee,
    final double? commissionRate,
    final double? commissionAmount,
    final double? restaurantPayout,
    final double? total,
    final String? paymentMethod,
    final String? paymentStatus,
    final OrderStatus? status,
    final String? rawStatus,
    final List<OrderStatusEvent>? statusHistory,
    final OrderAddress? deliveryAddress,
    final String? specialInstructions,
    final String? rejectionReason,
    final String? cancellationReason,
    final String? acceptanceExpiresAt,
    final String? paymentExpiresAt,
    final String? estimatedDeliveryTime,
    final String? actualDeliveryTime,
    final String? createdAt,
    final String? updatedAt,
    final bool? driverWaiting,
    final bool? driverArrived,
  }) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get orderNumber;
  @override
  String? get restaurantId;
  @override
  OrderCustomer? get customer;
  @override
  OrderDriver? get driver;
  @override
  List<OrderItem>? get items;
  @override
  double? get subtotal;
  @override
  double? get deliveryFee;
  @override
  double? get driverFee;
  @override
  double? get platformFee;
  @override
  double? get commissionRate;
  @override
  double? get commissionAmount;
  @override
  double? get restaurantPayout;
  @override
  double? get total;
  @override
  String? get paymentMethod;
  @override
  String? get paymentStatus;
  @override
  OrderStatus? get status;
  @override
  String? get rawStatus;
  @override
  List<OrderStatusEvent>? get statusHistory;
  @override
  OrderAddress? get deliveryAddress;
  @override
  String? get specialInstructions;
  @override
  String? get rejectionReason;
  @override
  String? get cancellationReason;
  @override
  String? get acceptanceExpiresAt;
  @override
  String? get paymentExpiresAt;
  @override
  String? get estimatedDeliveryTime;
  @override
  String? get actualDeliveryTime;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  bool? get driverWaiting;
  @override
  bool? get driverArrived;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderCustomer _$OrderCustomerFromJson(Map<String, dynamic> json) {
  return _OrderCustomer.fromJson(json);
}

/// @nodoc
mixin _$OrderCustomer {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this OrderCustomer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderCustomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCustomerCopyWith<OrderCustomer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCustomerCopyWith<$Res> {
  factory $OrderCustomerCopyWith(
    OrderCustomer value,
    $Res Function(OrderCustomer) then,
  ) = _$OrderCustomerCopyWithImpl<$Res, OrderCustomer>;
  @useResult
  $Res call({@JsonKey(name: '_id') String? id, String? name, String? phone});
}

/// @nodoc
class _$OrderCustomerCopyWithImpl<$Res, $Val extends OrderCustomer>
    implements $OrderCustomerCopyWith<$Res> {
  _$OrderCustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCustomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phone = freezed,
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
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderCustomerImplCopyWith<$Res>
    implements $OrderCustomerCopyWith<$Res> {
  factory _$$OrderCustomerImplCopyWith(
    _$OrderCustomerImpl value,
    $Res Function(_$OrderCustomerImpl) then,
  ) = __$$OrderCustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String? id, String? name, String? phone});
}

/// @nodoc
class __$$OrderCustomerImplCopyWithImpl<$Res>
    extends _$OrderCustomerCopyWithImpl<$Res, _$OrderCustomerImpl>
    implements _$$OrderCustomerImplCopyWith<$Res> {
  __$$OrderCustomerImplCopyWithImpl(
    _$OrderCustomerImpl _value,
    $Res Function(_$OrderCustomerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCustomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phone = freezed,
  }) {
    return _then(
      _$OrderCustomerImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderCustomerImpl implements _OrderCustomer {
  const _$OrderCustomerImpl({
    @JsonKey(name: '_id') this.id,
    this.name,
    this.phone,
  });

  factory _$OrderCustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderCustomerImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? name;
  @override
  final String? phone;

  @override
  String toString() {
    return 'OrderCustomer(id: $id, name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone);

  /// Create a copy of OrderCustomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCustomerImplCopyWith<_$OrderCustomerImpl> get copyWith =>
      __$$OrderCustomerImplCopyWithImpl<_$OrderCustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderCustomerImplToJson(this);
  }
}

abstract class _OrderCustomer implements OrderCustomer {
  const factory _OrderCustomer({
    @JsonKey(name: '_id') final String? id,
    final String? name,
    final String? phone,
  }) = _$OrderCustomerImpl;

  factory _OrderCustomer.fromJson(Map<String, dynamic> json) =
      _$OrderCustomerImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get name;
  @override
  String? get phone;

  /// Create a copy of OrderCustomer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCustomerImplCopyWith<_$OrderCustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderDriver _$OrderDriverFromJson(Map<String, dynamic> json) {
  return _OrderDriver.fromJson(json);
}

/// @nodoc
mixin _$OrderDriver {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this OrderDriver to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDriver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDriverCopyWith<OrderDriver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDriverCopyWith<$Res> {
  factory $OrderDriverCopyWith(
    OrderDriver value,
    $Res Function(OrderDriver) then,
  ) = _$OrderDriverCopyWithImpl<$Res, OrderDriver>;
  @useResult
  $Res call({@JsonKey(name: '_id') String? id, String? name, String? phone});
}

/// @nodoc
class _$OrderDriverCopyWithImpl<$Res, $Val extends OrderDriver>
    implements $OrderDriverCopyWith<$Res> {
  _$OrderDriverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDriver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phone = freezed,
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
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderDriverImplCopyWith<$Res>
    implements $OrderDriverCopyWith<$Res> {
  factory _$$OrderDriverImplCopyWith(
    _$OrderDriverImpl value,
    $Res Function(_$OrderDriverImpl) then,
  ) = __$$OrderDriverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String? id, String? name, String? phone});
}

/// @nodoc
class __$$OrderDriverImplCopyWithImpl<$Res>
    extends _$OrderDriverCopyWithImpl<$Res, _$OrderDriverImpl>
    implements _$$OrderDriverImplCopyWith<$Res> {
  __$$OrderDriverImplCopyWithImpl(
    _$OrderDriverImpl _value,
    $Res Function(_$OrderDriverImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDriver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phone = freezed,
  }) {
    return _then(
      _$OrderDriverImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDriverImpl implements _OrderDriver {
  const _$OrderDriverImpl({
    @JsonKey(name: '_id') this.id,
    this.name,
    this.phone,
  });

  factory _$OrderDriverImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDriverImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? name;
  @override
  final String? phone;

  @override
  String toString() {
    return 'OrderDriver(id: $id, name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDriverImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone);

  /// Create a copy of OrderDriver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDriverImplCopyWith<_$OrderDriverImpl> get copyWith =>
      __$$OrderDriverImplCopyWithImpl<_$OrderDriverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDriverImplToJson(this);
  }
}

abstract class _OrderDriver implements OrderDriver {
  const factory _OrderDriver({
    @JsonKey(name: '_id') final String? id,
    final String? name,
    final String? phone,
  }) = _$OrderDriverImpl;

  factory _OrderDriver.fromJson(Map<String, dynamic> json) =
      _$OrderDriverImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get name;
  @override
  String? get phone;

  /// Create a copy of OrderDriver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDriverImplCopyWith<_$OrderDriverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String? get menuItemId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  double? get itemTotal => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String? menuItemId,
    String? name,
    double? price,
    int? quantity,
    double? itemTotal,
    String? specialInstructions,
  });
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? menuItemId = freezed,
    Object? name = freezed,
    Object? price = freezed,
    Object? quantity = freezed,
    Object? itemTotal = freezed,
    Object? specialInstructions = freezed,
  }) {
    return _then(
      _value.copyWith(
            menuItemId: freezed == menuItemId
                ? _value.menuItemId
                : menuItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            itemTotal: freezed == itemTotal
                ? _value.itemTotal
                : itemTotal // ignore: cast_nullable_to_non_nullable
                      as double?,
            specialInstructions: freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? menuItemId,
    String? name,
    double? price,
    int? quantity,
    double? itemTotal,
    String? specialInstructions,
  });
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? menuItemId = freezed,
    Object? name = freezed,
    Object? price = freezed,
    Object? quantity = freezed,
    Object? itemTotal = freezed,
    Object? specialInstructions = freezed,
  }) {
    return _then(
      _$OrderItemImpl(
        menuItemId: freezed == menuItemId
            ? _value.menuItemId
            : menuItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        itemTotal: freezed == itemTotal
            ? _value.itemTotal
            : itemTotal // ignore: cast_nullable_to_non_nullable
                  as double?,
        specialInstructions: freezed == specialInstructions
            ? _value.specialInstructions
            : specialInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    this.menuItemId,
    this.name,
    this.price,
    this.quantity,
    this.itemTotal,
    this.specialInstructions,
  });

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String? menuItemId;
  @override
  final String? name;
  @override
  final double? price;
  @override
  final int? quantity;
  @override
  final double? itemTotal;
  @override
  final String? specialInstructions;

  @override
  String toString() {
    return 'OrderItem(menuItemId: $menuItemId, name: $name, price: $price, quantity: $quantity, itemTotal: $itemTotal, specialInstructions: $specialInstructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.itemTotal, itemTotal) ||
                other.itemTotal == itemTotal) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    menuItemId,
    name,
    price,
    quantity,
    itemTotal,
    specialInstructions,
  );

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    final String? menuItemId,
    final String? name,
    final double? price,
    final int? quantity,
    final double? itemTotal,
    final String? specialInstructions,
  }) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String? get menuItemId;
  @override
  String? get name;
  @override
  double? get price;
  @override
  int? get quantity;
  @override
  double? get itemTotal;
  @override
  String? get specialInstructions;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderStatusEvent _$OrderStatusEventFromJson(Map<String, dynamic> json) {
  return _OrderStatusEvent.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusEvent {
  String? get status => throw _privateConstructorUsedError;
  String? get timestamp => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this OrderStatusEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusEventCopyWith<OrderStatusEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusEventCopyWith<$Res> {
  factory $OrderStatusEventCopyWith(
    OrderStatusEvent value,
    $Res Function(OrderStatusEvent) then,
  ) = _$OrderStatusEventCopyWithImpl<$Res, OrderStatusEvent>;
  @useResult
  $Res call({String? status, String? timestamp, String? note});
}

/// @nodoc
class _$OrderStatusEventCopyWithImpl<$Res, $Val extends OrderStatusEvent>
    implements $OrderStatusEventCopyWith<$Res> {
  _$OrderStatusEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? timestamp = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderStatusEventImplCopyWith<$Res>
    implements $OrderStatusEventCopyWith<$Res> {
  factory _$$OrderStatusEventImplCopyWith(
    _$OrderStatusEventImpl value,
    $Res Function(_$OrderStatusEventImpl) then,
  ) = __$$OrderStatusEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? status, String? timestamp, String? note});
}

/// @nodoc
class __$$OrderStatusEventImplCopyWithImpl<$Res>
    extends _$OrderStatusEventCopyWithImpl<$Res, _$OrderStatusEventImpl>
    implements _$$OrderStatusEventImplCopyWith<$Res> {
  __$$OrderStatusEventImplCopyWithImpl(
    _$OrderStatusEventImpl _value,
    $Res Function(_$OrderStatusEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? timestamp = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _$OrderStatusEventImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusEventImpl implements _OrderStatusEvent {
  const _$OrderStatusEventImpl({this.status, this.timestamp, this.note});

  factory _$OrderStatusEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusEventImplFromJson(json);

  @override
  final String? status;
  @override
  final String? timestamp;
  @override
  final String? note;

  @override
  String toString() {
    return 'OrderStatusEvent(status: $status, timestamp: $timestamp, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusEventImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, timestamp, note);

  /// Create a copy of OrderStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusEventImplCopyWith<_$OrderStatusEventImpl> get copyWith =>
      __$$OrderStatusEventImplCopyWithImpl<_$OrderStatusEventImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusEventImplToJson(this);
  }
}

abstract class _OrderStatusEvent implements OrderStatusEvent {
  const factory _OrderStatusEvent({
    final String? status,
    final String? timestamp,
    final String? note,
  }) = _$OrderStatusEventImpl;

  factory _OrderStatusEvent.fromJson(Map<String, dynamic> json) =
      _$OrderStatusEventImpl.fromJson;

  @override
  String? get status;
  @override
  String? get timestamp;
  @override
  String? get note;

  /// Create a copy of OrderStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusEventImplCopyWith<_$OrderStatusEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderAddress _$OrderAddressFromJson(Map<String, dynamic> json) {
  return _OrderAddress.fromJson(json);
}

/// @nodoc
mixin _$OrderAddress {
  String? get label => throw _privateConstructorUsedError;
  String? get fullAddress => throw _privateConstructorUsedError;
  String? get street => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get postcode => throw _privateConstructorUsedError;

  /// Serializes this OrderAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderAddressCopyWith<OrderAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderAddressCopyWith<$Res> {
  factory $OrderAddressCopyWith(
    OrderAddress value,
    $Res Function(OrderAddress) then,
  ) = _$OrderAddressCopyWithImpl<$Res, OrderAddress>;
  @useResult
  $Res call({
    String? label,
    String? fullAddress,
    String? street,
    String? city,
    String? postcode,
  });
}

/// @nodoc
class _$OrderAddressCopyWithImpl<$Res, $Val extends OrderAddress>
    implements $OrderAddressCopyWith<$Res> {
  _$OrderAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? fullAddress = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? postcode = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            fullAddress: freezed == fullAddress
                ? _value.fullAddress
                : fullAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderAddressImplCopyWith<$Res>
    implements $OrderAddressCopyWith<$Res> {
  factory _$$OrderAddressImplCopyWith(
    _$OrderAddressImpl value,
    $Res Function(_$OrderAddressImpl) then,
  ) = __$$OrderAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? label,
    String? fullAddress,
    String? street,
    String? city,
    String? postcode,
  });
}

/// @nodoc
class __$$OrderAddressImplCopyWithImpl<$Res>
    extends _$OrderAddressCopyWithImpl<$Res, _$OrderAddressImpl>
    implements _$$OrderAddressImplCopyWith<$Res> {
  __$$OrderAddressImplCopyWithImpl(
    _$OrderAddressImpl _value,
    $Res Function(_$OrderAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? fullAddress = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? postcode = freezed,
  }) {
    return _then(
      _$OrderAddressImpl(
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullAddress: freezed == fullAddress
            ? _value.fullAddress
            : fullAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderAddressImpl implements _OrderAddress {
  const _$OrderAddressImpl({
    this.label,
    this.fullAddress,
    this.street,
    this.city,
    this.postcode,
  });

  factory _$OrderAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderAddressImplFromJson(json);

  @override
  final String? label;
  @override
  final String? fullAddress;
  @override
  final String? street;
  @override
  final String? city;
  @override
  final String? postcode;

  @override
  String toString() {
    return 'OrderAddress(label: $label, fullAddress: $fullAddress, street: $street, city: $city, postcode: $postcode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderAddressImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, fullAddress, street, city, postcode);

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderAddressImplCopyWith<_$OrderAddressImpl> get copyWith =>
      __$$OrderAddressImplCopyWithImpl<_$OrderAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderAddressImplToJson(this);
  }
}

abstract class _OrderAddress implements OrderAddress {
  const factory _OrderAddress({
    final String? label,
    final String? fullAddress,
    final String? street,
    final String? city,
    final String? postcode,
  }) = _$OrderAddressImpl;

  factory _OrderAddress.fromJson(Map<String, dynamic> json) =
      _$OrderAddressImpl.fromJson;

  @override
  String? get label;
  @override
  String? get fullAddress;
  @override
  String? get street;
  @override
  String? get city;
  @override
  String? get postcode;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderAddressImplCopyWith<_$OrderAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
