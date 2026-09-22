import 'pagination_meta.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final PaginationMeta? pagination;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    final rawData = json['data'];
    T? data;
    if (rawData != null) {
      try {
        data = fromJsonT(rawData);
      } catch (_) {
        data = null;
      }
    }
    PaginationMeta? pagination;
    final rawPag = json['pagination'] ?? json['meta'];
    if (rawPag is Map<String, dynamic>) {
      pagination = PaginationMeta.fromJson(rawPag);
    }
    return ApiResponse<T>(
      success: success,
      message: message,
      data: data,
      pagination: pagination,
    );
  }
}
