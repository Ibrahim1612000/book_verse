import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';

class BookProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Home Screen State
  List<BookModel> _homeBooks = [];
  bool _isLoadingHome = false;
  String? _homeError;
  String _currentCategory = "Fiction";
  int _homeStartIndex = 0;
  bool _hasMoreHome = true;
  bool _isLoadingMoreHome = false;

  // Search Screen State
  List<BookModel> _searchResults = [];
  bool _isLoadingSearch = false;
  String? _searchError;
  String _currentQuery = "";
  int _searchStartIndex = 0;
  bool _hasMoreSearch = true;
  bool _isLoadingMoreSearch = false;

  // Getters Home
  List<BookModel> get homeBooks => _homeBooks;
  bool get isLoadingHome => _isLoadingHome;
  String? get homeError => _homeError;
  String get currentCategory => _currentCategory;
  bool get isLoadingMoreHome => _isLoadingMoreHome;
  bool get hasMoreHome => _hasMoreHome;

  // Getters Search
  List<BookModel> get searchResults => _searchResults;
  bool get isLoadingSearch => _isLoadingSearch;
  String? get searchError => _searchError;
  bool get isLoadingMoreSearch => _isLoadingMoreSearch;
  bool get hasMoreSearch => _hasMoreSearch;

  BookProvider() {
    // Initial fetch
    fetchHomeBooks();
  }

  void setCategory(String category) {
    if (_currentCategory == category) return;
    _currentCategory = category;
    _homeStartIndex = 0;
    _homeBooks = [];
    _hasMoreHome = true;
    _homeError = null;
    fetchHomeBooks();
  }

  Future<void> fetchHomeBooks({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMoreHome || !_hasMoreHome) return;
      _isLoadingMoreHome = true;
      notifyListeners();
    } else {
      _isLoadingHome = true;
      _homeError = null;
      notifyListeners();
    }

    try {
      final query = 'subject:$_currentCategory';
      final newBooks = await _apiService.searchBooks(query, startIndex: _homeStartIndex);
      
      if (newBooks.isEmpty) {
        _hasMoreHome = false;
      } else {
        if (loadMore) {
          _homeBooks.addAll(newBooks);
        } else {
          _homeBooks = newBooks;
        }
        _homeStartIndex += 20; // Default maxResults is 20
      }
    } catch (e) {
      if (!loadMore) {
        _homeError = e.toString();
      }
      // If error on loadMore, just ignore or handle via a toaster (UI)
    } finally {
      if (loadMore) {
        _isLoadingMoreHome = false;
      } else {
        _isLoadingHome = false;
      }
      notifyListeners();
    }
  }

  Future<void> searchBooks(String query, {bool loadMore = false}) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _currentQuery = "";
      _searchError = null;
      notifyListeners();
      return;
    }

    if (!loadMore) {
      _currentQuery = query;
      _searchStartIndex = 0;
      _searchResults = [];
      _hasMoreSearch = true;
      _searchError = null;
      _isLoadingSearch = true;
      notifyListeners();
    } else {
      if (_isLoadingMoreSearch || !_hasMoreSearch) return;
      _isLoadingMoreSearch = true;
      notifyListeners();
    }

    try {
      final newBooks = await _apiService.searchBooks(_currentQuery, startIndex: _searchStartIndex);
      
      if (newBooks.isEmpty) {
        _hasMoreSearch = false;
      } else {
        if (loadMore) {
          _searchResults.addAll(newBooks);
        } else {
          _searchResults = newBooks;
        }
        _searchStartIndex += 20;
      }
    } catch (e) {
      if (!loadMore) {
        _searchError = e.toString();
      }
    } finally {
      if (loadMore) {
        _isLoadingMoreSearch = false;
      } else {
        _isLoadingSearch = false;
      }
      notifyListeners();
    }
  }
}
