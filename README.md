# Tic-Tac-Toe Game

This is a Tic-Tac-Toe game built with Flutter and Riverpod state management. The game allows two players to play against each other, and includes an AI player for Player 'O'.

## Features

- **Two Player Mode**: Play against another player.
- **AI Mode**: Play against an AI that makes optimal moves.
- **Game States**: The game can be in a playing state, win state (for both players), or draw state.
- **Board Management**: Each tile on the board has a value and a selected state.

## Getting Started

### Prerequisites

- Flutter SDK: 3.19.2 [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: 3.3.0

### Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/yourusername/tic-tac-toe-flutter.git
    cd tic-tac-toe-flutter
    ```

2. Install dependencies:

    ```sh
    flutter pub get
    ```

### Running the App

1. Run the app on an emulator or physical device:

    ```sh
    flutter run
    ```

## Code Structure

### Tile Class

Represents a single tile on the Tic-Tac-Toe board.

```dart
class Tile {
  final String value;
  bool isSelected;

  Tile({
    required this.value,
    this.isSelected = false,
  });
}
```

### Game Class

Represents the state of the game, including the board, current player, and game state.

```dart
class Game {
  final List<Tile> board;
  final Player currentPlayer;
  final GameState state;

  Game({
    required this.board,
    required this.currentPlayer,
    required this.state,
  });

  Game.initial()
      : board = List.generate(9, (_) => Tile(value: '', isSelected: false)),
        currentPlayer = Player.x,
        state = GameState.playing;
}
```

### GameNotifier Class

Handles the game logic and state updates.

```dart
class GameNotifier extends StateNotifier<Game> {
  GameNotifier() : super(Game.initial());

  void handleTap(int index) {
    if (state.board[index].value.isEmpty && state.state == GameState.playing) {
      final newBoard = List<Tile>.from(state.board);
      newBoard[index] = Tile(value: state.currentPlayer == Player.x ? 'X' : 'O', isSelected: true);
      final newGameState = _calculateGameState(newBoard);

      state = Game(
        board: newBoard,
        currentPlayer: newGameState == GameState.playing ? _nextPlayer() : state.currentPlayer,
        state: newGameState,
      );

      if (state.currentPlayer == Player.o && newGameState == GameState.playing) {
        _makeAiMove();
      }
    }
  }

  Player _nextPlayer() => state.currentPlayer == Player.x ? Player.o : Player.x;

  GameState _calculateGameState(List<Tile> board) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (board[a].value.isNotEmpty && board[a].value == board[b].value && board[a].value == board[c].value) {
        return board[a].value == 'X' ? GameState.xWins : GameState.oWins;
      }
    }

    if (board.every((tile) => tile.value.isNotEmpty)) {
      return GameState.draw;
    }

    return GameState.playing;
  }

  void resetGame() {
    state = Game.initial();
  }

  void _makeAiMove() {
    final newBoard = List<Tile>.from(state.board);
    final aiMove = _findBestMove(newBoard);
    newBoard[aiMove] = const Tile(value: 'O', isSelected: true);
    final newGameState = _calculateGameState(newBoard);

    state = Game(
      board: newBoard,
      currentPlayer: newGameState == GameState.playing ? _nextPlayer() : state.currentPlayer,
      state: newGameState,
    );
  }

  int _findBestMove(List<Tile> board) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    // First, check if AI can win
    for (var line in lines) {
      int? move = _checkLine(board, line, 'O');
      if (move != null) return move;
    }

    // Next, check if AI needs to block player
    for (var line in lines) {
      int? move = _checkLine(board, line, 'X');
      if (move != null) return move;
    }

    // If no winning or blocking move, make a random move
    Random random = Random();
    int index;
    do {
      index = random.nextInt(9);
    } while (board[index].value.isNotEmpty);
    return index;
  }

  int? _checkLine(List<Tile> board, List<int> line, String player) {
    final a = line[0];
    final b = line[1];
    final c = line[2];

    if (board[a].value == player && board[b].value == player && board[c].value.isEmpty) return c;
    if (board[a].value == player && board[c].value == player && board[b].value.isEmpty) return b;
    if (board[b].value == player && board[c].value == player && board[a].value.isEmpty) return a;

    return null;
  }
}
```

### Provider

Provides the game state and handles state updates.

```dart
final gameProvider = StateNotifierProvider<GameNotifier, Game>((ref) {
  return GameNotifier();
});
```

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

---

You can further customize the README with more detailed instructions or additional sections as needed for your project.
