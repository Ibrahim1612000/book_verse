class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnail;
  final String publishedDate;
  final double rating;
  final List<String> categories;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.publishedDate,
    required this.rating,
    required this.categories,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    
    // Parse authors
    final authorsList = volumeInfo['authors'] as List<dynamic>? ?? [];
    final List<String> parsedAuthors = authorsList.map((e) => e.toString()).toList();

    // Parse categories
    final categoriesList = volumeInfo['categories'] as List<dynamic>? ?? [];
    final List<String> parsedCategories = categoriesList.map((e) => e.toString()).toList();

    // Parse image links
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>? ?? {};
    String thumbnailUrl = imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'] ?? '';
    // Use https for images
    if (thumbnailUrl.startsWith('http:')) {
      thumbnailUrl = thumbnailUrl.replaceFirst('http:', 'https:');
    }

    // Parse rating
    double parsedRating = 0.0;
    if (volumeInfo['averageRating'] != null) {
      parsedRating = (volumeInfo['averageRating'] as num).toDouble();
    }

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Unknown Title',
      authors: parsedAuthors,
      description: volumeInfo['description'] ?? 'No description available.',
      thumbnail: thumbnailUrl,
      publishedDate: volumeInfo['publishedDate'] ?? 'Unknown',
      rating: parsedRating,
      categories: parsedCategories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volumeInfo': {
        'title': title,
        'authors': authors,
        'description': description,
        'publishedDate': publishedDate,
        'averageRating': rating,
        'categories': categories,
        'imageLinks': {
          'thumbnail': thumbnail,
        }
      }
    };
  }
}
