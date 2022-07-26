import 'dart:convert';

class AuthExceptions implements Exception {
  final int statusCode;
  final String message;
  final StackTrace? stackTrace;

  AuthExceptions(this.statusCode, this.message, [this.stackTrace]);

  String toJson() => jsonEncode({'error': message});

  @override
  String toString() =>
      'AuthExceptions(statusCode: $statusCode, message: $message, stackTrace: $stackTrace)';
}
