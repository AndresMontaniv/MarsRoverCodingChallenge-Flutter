class RoverException implements Exception {
  final String message;

  RoverException(this.message);

  @override
  String toString() => 'Error: $message.';
}

class RoverInputError extends RoverException {
  final dynamic invalidValue;
  final bool _hasValue;
  RoverInputError(super.message, [this.invalidValue]) : _hasValue = invalidValue != null;

  @override
  String toString() {
    final prefix = 'InputError: $message';
    return _hasValue ? "$prefix\n'$invalidValue' is not valid." : prefix;
  }
}
