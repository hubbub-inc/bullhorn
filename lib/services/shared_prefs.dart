import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }


  String get uid => _sharedPrefs?.getString(keyUid) ?? "";
  set uid(String value) {
    _sharedPrefs?.setString(keyUid, value);
  }

}

const String keyUid = "key_uid";
final sharedPrefs = SharedPrefs();
