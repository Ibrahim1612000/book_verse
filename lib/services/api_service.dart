import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/book_model.dart';

class ApiService {
  Future<List<BookModel>> searchBooks(
    String query, {
    int startIndex = 0,
    int maxResults = 20,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}?q=$query&offset=$startIndex&limit=$maxResults',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['docs'] != null) {
          final docs = data['docs'] as List;
          return docs.map((doc) => BookModel.fromJson(doc)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed fetching data: $e');
    }
  }
}
