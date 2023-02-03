import 'package:crm_app/Components/product_tile.dart';
import 'package:crm_app/Components/sale_tile.dart';
import 'package:crm_app/Components/searchbar.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  List<SaleModel> _sales = [];
  int quantity = 1;

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
                  ),
                  shrinkWrap: true,
                ),
                Gap(20.0),
                productViewer(),
              ],
            ),
          )
        ],
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
            Visibility(
              visible: _isVisible,
              child: FutureBuilder(
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
                              quantitySold: 1,
                              timeCreated: DateTime.now(),
                            );

                            for (SaleModel sale in _sales) {
                              if (sale.productName == newSale.productName) {
                                quantity++;
                                SaleModel finalSale = SaleModel(
                                  id: sale.id,
                                  productName: newSale.productName,
                                  totalPrice: newSale.totalPrice * quantity,
                                  profit: newSale.profit * quantity,
                                  quantitySold: quantity,
                                  timeCreated: newSale.timeCreated,
                                );

                                context.read<DatabaseProvider>().update(
                                      SaleModel(
                                        id: finalSale.id,
                                        productName: finalSale.productName,
                                        totalPrice: finalSale.totalPrice,
                                        profit: finalSale.profit,
                                        quantitySold: finalSale.quantitySold,
                                        timeCreated: finalSale.timeCreated,
                                      ),
                                      unitSaleTable,
                                    );

                                _refresh();
                                print(
                                    'update: ${finalSale.id}, ${finalSale.quantitySold}');
                                isAdding = true;
                              }
                            }

                            if (!isAdding) {
                              context
                                  .read<DatabaseProvider>()
                                  .insert(newSale, unitSaleTable);
                              _refresh();
                            }
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
            ),
          ],
        ),
      ),
    );
  }
}
