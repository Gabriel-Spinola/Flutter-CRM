import 'package:crm_app/Components/product_tile.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:crm_app/Models/product_model.dart';

//TODO - Add customization
/// Creates a search input field with its list
///
/// [refresh] is the function to refresh the state and reload all the data
class SearchBar extends StatefulWidget {
  final Future Function() refresh;

  const SearchBar({Key? key, required this.refresh}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _keyword = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              future: ProductModel.searchModel(
                _keyword,
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
                      refresh: widget.refresh,
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
    );
  }
}
