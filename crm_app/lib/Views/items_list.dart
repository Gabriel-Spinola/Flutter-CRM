import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/Models/sale_model.dart';
import 'package:crm_app/Components/sale_tile.dart';

import '../Routes/app_routes.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);
  static bool shouldRefresh = false;

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late List<Model> sales;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  Future refresh() async {
    setState(() => isLoading = true);

    sales = await SaleModel.readAllSales();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Text("Loading", style: TextStyle(fontSize: 25));
    }

    //DatabaseProvider.instance.insert(dummy, saleTable);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.saleForm);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sales.length,
        itemBuilder: (context, index) => SaleTile(
          sale: sales[index] as SaleModel,
          refresh: refresh,
        ),
      ),
    );
  }

  @override
  void dispose() {
    DatabaseProvider.instance.close();

    super.dispose();
  }
}
