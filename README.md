# Mars Rover Coding Challenge

## Overview

A squad of robotic rovers are to be landed by NASA on a plateau on Mars. This plateau,
which is curiously rectangular, must be navigated by the rovers so that their on-board
cameras can get a complete view of the surrounding terrain to send back to Earth.
A rover's position and location are represented by a combination of x and y coordinates
and a letter representing one of the four cardinal compass points. The plateau is divided
up into a grid to simplify navigation. An example position might be 0, 0, N, which
means the rover is in the bottom left corner and facing North.
To control a rover, NASA sends a simple string of letters. The possible letters are 'L', 'R'
and 'M'. 'L' and 'R' makes the rover spin 90 degrees left or right respectively, without
moving from its current spot. 'M' means move forward one grid point and maintain the
same heading.
Assume that the square directly North from (x, y) is (x, y+1).


## Features

- Parse input for grid size and rover commands.
- Validate commands and initial positions.
- Simulate rover movements based on commands.
- Handle edge cases such as out-of-bounds movements.
- Display the final position of each rover after executing all commands.

## Technologies Used

- Dart and Flutter for the core logic and UI.
- RegExp for input validation.
- Queues for efficient command processing.

## Getting Started

### Prerequisites

- Dart SDK
- Flutter SDK

### Installation

1. Clone the repository:
   
   ```sh
   git clone https://github.com/your-username/mars_rover_coding_challenge.git
   cd mars_rover_coding_challenge
   ```
2. Install dependencies:
   
   ```sh
   flutter pub get
   ```

### Running the Application

On Mobile (Android and IOS)
1. Connect your mobile device or start an emulator.
2. Run the application:

   ```sh
   flutter run
   ```
On Web
1. Run the application:

   ```sh
   flutter run -d chrome
   ```
On MacOs
1. Run the application:

   ```sh
   flutter run -d macos
   ```

On Windows
1. Run the application:

   ```sh
   flutter run -d windows
   ```

### Usage

1. Enter the grid size and rover commands in the provided text fields.
2. Click the "Run Simulation" button to see the final positions of the rovers.

#### Example Input

```mathematica
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM
```

#### Example Output

```mathematica
1 3 N
5 1 E
```

## Images

![image](https://github.com/user-attachments/assets/66eb8d14-0ade-417b-90de-a5d9146788ed)
![image](https://github.com/user-attachments/assets/72674dca-5089-4413-9384-a0a307df7a4f)







## Code Documentation

### Rover Class

The `Rover` class represents a Mars rover with a specific position, direction, and a set of commands to execute.

- **Constructor:**
  - `Rover(this.initialPosition, this.initialDirection, this.commands)`
    - `initialPosition`: A tuple `(int, int)` representing the rover's initial coordinates on the grid.
    - `initialDirection`: An instance of `RoverDirection` indicating the rover's initial facing direction.
    - `commands`: A string of commands that the rover will execute.

- **Factory Constructor:**
  - `factory Rover.fromIterableParam(List<String> params)`
    - Takes a list of strings as input to initialize the `Rover` object. It parses the initial position, direction, and commands from the list. Validates the input and throws errors if the input does not meet the requirements.

- **Methods:**
  - `Future<String> getLastPosition(int maxRow, int maxCol)`
    - Executes the commands and returns the rover's final position and direction as a string. Checks for out-of-bounds errors during execution.

### RoverDirection Enum

The `RoverDirection` enum represents the possible directions the rover can face.

- **Fields:**
  - `north`: Represents the north direction.
  - `east`: Represents the east direction.
  - `west`: Represents the west direction.
  - `south`: Represents the south direction.

- **Methods:**
  - `String get label`: Returns the string representation of the direction (N, E, W, S).
  - `RoverDirection get toTheLeft`: Returns the direction to the left of the current direction.
  - `RoverDirection get toTheRight`: Returns the direction to the right of the current direction.
  - `static RoverDirection fromString(String s)`: Converts a string to a `RoverDirection` enum value. Throws an `ArgumentError` for invalid strings.

### ParseIterableRoverCommand Extension

An extension on `Iterable<RoverCommand>` to parse a string into a list of `RoverCommand` values.

- **Methods:**
  - `static Iterable<RoverCommand> fromString(String value)`
    - Parses a string of commands, validates them, and converts them into a list of `RoverCommand` values. Throws a `FormatException` for invalid commands.

### Error Handling

- **Exceptions:**
  - `FormatException`: Thrown by `ParseIterableRoverCommand.fromString` if the command string is invalid.
  - `ArgumentError`: Used for validation errors in input data.
  - `RoverException`: Custom exception thrown by `getLastPosition` for general errors encountered during position calculation.


### Contact

If you have any questions or need further assistance, please reach out to the project maintainers through the [Issues](link-to-issues) page or contact us directly.

Thank you for your interest in contributing to this project!


## Acknowledgments
* Thanks to NASA for the inspiration.
* Dart and Flutter teams for their excellent tools and documentation.











































