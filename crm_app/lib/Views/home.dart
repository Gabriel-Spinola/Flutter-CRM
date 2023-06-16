import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../Utils/app_layout.dart';
import '../Utils/app_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: AppLayout.getWidth(5.0)),
          child: Row(
            children: <Widget>[
              const Icon(Icons.home),
              Gap(AppLayout.getWidth(5.0)),
              const Text('Página Inicial'),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppLayout.getHeight(10.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text("Iniciar Venda"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Styles.primaryColor),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(200.0, 50.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.salePage);
                },
              ),
              Gap(AppLayout.getHeight(10.0)),
              ElevatedButton(
                child: const Text("Estoque"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Styles.primaryColor),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(200.0, 50.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.productsList);
                },
              ),
              Gap(AppLayout.getHeight(10.0)),
              ElevatedButton(
                child: const Text("Estoque"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Styles.primaryColor),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(200.0, 50.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.saleRecordPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
