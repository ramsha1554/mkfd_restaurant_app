import '../constants/app_config.dart';

/// Resolves backend-relative media paths (`/uploads/...`) against the
/// base URL's origin (not its `/api/v1` path).
abstract final class MediaResolver {
  /// Resolve a possibly relative media path to an absolute URL.
  /// - If [path] is null/empty → returns null.
  /// - If [path] already absolute (`http…`) → returned as-is.
  /// - If [path] starts with `/` → resolved against [AppConfig.mediaOrigin].
  /// - Otherwise → treated as relative to origin.
  static String? resolve(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    final trimmed = path.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final origin = AppConfig.mediaOrigin;
    if (trimmed.startsWith('/')) {
      return '$origin$trimmed';
    }
    return '$origin/$trimmed';
  }

  /// Resolve with fallback — always returns a string (empty if null).
  static String resolveOrEmpty(String? path) => resolve(path) ?? '';

  const MediaResolver._();
}
