import 'api_exception.dart';

String formatErrorMessage(Object error) {
  if (error is ApiException) {
    return error.message;
  }
  final raw = error.toString();
  if (raw.startsWith('Exception: ')) {
    return raw.substring('Exception: '.length);
  }
  return raw;
}
