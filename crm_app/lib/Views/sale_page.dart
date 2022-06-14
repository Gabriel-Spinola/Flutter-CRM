import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm_app/Models/product_model.dart';

class SalePage extends StatefulWidget {
  const SalePage({Key? key}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  Widget build(BuildContext context) {
    late List<Map> list;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
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
                              list = await context
                                  .read<DatabaseProvider>()
                                  .rawQuery(
                                    "SELECT * FROM $productTable WHERE ${ProductFields.productName} LIKE '%$text%'",
                                  );
                              //

                              setState(() {
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

                              /*showDialog(
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
