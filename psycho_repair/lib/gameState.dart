import 'dart:math';

import 'package:flutter/material.dart';
import 'package:psycho_repair/player.dart';

enum GameTile {
  terrenoBaldio,
  terreiro,
  comicio,
  casa,
  fogo,
  arvore,
  igreja,
}

class GameState {
  List<Player> players;
  List<GameTile> board;
  int currentTurn;

  GameState(List<String> names) {
    initPlayers(names);

    initBoard();

    currentTurn = 0;
  }

  void initPlayers(List<String> names) {
    var classOrder = PlayerClass.values.toList();
    classOrder.shuffle();

    var colors = [Colors.purple, Colors.blue, Colors.brown, Colors.yellow];
    colors.shuffle();

    var positions = [
      Position(0, 0),
      Position(0, 5),
      Position(5, 0),
      Position(5, 5)
    ];
    positions.shuffle();

    players = [];
    for (int i = 0; i < 4; i++) {
      players.add(Player(names[i], classOrder[i], colors[i], positions[i]));
      players[i].tilesKnown[posToIndex(positions[i])] = true;
    }
  }

  void initBoard() {
    var randTiles =
        List.filled(9, GameTile.terrenoBaldio) + List.filled(27, GameTile.casa);
    randTiles.shuffle();

    board = randTiles;
  }

  void nextTurn() {
    currentTurn += 1;

    if (currentTurn == 4) {
      board[Random().nextInt(36)] = GameTile.fogo;
      currentTurn = 0;
    }
  }

  int posToIndex(Position pos) {
    return 6 * pos.y + pos.x;
  }
}
