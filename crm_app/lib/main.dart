import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:crm_app/Routes/sale_form.dart';
import 'package:flutter/material.dart';
import 'Views/items_list.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Notes SQLite';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider.instance)
      ],
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.home: (_) => const ItemsList(),
          AppRoutes.itemsList: (_) => const ItemsList(),
          AppRoutes.saleForm: (_) => const SaleForm(),
        },
      ),
    );
  }
}
