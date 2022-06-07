import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/Models/sale_model.dart';
import 'package:crm_app/Components/sale_tile.dart';
import 'package:provider/provider.dart';

import '../Data/dummy.dart';
import '../Routes/app_routes.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late List<Model> _sales;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  Future _refresh() async {
    setState(() => _isLoading = true);

    _sales = await SaleModel.readAllSales();

    setState(() => _isLoading = false);
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('User Form'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.saleForm, arguments: _refresh);
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

    //         context.watch<DatabaseProvider>().anyVariable

    //database.insert(dummy, saleTable);

    return Scaffold(
      appBar: appBar(),
      body: ListView.builder(
        itemCount: _sales.length,
        itemBuilder: (context, index) => SaleTile(
          sale: _sales[index] as SaleModel,
          refresh: _refresh,
        ),
      ),
    );
  }
}
