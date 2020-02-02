import 'dart:math';

import 'package:flutter/material.dart';
import 'package:psycho_repair/player.dart';

enum GameTile {
  terrenoBaldio,
  casa,
  fogo,
  suditos,
  crentes,
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

    var colors = [Colors.purple, Colors.blue, Colors.brown, Colors.amber];
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

  int numChurches() {
    int total = 0;
    board.forEach((tile) {
      if (tile == GameTile.igreja) total += 1;
    });
    return total;
  }

  int numTrees() {
    int total = 0;
    board.forEach((tile) {
      if (tile == GameTile.arvore) total += 1;
    });
    return total;
  }

  int numSubjects() {
    int total = 0;
    board.forEach((tile) {
      if (tile == GameTile.suditos) total += 1;
    });
    return total;
  }

  int numFires() {
    int total = 0;
    board.forEach((tile) {
      if (tile == GameTile.fogo) total += 1;
    });
    return total;
  }

  bool transform(Position pos, PlayerClass classe) {
    GameTile tile;
    GameTile prevTile = board[posToIndex(pos)];
    if (prevTile == GameTile.terrenoBaldio) {
      switch (classe) {
        case PlayerClass.ambientalista:
          tile = GameTile.arvore;
          break;
        case PlayerClass.fanaticoReligioso:
          if (mayBuildChurch(pos)) tile = GameTile.igreja;
          break;
        default:
          return false;
      }
    } else {
      switch (classe) {
        case PlayerClass.cultista:
          tile = GameTile.fogo;
          break;
        case PlayerClass.ditador:
          tile = GameTile.suditos;
          break;
        case PlayerClass.fanaticoReligioso:
          if (prevTile != GameTile.igreja) tile = GameTile.crentes;
          break;
        default:
          return false;
      }
    }
    if (tile != null) board[posToIndex(pos)] = tile;
    return prevTile != tile && tile != null;
  }

  bool mayBuildChurch(Position pos) {
    int count = 0;
    final positions = [
      [0, 0],
      [0, 1],
      [1, 0],
      [1, 1],
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [1, -1],
    ].map((i) => Position(i[0] + pos.x, i[1] + pos.y)).toList();

    positions.forEach((pos) {
      if (posToIndex(pos) >= 0 &&
          posToIndex(pos) < 36 &&
          board[posToIndex(pos)] == GameTile.crentes) count++;
    });

    return count >= 2;
  }

  Player gameWinner() {
    if (numTrees() >= 5) return getPlayerFromClass(PlayerClass.ambientalista);
    if (numFires() >= 10) return getPlayerFromClass(PlayerClass.cultista);
    if (numSubjects() >= 8) return getPlayerFromClass(PlayerClass.ditador);
    if (numChurches() >= 2)
      return getPlayerFromClass(PlayerClass.fanaticoReligioso);
    return null;
  }

  Player getPlayerFromClass(PlayerClass classe) {
    return players.firstWhere((p) => p.classe == classe);
  }
}
