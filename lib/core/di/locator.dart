import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../data/services/auth_storage_service.dart';
import '../../data/services/phone_launcher.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  const secure = FlutterSecureStorage();
  final storage = AuthStorageService(secure, prefs);
  locator.registerSingleton<AuthStorageService>(storage);

  final apiClient = ApiClient(storage);
  locator.registerSingleton<ApiClient>(apiClient);

  locator.registerLazySingleton<PhoneLauncher>(() => const UrlPhoneLauncher());

  locator.registerSingleton<AuthRepository>(AuthRepository(apiClient, storage));

  locator.registerSingleton<RestaurantRepository>(
    RestaurantRepository(apiClient),
  );

  locator.registerSingleton<OrderRepository>(OrderRepository(apiClient));
}
