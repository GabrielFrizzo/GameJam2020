import 'package:flutter/material.dart';
import 'package:psycho_repair/gameState.dart';
import 'package:psycho_repair/transitionPage.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> names = [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff4f3a5e),
              Color(0xffff677d),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-0.2, 0),
                    child: Text(
                      'Psycho',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffae8f),
                        fontFamily: 'Psycho',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.2, 0),
                    child: Text(
                      'Journey',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffae8f),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Jogador 1',
                        icon: Icon(Icons.person),
                      ),
                      onSaved: (name) => names.add(name),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Favor insira um nome!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Jogador 2',
                        icon: Icon(Icons.person),
                      ),
                      onSaved: (name) => names.add(name),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Favor insira um nome!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Jogador 3',
                        icon: Icon(Icons.person),
                      ),
                      onSaved: (name) => names.add(name),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Favor insira um nome!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Jogador 4',
                        icon: Icon(Icons.person),
                      ),
                      onSaved: (name) => names.add(name),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Favor insira um nome!';
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      height: 100,
                      width: 200,
                      child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            GameState initialState = GameState(names);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TransitionPage(gameState: initialState),
                                ));
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.transparent,
                        child: Text('Iniciar'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
