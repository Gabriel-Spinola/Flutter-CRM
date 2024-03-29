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
      body: ListView(children: <Widget>[
        TextButton(
          child: const Text("Ver Produtos"),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.productsList);
          },
        ),
        TextButton(
          child: const Text("Venda Foda"),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.salePage);
          },
        ),
        TextButton(
          child: const Text("Todas venda foda"),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.saleRecordPage);
          },
        ),
      ]),
    );
  }
}
