class AppFailure {
  final String message;
  AppFailure([this.message = "Unexpected error occured!"]);

  @override
  String toString() => 'Error(message: $message)';
}
