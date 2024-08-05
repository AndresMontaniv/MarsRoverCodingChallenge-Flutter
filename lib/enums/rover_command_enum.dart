/// Enum representing the possible commands a rover can read.
enum RoverCommand {
  left,
  right,
  move;

  /// Returns the single-character label for the direction.
  String get label {
    switch (this) {
      case RoverCommand.left:
        return 'L';
      case RoverCommand.right:
        return 'R';
      case RoverCommand.move:
        return 'M';
    }
  }

  /// Converts a string to the corresponding [RoverCommand] enum value.
  ///
  /// Throws [ArgumentError] if the string does not represent a valid direction.
  static RoverCommand fromString(String s) {
    final valueUpperCase = s.toUpperCase();
    final validCommandPattern = RegExp(r'^[LRM]$');
    if (!validCommandPattern.hasMatch(valueUpperCase)) {
      throw FormatException("Command can only contain the letters L, R, or M.\n'$valueUpperCase is not valid.");
    }
    switch (valueUpperCase) {
      case 'L':
        return RoverCommand.left;
      case 'R':
        return RoverCommand.right;
      case 'M':
        return RoverCommand.move;
    }
    throw FormatException("Invalid command: $s, options are [L, R, M]");
  }
}

/// An extension on `Iterable<RoverCommand>` to parse a string of rover commands.
extension ParseIterableRoverCommand on Iterable<RoverCommand> {
  /// Creates an `Iterable<RoverCommand>` from a given string of commands.
  ///
  /// The input string should contain commands consisting of the letters 'L', 'R', and 'M'.
  /// Each command represents a specific action for the rover.
  /// The string can contain spaces, which will be ignored.
  /// Throws a `FormatException` if the string contains invalid commands or is empty.
  ///
  /// Example:
  /// ```dart
  /// var commands = ParseIterableRoverCommand.fromString('LRM');
  /// ```
  ///
  /// - [value]: The string containing the commands to parse.
  /// - Returns: An `Iterable<RoverCommand>` representing the parsed commands.
  static Iterable<RoverCommand> fromString(String value) {
    // Remove spaces and convert to uppercase
    final valueNoSpaces = value.trim().replaceAll(' ', '').toUpperCase();

    // Regular expression to validate the commands
    final validCommandsPattern = RegExp(r'^[LRM]+$');

    // Check if the input is empty
    if (valueNoSpaces.isEmpty) {
      throw const FormatException("Commands must have at least 1 letter and can only contain the letters L, R, or M.");
    }

    // Validate the commands against the pattern
    if (!validCommandsPattern.hasMatch(valueNoSpaces)) {
      throw FormatException("Command can only contain the letters L, R, or M.\n'$valueNoSpaces is not valid.");
    }

    // Convert the string to a list of `RoverCommand`
    return valueNoSpaces.split('').map((e) => RoverCommand.fromString(e));
  }
}
