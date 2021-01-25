import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentRenderer;
bool detectFlutterCanvasKit;

void main() {
  SharedPreferences.getInstance().then((preference) {
    final renderer = preference.getString('renderer');

    currentRenderer = renderer;

    context.callMethod('changeWebRendererTo', [renderer]);

    detectFlutterCanvasKit = context['flutterCanvasKit'] != null;

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100.0),
              Text(
                'Current renderer using "window.flutterWebRenderer" is: $currentRenderer',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Current renderer using "window.flutterCanvasKit" is: ${detectFlutterCanvasKit ? 'SKIA' : 'HTML'}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40.0),
              ),
              SizedBox(height: 100.0),
              RaisedButton(
                onPressed: () async {
                  final SharedPreferences prefs = await _prefs;

                  prefs.setString('renderer', 'html');

                  context.callMethod('changeWebRendererTo', ['html']);
                },
                child: Text('HTML'),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                onPressed: () async {
                  final SharedPreferences prefs = await _prefs;

                  prefs.setString('renderer', 'canvaskit');

                  context.callMethod('changeWebRendererTo', ['canvaskit']);
                },
                child: Text('CANVAS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
