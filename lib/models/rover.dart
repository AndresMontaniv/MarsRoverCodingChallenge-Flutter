import 'dart:collection';

import '../enums/enums.dart';
import './rover_exception.dart';

/// Class representing a rover with its initial position, direction, and commands.
class Rover {
  /// The initial position of the rover as a tuple (x, y).
  final (int, int) initialPosition;

  /// The initial direction the rover is facing.
  final RoverDirection initialDirection;

  /// The commands for the rover to execute.
  final Iterable<RoverCommand> commands;

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
      if (params.length != 2) {
        throw ArgumentError('Iterable must contain 2 elements');
      }

      final positionAndDirection = params[0].split(' ');
      positionAndDirection.removeWhere((e) => e.isEmpty);
      if (positionAndDirection.length != 3) {
        throw ArgumentError('Position and direction must contain 3 words: X Y D');
      }

      final x = int.tryParse(positionAndDirection[0]);
      if (x == null || x < 0) {
        throw ArgumentError("The value of x must be an integer greater or equal to 0.\n'$x' is not valid");
      }

      final y = int.tryParse(positionAndDirection[1]);
      if (y == null || y < 0) {
        throw ArgumentError("The value of y must be an integer greater or equal to 0.\n'$y' is not valid");
      }

      final direction = positionAndDirection[2].toUpperCase();
      if (direction.length != 1 || !'NEWS'.contains(direction)) {
        throw ArgumentError("The direction must be a single letter: N, E, W, or S.\n '$direction' is not valid.");
      }

      final commands = ParseIterableRoverCommand.fromString(params[1]);

      return Rover((x, y), RoverDirection.fromString(direction), commands);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getLastPosition(int maxRow, int maxCol) async {
    await Future.delayed(const Duration(milliseconds: 200));
    const outOfBoundMsg = 'Out of Bound!';
    try {
      int x = initialPosition.$1;
      int y = initialPosition.$2;
      RoverDirection direction = initialDirection;

      if (x < 0 || x > maxRow || y < 0 || y > maxCol) {
        return outOfBoundMsg;
      }

      Queue<RoverCommand> commandQueue = Queue<RoverCommand>.from(commands);

      while (commandQueue.isNotEmpty) {
        final command = commandQueue.removeFirst();
        switch (command) {
          case (RoverCommand.move):
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
            break;
          case (RoverCommand.left):
            direction = direction.toTheLeft;
            break;
          case (RoverCommand.right):
            direction = direction.toTheRight;
            break;
        }
        // Check if position is out of bounds after the command
        if (x < 0 || x > maxRow || y < 0 || y > maxCol) {
          return outOfBoundMsg;
        }
      }

      return '$x $y ${direction.label}';
    } catch (e) {
      throw RoverException('An error occurred while getting the last position.');
    }
  }
}
