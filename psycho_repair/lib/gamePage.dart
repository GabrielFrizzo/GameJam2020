import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psycho_repair/gameState.dart';
import 'package:psycho_repair/player.dart';
import 'package:psycho_repair/transitionPage.dart';
import 'package:psycho_repair/winningPage.dart';

class GamePage extends StatefulWidget {
  final gameState;

  GamePage({Key key, @required this.gameState}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(gameState: gameState);
}

class _GamePageState extends State<GamePage> {
  GameState gameState;
  Player currPlayer;
  int actionsTaken = 0;

  _GamePageState({@required this.gameState})
      : currPlayer = gameState.players[gameState.currentTurn];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(currPlayer.classTitle()),
          backgroundColor: currPlayer.color),
      backgroundColor: Color(0xFFE0E0E0),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: GridView.count(
              crossAxisCount: 6,
              children: List.generate(36, (i) {
                return buildGridTile(
                  i,
                  gameState.currentTurn,
                  gameState.players,
                );
              }),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    buildMoveButton(Icons.arrow_upward, 'up'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildMoveButton(Icons.arrow_back, 'left'),
                        SizedBox(width: 50),
                        buildMoveButton(Icons.arrow_forward, 'right'),
                      ],
                    ),
                    buildMoveButton(Icons.arrow_downward, 'down'),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: currPlayer.color,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Jogadas',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  '$actionsTaken/3',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: currPlayer.color,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Repair!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  '${score(currPlayer.classe)}/${currPlayer.neededScore()}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // children: ['Dominar', 'Construir', 'Espiar']
                    children: dominateTitle(currPlayer.classe)
                        .map((title) => buildActionButton(context, title))
                        .toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<String> dominateTitle(PlayerClass classe) {
    if (classe == PlayerClass.ambientalista) return ['Plantar', 'Apagar Fogo'];
    if (classe == PlayerClass.cultista) return ['Queimar'];
    if (classe == PlayerClass.ditador) return ['Recrutar', 'Apagar Fogo'];
    if (classe == PlayerClass.fanaticoReligioso)
      return ['Converter', 'Apagar Fogo'];
    return ['Dominar', 'Apagar Fogo'];
  }

  Widget buildGridTile(int index, int currTurn, List<Player> players) {
    final List<Player> otherPlayers =
        players.sublist(0, currTurn) + players.sublist(currTurn + 1);
    var _color = Colors.green;
    IconData _icon;

    otherPlayers.forEach((p) {
      if (xyToIndex(p.position.x, p.position.y) == index) {
        _color = p.color;
      }
    });

    if (currPlayer.tilesKnown[index]) {
      _icon = tileIcon(gameState.board[index]);
    }

    if (xyToIndex(currPlayer.position.x, currPlayer.position.y) == index) {
      _color = currPlayer.color;
      _icon = tileIcon(gameState.board[index]);
    }

    if (gameState.board[index] == GameTile.fogo) {
      if (_color == Colors.green) _color = Colors.red;
      _icon = tileIcon(GameTile.fogo);
    }
    return Container(
      margin: const EdgeInsets.all(2),
      color: _color,
      child: Center(
        child: Icon(_icon),
      ),
    );
  }

  Widget buildMoveButton(IconData icon, String direction) {
    return RaisedButton(
      onPressed: () {
        setState(() {
          int _x = currPlayer.position.x;
          int _y = currPlayer.position.y;
          switch (direction) {
            case 'left':
              if (_x <= 0) return;
              currPlayer.position.x -= 1;
              break;
            case 'right':
              if (_x >= 5) return;
              currPlayer.position.x += 1;
              break;
            case 'up':
              if (_y <= 0) return;
              currPlayer.position.y -= 1;
              break;
            case 'down':
              if (_y >= 5) return;
              currPlayer.position.y += 1;
              break;
            default:
          }
          final newTile =
              xyToIndex(currPlayer.position.x, currPlayer.position.y);
          currPlayer.tilesKnown[newTile] = true;
          handleAction(context);
        });
      },
      color: currPlayer.color,
      child: Icon(icon, size: 50, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget buildActionButton(BuildContext context, String title) {
    return Container(
      height: 65,
      width: 130,
      child: RaisedButton(
        onPressed: () {
          final pos = currPlayer.position;
          if (title == 'Apagar Fogo' &&
              gameState.board[xyToIndex(pos.x, pos.y)] == GameTile.fogo) {
            gameState.board[xyToIndex(pos.x, pos.y)] = GameTile.terrenoBaldio;
            handleAction(context);
          } else if (dominate(currPlayer.classe, currPlayer.position))
            handleAction(context);
        },
        child: Text(
          '$title',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: currPlayer.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void handleAction(BuildContext context) {
    setState(() => actionsTaken += 1);
    if (actionsTaken >= 3) {
      gameState.nextTurn();
      final winner = gameState.gameWinner();
      if (winner != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                WinningPage(name: currPlayer.name),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                TransitionPage(gameState: gameState),
          ),
        );
      }
    }
  }

  int xyToIndex(int x, int y) {
    return 6 * y + x;
  }

  IconData tileIcon(GameTile tile) {
    switch (tile) {
      case GameTile.arvore:
        return FontAwesomeIcons.tree;
      case GameTile.casa:
        return FontAwesomeIcons.home;
      case GameTile.crentes:
        return FontAwesomeIcons.pray;
      case GameTile.fogo:
        return FontAwesomeIcons.fire;
      case GameTile.igreja:
        return FontAwesomeIcons.cross;
      case GameTile.terrenoBaldio:
        return FontAwesomeIcons.seedling;
      case GameTile.suditos:
        return FontAwesomeIcons.chessPawn;
      default:
        return Icons.cloud_upload;
    }
  }

  bool dominate(PlayerClass classe, Position pos) {
    return gameState.transform(pos, classe);
  }

  int score(PlayerClass classe) {
    if (classe == PlayerClass.ambientalista) return gameState.numTrees();
    if (classe == PlayerClass.cultista) return gameState.numFires();
    if (classe == PlayerClass.ditador) return gameState.numSubjects();
    if (classe == PlayerClass.fanaticoReligioso) return gameState.numChurches();
    return 0;
  }

  // Color tileColor(index) {
  //   if (index < 18) {
  //     if (index % 6 < 3) {
  //       return Colors.green;
  //     }
  //     return Colors.red;
  //   }
  //   if (index % 6 < 3) {
  //     return Colors.blue;
  //   }
  //   return Colors.brown;
  // }
}
