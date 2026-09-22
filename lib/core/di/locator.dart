import 'package:get_it/get_it.dart';

/// Global service locator — single instance per §4.
final GetIt locator = GetIt.instance;

/// Called from [main] before `runApp`. In Phase 0 there are no
/// registrations yet; repositories/services are added in later phases.
Future<void> setupLocator() async {
  // Phase 0: no registrations required for splash-only build.
  // Future phases will register:
  //   AuthStorageService → ApiClient → Repositories
  //   → SocketService, NotificationService, PermissionService, FcmTokenManager
}
