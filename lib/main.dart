import 'package:emitterk/screens/home.dart';

/* Screens */
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final Map<String, WidgetBuilder> _routes = {
    "home": (context) => HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notification's Emitter",
      theme: ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.pink),
      initialRoute: "home",
      routes: _routes,
    );
  }
}
