sealed class AppError implements Exception {
  const AppError(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  const NetworkError(super.message);
}

class CacheError extends AppError {
  const CacheError(super.message);
}
