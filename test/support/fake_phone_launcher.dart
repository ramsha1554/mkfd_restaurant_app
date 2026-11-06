import 'package:mk_food_restaurant/data/services/phone_launcher.dart';

class FakePhoneLauncher implements PhoneLauncher {
  bool result = true;
  final List<String> calls = [];

  @override
  Future<bool> call(String phone) async {
    calls.add(phone);
    return result;
  }
}
