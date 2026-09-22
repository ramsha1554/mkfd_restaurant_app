/// Backend URLs — single source of truth via compile-time env.
abstract final class AppConfig {
  /// Base URL for REST — always read via `String.fromEnvironment`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://supplier-prewar-corrosive.ngrok-free.dev/api/v1',
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

  static const String appName = 'MK Foods Restaurant';
  static const String packageName = 'mk_food_restaurant';
  static const String bundleId = 'com.mokshasolutions.mkfoodsrestaurant';
  static const String logName = 'MKFoodsRestaurant';

  const AppConfig._();
}
