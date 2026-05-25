class AppException implements Exception {
  const AppException(this.message, {this.code});
  final String message;
  final int? code;

  @override
  String toString() => 'AppException($code): $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message) : super(code: -1);
}

class ApiException extends AppException {
  const ApiException(super.message, {super.code});
}
