import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/Models/sale_model.dart';
import 'package:crm_app/Data/dummy.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

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

    await DatabaseProvider.instance.insert(dummy, saleTable);

    sales = await SaleModel.readAllSales();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    DatabaseProvider.instance.insert(
      const SaleModel(
        productName: 'car',
        price: 10.0,
        amount: 1,
      ),
      saleTable,
    );

    return Text((sales.first as SaleModel).productName);
  }

  @override
  void dispose() {
    DatabaseProvider.instance.close();

    super.dispose();
  }
}
