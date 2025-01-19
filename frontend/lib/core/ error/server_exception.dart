import 'package:frontend/core/%20error/api_error.dart';

class ServerException implements Exception {
  final String errorMessage;
  final int statusCode;

  ServerException({required this.errorMessage, this.statusCode = 500});

  @override
  String toString() {
   
    final errorType = mapStatusCodeToApiError(statusCode);
    return """
      ServerException : $errorMessage,
      Status Code : $statusCode,
      ErrorType : $errorType
      """;
  }
}