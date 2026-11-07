/// Backend URLs — single source of truth via compile-time env.
abstract final class AppConfig {
  /// Base URL for REST — always read via `String.fromEnvironment`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.mktours.co.uk/food/api/v1',
  );

  /// Production URL — verify before release (§6).
  static const String apiProdUrl =
      'https://api.mktours.co.uk/food/api/v1';

  /// Socket server is same origin without `/api/v1`.
  static String get socketUrl {
    final uri = Uri.parse(apiBaseUrl);
    final origin = '${uri.scheme}://${uri.host}'
        '${uri.hasPort ? ':${uri.port}' : ''}';
    return origin;
  }

  /// Media origin — used by [MediaResolver] to resolve `/uploads/...` paths.
  static String get mediaOrigin {
    final uri = Uri.parse(apiBaseUrl);
    return '${uri.scheme}://${uri.host}'
        '${uri.hasPort ? ':${uri.port}' : ''}';
  }

  /// OpenStreetMap raster tiles used by the registration map.
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Attribution required by the OpenStreetMap tile usage policy.
  static const String osmAttribution = '© OpenStreetMap contributors';

  static const String appName = 'MK Foods Restaurant';
  static const String appVersion = '1.0.0';
  static const String packageName = 'mk_food_restaurant';
  static const String bundleId = 'com.mokshasolutions.mkfoodsrestaurant';
  static const String logName = 'MKFoodsRestaurant';

  const AppConfig._();
}
