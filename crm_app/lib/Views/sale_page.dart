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
  Future refresh() async {}

  String keyword = "";

  @override
  Widget build(BuildContext context) {
    late List<Model> list;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                  if (snapshot.hasError) print('error');

                  Object? data = snapshot.data;

                  if (snapshot.hasData) {
                    /* showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(data.toString()),
                        );
                      },
                    );*/

                    if (data is List<Model>) {
                      return AlertDialog(title: Text(data.toString()));
                    }

                    return AlertDialog(title: Text(data.toString()));
                  } else {
                    return const Text("No data yet");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );

    /*Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 70.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Icon(Icons.search),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              //onSearchTextChanged,
                            ),
                            onChanged: (String text) async {
                              list = await ProductModel.searchModel(
                                text,
                                productTable,
                                "${ProductFields.productName} LIKE ?",
                              );

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(list.first.toMap().toString()),
                                  );
                                },
                              );

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (context, index) => SaleTile(
                                      sale: list[index] as ProductModel,
                                      refresh: refresh,
                                    ),
                                  );
                                },
                              );

                              /*setState(() {
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 70.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: ListView.builder(
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                list.first.toString(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(list.first.toString()),
                                  );
                                },
                              );*/
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
    */
  }
}

/*
Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Icon(Icons.search),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              //onSearchTextChanged,
                            ),
                            onChanged: (String text) async {
                              list = await context
                                  .read<DatabaseProvider>()
                                  .rawQuery(
                                    "SELECT * FROM $productTable WHERE ${ProductFields.productName} LIKE '%$text%'",
                                  );
                              //

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(list.first.toString()),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            */
