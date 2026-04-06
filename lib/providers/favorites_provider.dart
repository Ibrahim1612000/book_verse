import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';

class FavoritesProvider with ChangeNotifier {
  static const String _favoritesKey = 'favorite_books';
  List<BookModel> _favorites = [];

  List<BookModel> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  bool isFavorite(String id) {
    return _favorites.any((book) => book.id == id);
  }

  void toggleFavorite(BookModel book) {
    if (isFavorite(book.id)) {
      _favorites.removeWhere((b) => b.id == book.id);
    } else {
      _favorites.add(book);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson != null && favoritesJson.isNotEmpty) {
      final List<dynamic> decodedList = json.decode(favoritesJson);
      _favorites = decodedList.map((item) => BookModel.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(_favorites.map((b) => b.toJson()).toList());
    await prefs.setString(_favoritesKey, encodedList);
  }
}
