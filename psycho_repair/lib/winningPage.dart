import 'package:flutter/material.dart';
import 'package:psycho_repair/homePage.dart';

class WinningPage extends StatelessWidget {
  final String name;

  WinningPage({this.name});

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-0.2, 0),
                    child: Text(
                      'Você venceu!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffae8f),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment(0.2, 0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffae8f),
                        fontFamily: 'Psycho',
                      ),
                    ),
                  ),
                  Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FlatButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage(),
                        ));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 2)),
                  color: Colors.transparent,
                  child: Text('Nova rodada',
                      style: TextStyle(fontSize: 38)),
                ),
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
