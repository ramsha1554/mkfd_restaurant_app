import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/locator.dart';
import '../../../../data/services/phone_launcher.dart';

final phoneLauncherProvider = Provider<PhoneLauncher>(
  (ref) => locator<PhoneLauncher>(),
);
