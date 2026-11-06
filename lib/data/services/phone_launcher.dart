import 'package:url_launcher/url_launcher.dart';

abstract interface class PhoneLauncher {
  Future<bool> call(String phone);
}

class UrlPhoneLauncher implements PhoneLauncher {
  const UrlPhoneLauncher();

  @override
  Future<bool> call(String phone) async {
    final number = phone.trim();
    if (number.isEmpty) return false;
    try {
      return await launchUrl(
        Uri.parse('tel:$number'),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}
