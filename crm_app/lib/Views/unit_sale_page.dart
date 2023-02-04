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

  final TextEditingController _newQuantityController = TextEditingController();
  final TextEditingController _changeController = TextEditingController();
  final Map<String, double> _pricing = {};
  final List<ProductModel> _products = [];

  List<SaleModel> _sales = [];

  double _total = 0.0;

  String _keyword = "";
  bool _isLoading = false;
  bool isAdding = false;

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  Future _refresh({bool isNone = false}) async {
    setState(() => _isLoading = true);

    _sales = await SaleModel.readAllUnitSales() as List<SaleModel>;
    isAdding = false;

    if (isNone) {
      _total = 0.0;
    }

    for (int i = 0; i < _sales.length; i++) {
      if (i > 0) {
        _total = _sales.fold(
          0,
          (previous, current) => previous + current.totalPrice,
        );
      } else {
        _total = _sales[i].totalPrice;
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Text("Loading..."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirmar"),
                content: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Valor do cliente",
                  ),
                  controller: _changeController,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Sim"),
                    onPressed: () {
                      for (var sale in _sales) {
                        context
                            .read<DatabaseProvider>()
                            .delete(sale.id!, unitSaleTable);

                        for (var product in _products) {
                          context.read<DatabaseProvider>().update(
                                ProductModel(
                                  id: product.id,
                                  productName: product.productName,
                                  costPrice: product.costPrice,
                                  sellingPrice: product.sellingPrice,
                                  amount: product.amount - sale.quantitySold,
                                ),
                                productTable,
                              );
                        }

                        _products.clear();
                      }

                      double change =
                          int.parse(_changeController.text) - _total;

                      _total = 0.0;
                      _refresh();
                      Navigator.of(context).pop();

                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("O troco é $change"),
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Não"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _form,
            child: Column(
              children: <Widget>[
                ListView.builder(
                  itemCount: _sales.length,
                  itemBuilder: (context, index) {
                    return SaleTile(
                      sale: _sales[index],
                      refresh: _refresh,
                      sizedBoxWidth: 120,
                      sizedBoxHeight: 120,
                      listChildrenWidget: _updateQuantity(index),
                    );
                  },
                  shrinkWrap: true,
                ),
                Text('Valor total: R\$$_total'),
                const Gap(20.0),
                productViewer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _updateQuantity(int index) {
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
            controller: _newQuantityController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                int quantity = int.parse(_newQuantityController.text);

                context.read<DatabaseProvider>().update(
                      SaleModel(
                        id: _sales[index].id,
                        productName: _sales[index].productName,
                        totalPrice:
                            _pricing[_sales[index].productName]! * quantity,
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
                          _pricing.addEntries(
                            <String, double>{
                              data[index].productName: data[index].sellingPrice,
                            }.entries,
                          );

                          var newSale = SaleModel(
                            productName: data[index].productName,
                            totalPrice: data[index].sellingPrice,
                            profit: data[index].sellingPrice -
                                data[index].costPrice,
                            quantitySold: 1,
                            timeCreated: DateTime.now(),
                          );

                          context
                              .read<DatabaseProvider>()
                              .insert(newSale, unitSaleTable);

                          _products.add(data[index]);
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
    _newQuantityController.dispose();
    _changeController.dispose();

    super.dispose();
  }
}
