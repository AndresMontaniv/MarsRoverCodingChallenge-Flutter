import 'dart:async';
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
  /// Throws [RoverInputError] if the input is invalid.
  factory Rover.fromIterableParam(List<String> params) {
    try {
      if (params.length != 2) {
        throw RoverInputError('Iterable must contain 2 elements');
      }

      final positionAndDirection = params[0].split(' ');
      positionAndDirection.removeWhere((e) => e.isEmpty);
      if (positionAndDirection.length != 3) {
        throw RoverInputError('Position and direction must contain 3 words: X Y D');
      }

      final x = int.tryParse(positionAndDirection[0]);
      if (x == null || x < 0) {
        throw RoverInputError('The value of x must be an integer greater or equal to 0', positionAndDirection[0]);
      }

      final y = int.tryParse(positionAndDirection[1]);
      if (y == null || y < 0) {
        throw RoverInputError('The value of y must be an integer greater or equal to 0', positionAndDirection[1]);
      }

      final direction = positionAndDirection[2].toUpperCase();
      if (direction.length != 1 || !'NEWS'.contains(direction)) {
        throw RoverInputError('The direction must be a single letter: N, E, W, or S', direction);
      }

      final commands = ParseIterableRoverCommand.fromString(params[1]);

      return Rover((x, y), RoverDirection.fromString(direction), commands);
    } catch (e) {
      rethrow;
    }
  }

  /// Calculates the last position of the rover after executing all commands.
  ///
  /// This method processes the rover's commands sequentially and updates its position and direction.
  /// If at any point the rover goes out of the specified bounds, it returns an "Out of Bound!" message.
  ///
  /// - Parameters:
  ///   - maxRow: The maximum allowable row the rover can be in.
  ///   - maxCol: The maximum allowable column the rover can be in.
  /// - Returns: A `Future` that resolves to a `String` representing the final position and direction of the rover
  ///            or an "Out of Bound!" message if the rover goes out of bounds.
  /// - Throws: `RoverException` if an error occurs while processing the commands.
  Future<String> getLastPosition(int maxRow, int maxCol) async {
    // Simulate a delay for processing the commands
    await Future.delayed(const Duration(milliseconds: 200));

    // Message to return if the rover goes out of bounds
    const outOfBoundMsg = 'Out of Bound!';

    try {
      // Initialize position and direction
      int x = initialPosition.$1;
      int y = initialPosition.$2;
      RoverDirection direction = initialDirection;

      // Check if the initial position is out of bounds
      if (x < 0 || x > maxRow || y < 0 || y > maxCol) {
        return outOfBoundMsg;
      }

      // Create a queue from the commands
      Queue<RoverCommand> commandQueue = Queue<RoverCommand>.from(commands);

      // Process each command in the queue
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

      // Return the final position and direction of the rover
      return '$x $y ${direction.label}';
    } catch (e) {
      // Throw a custom exception if an error occurs
      throw RoverException('An error occurred while getting the last position.');
    }
  }
}

extension ListRoverParsing on List<Rover> {
  static List<Rover> fromList(List<String> list) {
    if (list.length < 2 || list.length % 2 != 0) {
      throw RoverInputError('The input String must contain 2 lines for every rover');
    }
    try {
      List<Rover> rovers = [];
      for (var i = 0; i < list.length; i += 2) {
        final end = i + 2;
        if (end <= list.length) {
          rovers.add(Rover.fromIterableParam(list.sublist(i, end)));
        }
      }
      return rovers;
    } catch (e) {
      rethrow;
    }
  }
}
