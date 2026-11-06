import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_meta.freezed.dart';
part 'pagination_meta.g.dart';

@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    int? pages,
    bool? hasNextPage,
    bool? hasPrevPage,
    int? count,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

extension PaginationMetaX on PaginationMeta {
  bool get hasNext {
    if (hasNextPage != null) return hasNextPage!;
    final current = page;
    final last = pages ?? totalPages;
    return current != null && last != null && current < last;
  }
}
