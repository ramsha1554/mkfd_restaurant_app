// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['_id'] as String?,
  phone: json['phone'] as String?,
  name: json['name'] as String?,
  role: json['role'] as String?,
  isVerified: json['isVerified'] as bool?,
  isNewUser: json['isNewUser'] as bool?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': instance.role,
      'isVerified': instance.isVerified,
      'isNewUser': instance.isNewUser,
    };
