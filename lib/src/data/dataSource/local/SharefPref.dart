import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharefPref {
  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = json.encode(value);
    await prefs.setString(key, payload);
    print('[SharedPref] SAVE key=$key bytes=${payload.length}');
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw != null) {
      print('[SharedPref] READ key=$key bytes=${raw.length}');
      return json.decode(raw);
    }
    print('[SharedPref] No existe la key: $key');
    return null;
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.remove(key);
    print('[SharedPref] REMOVE key=$key ok=$ok');
    return ok;
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = prefs.containsKey(key);
    print('[SharedPref] CONTAINS key=$key -> $ok');
    return ok;
  }
}
