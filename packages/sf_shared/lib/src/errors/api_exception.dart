class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.isNetworkError = false,
  });

  final String message;
  final int? statusCode;
  final bool isNetworkError;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

String formatErrorMessage(Object error) {
  if (error is ApiException) return error.message;
  final raw = error.toString();
  if (raw.startsWith('Exception: ')) {
    return raw.substring('Exception: '.length);
  }
  return raw;
}
