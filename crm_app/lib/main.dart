import 'package:flutter/material.dart';

class Teste1 {
  final List<String> values = [Teste1.id];

  static const String id = '_id';
}

class Teste2 extends Teste1 {
  @override
  List<String> get values {
    var l = super.values;
    l.add('arrombado');

    return l;
  }

  Teste2() {
    for (var element in values) {
      print(element);
    }
  }
}

void main() {
  runApp(const MyApp());

  Teste2();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
    );
  }
}
