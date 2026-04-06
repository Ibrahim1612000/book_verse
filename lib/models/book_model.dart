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
    // Open Library search.json format
    final title = json['title']?.toString() ?? 'Unknown Title';

    // Parse authors - can be list of strings or list of author objects
    List<String> parsedAuthors = [];
    if (json['authors'] != null) {
      final authorsList = json['authors'] as List;
      parsedAuthors = authorsList.map((author) {
        if (author is String) {
          return author;
        } else if (author is Map<String, dynamic> && author['name'] != null) {
          return author['name'].toString();
        }
        return 'Unknown Author';
      }).toList();
    }

    if (parsedAuthors.isEmpty) {
      parsedAuthors = ['Unknown Author'];
    }

    // Parse description
    String description = 'No description available.';
    if (json['description'] != null) {
      if (json['description'] is String) {
        description = json['description'];
      } else if (json['description'] is Map<String, dynamic>) {
        description =
            json['description']['value']?.toString() ??
            'No description available.';
      }
    }

    // Parse cover image
    String thumbnailUrl = '';
    if (json['cover_i'] != null) {
      final coverId = json['cover_i'];
      thumbnailUrl = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
    } else if (json['cover_edition_key'] != null) {
      // Fallback: try to get cover by edition key (less reliable)
      thumbnailUrl = '';
    }

    // Parse published date
    String publishedDate = 'Unknown';
    if (json['first_publish_year'] != null) {
      publishedDate = json['first_publish_year'].toString();
    } else if (json['publish_date'] != null) {
      publishedDate = json['publish_date'].toString();
    }

    // Parse categories/subjects
    List<String> parsedCategories = [];
    if (json['subject'] != null) {
      final subjectsList = json['subject'] as List;
      parsedCategories = subjectsList.take(5).map((e) => e.toString()).toList();
    }

    // Open Library doesn't provide ratings in search results
    double parsedRating = 0.0;

    return BookModel(
      id: json['key']?.toString() ?? json['edition_key']?.toString() ?? '',
      title: title,
      authors: parsedAuthors,
      description: description,
      thumbnail: thumbnailUrl,
      publishedDate: publishedDate,
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
        'imageLinks': {'thumbnail': thumbnail},
      },
    };
  }
}
