import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchProvider with ChangeNotifier {
  List<Map<String, String>> _recentSearches = [];

  List<Map<String, String>> get recentSearches => _recentSearches;

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final rawList = prefs.getStringList('recent_searches_$userId') ?? [];
    _recentSearches = rawList.map((e) => Map<String, String>.from(json.decode(e))).toList();
    notifyListeners();
  }

  Future<void> addRecentSearch(String productId, String productName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final key = 'recent_searches_$userId';
    final existingRaw = prefs.getStringList(key) ?? [];
    List<Map<String, String>> existing = existingRaw
        .map((e) => Map<String, String>.from(json.decode(e)))
        .toList();

    existing.removeWhere((item) => item['id'] == productId);

    existing.insert(0, {'id': productId, 'name': productName});

    final encoded = existing.map((e) => json.encode(e)).toList();
    await prefs.setStringList(key, encoded);
    _recentSearches = existing;
    notifyListeners();
  }

  Future<void> removeRecentSearch(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final key = 'recent_searches_$userId';
    final existingRaw = prefs.getStringList(key) ?? [];
    List<Map<String, String>> existing = existingRaw
        .map((e) => Map<String, String>.from(json.decode(e)))
        .toList();

    existing.removeWhere((item) => item['id'] == productId);

    final encoded = existing.map((e) => json.encode(e)).toList();
    await prefs.setStringList(key, encoded);
    _recentSearches = existing;
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    await prefs.remove('recent_searches_$userId');
    _recentSearches = [];
    notifyListeners();
  }
}
