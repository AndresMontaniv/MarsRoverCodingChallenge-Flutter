class RoverException implements Exception {
  final String message;

  RoverException(this.message);

  @override
  String toString() => 'RoverException: $message';
}
