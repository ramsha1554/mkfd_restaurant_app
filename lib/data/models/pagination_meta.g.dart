// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationMetaImpl _$$PaginationMetaImplFromJson(Map<String, dynamic> json) =>
    _$PaginationMetaImpl(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PaginationMetaImplToJson(
  _$PaginationMetaImpl instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
  'pages': instance.pages,
  'hasNextPage': instance.hasNextPage,
  'hasPrevPage': instance.hasPrevPage,
  'count': instance.count,
};
