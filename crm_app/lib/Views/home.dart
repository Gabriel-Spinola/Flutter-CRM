import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        child: TextButton(
          child: const Text("Lista de items"),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.itemsList);
          },
        ),
      ),
    );
  }
}
