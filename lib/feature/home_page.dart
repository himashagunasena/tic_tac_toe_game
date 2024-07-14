import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_state.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Tic Tac Toe',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
        )),
        backgroundColor: const Color(0XFF2B0040),
      ),
      backgroundColor: const Color(0XFF2B0040),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          _buildBoard(game, gameNotifier),
          const Spacer(),
          const SizedBox(height: 20),
          if (game.state != GameState.playing)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _getResultMessage(game.state),
                  style: const TextStyle(fontSize: 24, color: Colors.amber),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => gameNotifier.resetGame(),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Radius of 12
                      ),
                      backgroundColor: Colors.amber,
                      minimumSize: const Size(160, 60),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20)),
                  child: Text(
                    game.state.name == "draw" ? "Try Again" : 'Restart',
                    style:
                        const TextStyle(fontSize: 18, color: Color(0XFF43115B)),
                  ),
                ),
                const SizedBox(
                  height: 32,
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBoard(Game game, GameNotifier gameNotifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => gameNotifier.handleTap(index),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0XFF43115B),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: game.board[index].isSelected
                          ? Colors.transparent
                          : Colors.black.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(1, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(child: _buildBoxContent(game.board[index])),
              ),
            );
          },
          itemCount: 9,
        ),
      ),
    );
  }

  Widget _buildBoxContent(Tile tile) {
    if (tile.value == 'X') {
      return Image.asset(
        'assets/images/x.png',
        height: 38,
        color: Colors.amber,
      );
    } else if (tile.value == 'O') {
      return Image.asset(
        'assets/images/0.png',
        height: 38,
        color: Colors.green,
      );
    }
    return const SizedBox.shrink();
  }

  String _getResultMessage(GameState state) {
    switch (state) {
      case GameState.xWins:
        return 'Player X Wins!';
      case GameState.oWins:
        return 'Player O Wins!';
      case GameState.draw:
        return 'It\'s a Draw!';
      default:
        return '';
    }
  }
}
