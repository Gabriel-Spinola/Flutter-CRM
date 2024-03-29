import 'package:crm_app/Components/searchbar.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/Models/product_model.dart';
import 'package:crm_app/Components/product_tile.dart';
import 'package:provider/provider.dart';

import '../Data/dummy.dart';
import '../Routes/app_routes.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
//  late List<ProductModel> _products;

  String keyword = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  Future _refresh() async {
    setState(() => _isLoading = true);

    //_products = await ProductModel.readAllSales() as List<ProductModel>;

    setState(() => _isLoading = false);
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Products List (Items List)'),
      actions: <Widget>[
        // Add product button
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.addProductForm, arguments: _refresh);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: appBar(),
        body: const Text(
          "Loading",
          style: TextStyle(fontSize: 25),
        ),
      );
    }

    //context.watch<DatabaseProvider>().anyVariable

    //database.insert(dummy, productTable);

    return Scaffold(
      appBar: appBar(),
      body: SearchBar(refresh: _refresh),
    );
  }
}
