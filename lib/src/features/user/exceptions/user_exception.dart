import 'dart:convert';

class UserException implements Exception {
  final int statusCode;
  final String message;
  final StackTrace? stackTrace;

  UserException(this.statusCode, this.message, [this.stackTrace]);

  String toJson() => jsonEncode({'error': 'user => $message'});

  @override
  String toString() =>
      'AuthExceptions(statusCode: $statusCode, message: $message, stackTrace: $stackTrace)';
}
