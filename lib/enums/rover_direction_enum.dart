import '../models/models.dart';

/// Enum representing the possible directions a rover can face.
enum RoverDirection {
  north,
  east,
  west,
  south;

  /// Returns the single-character label for the direction.
  String get label {
    switch (this) {
      case RoverDirection.north:
        return 'N';
      case RoverDirection.east:
        return 'E';
      case RoverDirection.west:
        return 'W';
      case RoverDirection.south:
        return 'S';
    }
  }

  /// Returns the direction to the left of the current direction.
  RoverDirection get toTheLeft {
    switch (this) {
      case RoverDirection.north:
        return RoverDirection.west;
      case RoverDirection.east:
        return RoverDirection.north;
      case RoverDirection.west:
        return RoverDirection.south;
      case RoverDirection.south:
        return RoverDirection.east;
    }
  }

  /// Returns the direction to the right of the current direction.
  RoverDirection get toTheRight {
    switch (this) {
      case RoverDirection.north:
        return RoverDirection.east;
      case RoverDirection.east:
        return RoverDirection.south;
      case RoverDirection.west:
        return RoverDirection.north;
      case RoverDirection.south:
        return RoverDirection.west;
    }
  }

  /// Converts a string to the corresponding [RoverDirection] enum value.
  ///
  /// Throws [RoverInputError] if the string does not represent a valid direction.
  static RoverDirection fromString(String s) {
    final valueUpperCase = s.toUpperCase();
    final validCommandPattern = RegExp(r'^[LRM]$');
    if (!validCommandPattern.hasMatch(valueUpperCase)) {
      throw RoverInputError('Command can only contain the letters N, E, W, S', valueUpperCase);
    }
    switch (s.toUpperCase()) {
      case 'N':
        return RoverDirection.north;
      case 'E':
        return RoverDirection.east;
      case 'W':
        return RoverDirection.west;
      case 'S':
        return RoverDirection.south;
    }
    throw RoverInputError("Invalid direction: $s, options are [N, E, W, S]");
  }
}
