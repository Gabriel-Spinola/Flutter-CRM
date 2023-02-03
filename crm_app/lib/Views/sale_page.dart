import 'package:crm_app/Components/product_tile.dart';
import 'package:crm_app/Components/sale_tile.dart';
import 'package:crm_app/Components/searchbar.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:crm_app/Models/product_model.dart';

import '../Models/model.dart';
import '../Models/sale_model.dart';

/// Sale Page Inspired by Vhsys
/// TODO: Fix the columns, and create the sale formulary work
class SalePage extends StatefulWidget {
  const SalePage({Key? key}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  TextEditingController _editingController = TextEditingController();

  List<SaleModel> _sales = [];
  int quantity = 1;
  String oldUpdate = "";
  String newUpdate = "";

  String _keyword = "";
  bool _isLoading = false;
  bool _isVisible = false;
  bool isAdding = false;

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  Future _refresh() async {
    setState(() => _isLoading = true);

    _sales = await SaleModel.readAllUnitSales() as List<SaleModel>;
    isAdding = false;

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Page'),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _form,
            child: Column(
              children: <Widget>[
                ListView.builder(
                  itemCount: _sales.length,
                  itemBuilder: (context, index) => SaleTile(
                    sale: _sales[index],
                    refresh: _refresh,
                    sizedBoxWidth: 120,
                    sizedBoxHeight: 120,
                    listChildrenWidget: _quantity(index),
                  ),
                  shrinkWrap: true,
                ),
                const Gap(20.0),
                productViewer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _quantity(int index) {
    return IconButton(
      icon: const Icon(Icons.format_list_numbered),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quantidade"),
          content: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Insira a quantidade",
            ),
            controller: _editingController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                int quantity = int.parse(_editingController.text);

                context.read<DatabaseProvider>().update(
                      SaleModel(
                        id: _sales[index].id,
                        productName: _sales[index].productName,
                        totalPrice: _sales[index].totalPrice * quantity,
                        profit: _sales[index].profit * quantity,
                        quantitySold: quantity,
                        timeCreated: _sales[index].timeCreated,
                      ),
                      unitSaleTable,
                    );
                _refresh();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget productViewer() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'keyword',
                ),
                onChanged: (value) {
                  _keyword = value;
                  _isVisible = true;
                  setState(() {});
                },
              ),
            ),
            FutureBuilder(
              future: ProductModel.searchModel(
                _keyword,
                productTable,
                "${ProductFields.productName} LIKE ?",
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(
                    'SNAPSHOT ERROR :: SEARCH BAR \n ${snapshot.error.toString()} + ${snapshot.error.runtimeType}',
                  );
                }

                if (snapshot.hasData) {
                  var data = snapshot.data as List<ProductModel>;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => ProductTile(
                      product: data[index],
                      refresh: _refresh,
                      listChildrenWidget: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          //var quantity = 1;

                          var newSale = SaleModel(
                            productName: data[index].productName,
                            totalPrice: data[index].sellingPrice,
                            profit: data[index].sellingPrice -
                                data[index].costPrice,
                            quantitySold: quantity,
                            timeCreated: DateTime.now(),
                          );

                          context
                              .read<DatabaseProvider>()
                              .insert(newSale, unitSaleTable);
                          _refresh();
                        },
                      ),
                      sizedBoxWidth: 120,
                      sizedBoxHeight: 120,
                    ),
                    shrinkWrap: true,
                  );
                } else {
                  return const Center(child: Text("Nothing Found"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editingController.dispose();

    super.dispose();
  }
}
