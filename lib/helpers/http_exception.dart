class HttpExceptionHelper implements Exception {
  final String message;

  HttpExceptionHelper(this.message);

  @override
  String toString() {
    return message;
  }
}
