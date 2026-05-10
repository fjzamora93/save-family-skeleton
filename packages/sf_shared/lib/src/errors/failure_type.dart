import 'api_exception.dart';
import 'domain_exception.dart';

enum FailureType {
  connection,
  technical,
  notAuthorized,
  validation,
  notFound,
  conflict,
  rateLimit,
  userFacingDomain,
  other;

  static FailureType fromException(Object? exception) {
    if (exception is DomainException) {
      return FailureType.userFacingDomain;
    }
    if (exception is ApiException) {
      if (exception.isNetworkError) return FailureType.connection;
      final status = exception.statusCode;
      if (status == null) return FailureType.other;
      return switch (status) {
        401 || 403 => FailureType.notAuthorized,
        404 => FailureType.notFound,
        409 => FailureType.conflict,
        422 => FailureType.validation,
        429 => FailureType.rateLimit,
        >= 500 => FailureType.technical,
        _ => FailureType.other,
      };
    }
    return FailureType.other;
  }
}
