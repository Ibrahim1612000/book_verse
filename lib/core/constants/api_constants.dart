class ApiConstants {
  static const String baseUrl =
      'https://www.googleapis.com/books/v1/volumes?q=flutter';
  static const String volumesEndpoint = 'volumes';

  // NOTE: If you experience 429 errors (Too Many Requests), provide a Google Books API key here.
  // Leave it empty to use the unauthenticated API limit (which is very strict).
  static const String apiKey = '';
}
