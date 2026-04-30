import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> write(String key, Map<String, dynamic> value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(value));
  }
  Future<Map<String, dynamic>?> read(String key) async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(key);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }
  Future<void> writeList(String key, List<Map<String, dynamic>> value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(value));
  }
  Future<List<dynamic>> readList(String key) async {
    final p = await SharedPreferences.getInstance();
    return jsonDecode(p.getString(key) ?? '[]') as List<dynamic>;
  }
  Future<void> remove(String key) async { final p = await SharedPreferences.getInstance(); await p.remove(key); }
}
