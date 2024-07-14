import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

enum Player { x, o }

enum GameState { playing, xWins, oWins, draw }

class Tile {
  final String value;
  bool isSelected;

  Tile({
    required this.value,
    this.isSelected = false,
  });
}

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
        // Initialize isSelected to false
        currentPlayer = Player.x,
        state = GameState.playing;
}

final gameProvider = StateNotifierProvider<GameNotifier, Game>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<Game> {
  GameNotifier() : super(Game.initial());

  void handleTap(int index) {
    if (state.board[index].value.isEmpty && state.state == GameState.playing) {
      final newBoard = List<Tile>.from(state.board);
      newBoard[index] = Tile(
          value: state.currentPlayer == Player.x ? 'X' : 'O',
          isSelected: true);
      final newGameState = _calculateGameState(newBoard);

      state = Game(
        board: newBoard,
        currentPlayer: newGameState == GameState.playing
            ? _nextPlayer()
            : state.currentPlayer,
        state: newGameState,
      );

      if (state.currentPlayer == Player.o &&
          newGameState == GameState.playing) {
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

      if (board[a].value.isNotEmpty &&
          board[a].value == board[b].value &&
          board[a].value == board[c].value) {
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
    newBoard[aiMove] = Tile(value: 'O', isSelected: true);
    final newGameState = _calculateGameState(newBoard);

    state = Game(
      board: newBoard,
      currentPlayer: newGameState == GameState.playing
          ? _nextPlayer()
          : state.currentPlayer,
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

    for (var line in lines) {
      int? move = _checkLine(board, line, 'O');
      if (move != null) return move;
    }

    for (var line in lines) {
      int? move = _checkLine(board, line, 'X');
      if (move != null) return move;
    }
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

    if (board[a].value == player &&
        board[b].value == player &&
        board[c].value.isEmpty) return c;
    if (board[a].value == player &&
        board[c].value == player &&
        board[b].value.isEmpty) return b;
    if (board[b].value == player &&
        board[c].value == player &&
        board[a].value.isEmpty) return a;

    return null;
  }
}
