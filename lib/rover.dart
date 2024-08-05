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
  /// Throws [ArgumentError] if the string does not represent a valid direction.
  static RoverDirection fromString(String s) {
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
    throw ArgumentError("Invalid direction: $s, options are [N, E, W, S]");
  }
}

/// Class representing a rover with its initial position, direction, and commands.
class Rover {
  /// The initial position of the rover as a tuple (x, y).
  final (int, int) initialPosition;

  /// The initial direction the rover is facing.
  final RoverDirection initialDirection;

  /// The commands for the rover to execute.
  final String commands;

  /// Constructs a [Rover] instance with the given position, direction, and commands.
  Rover(this.initialPosition, this.initialDirection, this.commands);

  /// Creates a [Rover] instance from a list of strings.
  ///
  /// The list must contain exactly 2 elements:
  /// 1. A string representing the initial position and direction in the format "X Y D".
  /// 2. A string containing the commands.
  ///
  /// Throws [AssertionError] if the input is invalid.
  factory Rover.fromIterableParam(List<String> params) {
    try {
      assert(params.length == 2, 'Iterable must contain 2 elements');

      final positionAndDirection = params[0].split(' ');
      assert(positionAndDirection.length == 3, 'Position and direction must contain 3 words: X Y D');

      final x = int.tryParse(positionAndDirection[0]);
      assert(x is int, 'The value of x must be an integer');
      final y = int.tryParse(positionAndDirection[1]);
      assert(y is int, 'The value of y must be an integer');

      final direction = positionAndDirection[2].toUpperCase();
      assert(direction.length == 1 && 'NEWS'.contains(direction), 'The direction must be a single letter: N, E, W, or S');

      final commands = params[1].toUpperCase();
      final validCommandsPattern = RegExp(r'^[LRM]+$');
      assert(validCommandsPattern.hasMatch(commands), 'Commands can only contain the letters L, R, or M');

      return Rover((x!, y!), RoverDirection.fromString(direction), commands);
    } catch (e) {
      throw AssertionError('Error parsing Rover info: $e');
    }
  }

  Future<String> getLastPosition(int maxRow, int maxCol) async {
    await Future.delayed(const Duration(milliseconds: 200));
    const outOfBoundMsg = 'Out of Bound!';
    try {
      int x = initialPosition.$1;
      int y = initialPosition.$2;
      RoverDirection direction = initialDirection;

      if (x > maxRow || y > maxCol) return outOfBoundMsg;

      List<String> commandList = commands.split('');

      while (commandList.isNotEmpty) {
        final command = commandList.removeAt(0);
        print(command);
        print('Before ($x , $y) ${direction.label} =>');
        switch (command) {
          case ('M'):
            switch (direction) {
              case RoverDirection.north:
                y++;
                break;
              case RoverDirection.east:
                x++;
                break;
              case RoverDirection.west:
                x--;
                break;
              case RoverDirection.south:
                y--;
                break;
            }
          case ('L'):
            direction = direction.toTheLeft;
            break;
          case ('R'):
            direction = direction.toTheRight;
            break;
          default:
            print('$command => Not valid command');
            throw Exception('$command is not a valid command');
        }
        print('After ($x , $y) ${direction.label}\n\n');
        if (x > maxRow || y > maxCol) return outOfBoundMsg;
      }

      return '$x $y ${direction.label}';
    } catch (e) {
      print(e.toString());
      throw Exception('An error occurred while getting the last position.');
    }
  }
}
