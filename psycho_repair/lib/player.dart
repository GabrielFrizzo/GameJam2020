import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum PlayerClass {
  ditador,
  fanaticoReligioso,
  cultista,
  ambientalista,
}

class Position {
  int x;
  int y;

  Position(this.x, this.y);
}

class Player {
  String name;
  PlayerClass classe;
  Color color;
  Position position;
  List<bool> tilesKnown = List.filled(36, false);
  int repaired = 0;

  Player(this.name, this.classe, this.color, this.position);

  IconData icon() {
    switch (classe) {
      case PlayerClass.ambientalista: return FontAwesomeIcons.tree;
      case PlayerClass.cultista: return FontAwesomeIcons.bookDead;
      case PlayerClass.ditador: return FontAwesomeIcons.chessKing;
      case PlayerClass.fanaticoReligioso: return FontAwesomeIcons.cross;
      default: return Icons.cloud_upload;
    }
  }
}
