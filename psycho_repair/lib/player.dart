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

  String classTitle() {
    switch (classe) {
      case PlayerClass.ambientalista: return 'Ambientalista - Plante Árvores!';
      case PlayerClass.cultista: return 'Cultista - Fogo em Tudo!';
      case PlayerClass.ditador: return 'Ditador - Conquiste seus súditos!';
      case PlayerClass.fanaticoReligioso: return 'Fanático Religioso - Converta-os todos!';
      default: return 'Repare a Sociedade!';
    }
  }

  int neededScore() {
    if (classe == PlayerClass.ambientalista) return 5;
    if (classe == PlayerClass.cultista) return 10;
    if (classe == PlayerClass.ditador) return 8;
    if (classe == PlayerClass.fanaticoReligioso) return 2;
    return 0;
  }
}
