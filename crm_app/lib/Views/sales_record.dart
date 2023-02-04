import 'package:crm_app/Components/sale_record_tile.dart';
import 'package:crm_app/Components/searchbar.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/model.dart';
import 'package:crm_app/Models/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/Models/product_model.dart';
import 'package:crm_app/Components/product_tile.dart';
import 'package:provider/provider.dart';

import '../Data/dummy.dart';
import '../Routes/app_routes.dart';

class SalesRecord extends StatefulWidget {
  const SalesRecord({Key? key}) : super(key: key);

  @override
  State<SalesRecord> createState() => _SalesRecordState();
}

class _SalesRecordState extends State<SalesRecord> {
//  late List<ProductModel> _products;

  String _keyword = "";
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
      title: const Text('Sales Record'),
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

    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                future: SaleModel.searchModel(
                  _keyword,
                  saleTable,
                  "${SaleModelFields.productName} LIKE ?",
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(
                      'SNAPSHOT ERROR :: SEARCH BAR \n ${snapshot.error.toString()} + ${snapshot.error.runtimeType}',
                    );
                  }

                  if (snapshot.hasData) {
                    var data = snapshot.data as List<SaleModel>;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => SaleRecordTile(
                        sale: data[index],
                        refresh: _refresh,
                      ),
                      shrinkWrap: true,
                    );
                  } else {
                    return const Center(child: Text("Nothing Found"));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
