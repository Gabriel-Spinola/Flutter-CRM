import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:crm_app/Views/home.dart';
import 'package:crm_app/Views/add_product_form.dart';
import 'package:crm_app/Views/sale_page.dart';
import 'package:crm_app/Views/sales_record.dart';
import 'package:flutter/material.dart';
import 'Views/products_list_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Notes SQLite';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Multi Provider and Routing
    // The database provider provides the necessary tools for the database usage
    // to call the provider methods and properties use: `context.read<Provider>()`.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider.instance)
      ],
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.productsList: (_) => const ProductsList(),
          AppRoutes.addProductForm: (_) => const AddProductForm(),
          AppRoutes.salePage: (_) => const SalePage(),
          AppRoutes.saleRecordPage: (_) => const SalesRecord(),
        },
      ),
    );
  }
}
