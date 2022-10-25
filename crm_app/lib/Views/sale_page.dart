import 'package:crm_app/Components/product_tile.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm_app/Models/product_model.dart';

import '../Models/model.dart';

class SalePage extends StatefulWidget {
  const SalePage({Key? key}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  String keyword = "";
  bool _isLoading = false;

  Future refresh() async {
    setState(() => _isLoading = true);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Page'),
      ),
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
                    keyword = value;
                    setState(() {});
                  },
                ),
              ),
              FutureBuilder(
                future: ProductModel.searchModel(
                  keyword,
                  productTable,
                  "${ProductFields.productName} LIKE ?",
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print('SNAPSHOT ERROR :: SALE PAGE');

                  if (snapshot.hasData) {
                    var data = snapshot.data as List<ProductModel>;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => ProductTile(
                        product: data[index],
                        refresh: refresh,
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
