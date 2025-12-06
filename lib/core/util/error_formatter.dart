import 'package:dio/dio.dart';

final class ErrorFormatter {
  static String formatError(dynamic error) {
    if (error is DioException) {
      return _formatDioError(error);
    }
    return error.toString();
  }

  static String _formatDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    
    switch (statusCode) {
      case 400:
        return 'Неверный запрос. Проверьте введенные данные.';
      case 401:
        return 'Сессия истекла. Пожалуйста, войдите снова.';
      case 403:
        return 'Доступ запрещен.';
      case 404:
        return 'Ресурс не найден.';
      case 500:
        return 'Ошибка сервера. Попробуйте позже.';
      case 502:
        return 'Сервер временно недоступен. Попробуйте позже.';
      case 503:
        return 'Сервис временно недоступен. Попробуйте позже.';
      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return 'Превышено время ожидания. Проверьте подключение к интернету.';
        }
        if (error.type == DioExceptionType.connectionError) {
          return 'Нет подключения к интернету. Проверьте соединение.';
        }
        // Пытаемся извлечь сообщение из ответа сервера
        final errorMessage = error.response?.data?['message'] ?? 
                           error.response?.data?['error'] ??
                           error.message;
        if (errorMessage != null && errorMessage is String) {
          return errorMessage;
        }
        return 'Произошла ошибка. Попробуйте позже.';
    }
  }
}

