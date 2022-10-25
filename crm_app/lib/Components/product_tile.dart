import 'package:crm_app/Models/product_model.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../Database/database_provider.dart';
import '../Models/product_model.dart';
import '../Views/products_list_page.dart';

/// The container that display each products on the **Products List Page**
///
/// [product] is the `ProductModel` you're inserting into the list \
/// [refresh] is the function to refresh the state and reload all the data
class ProductTile extends StatefulWidget {
  final ProductModel product;
  final Future Function() refresh;

  const ProductTile({
    required this.product,
    required this.refresh,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${widget.product.productName}, ID: ${widget.product.id}"),
      subtitle: Text(
        "Preço de Compra: R\$${widget.product.costPrice}, Preço de Revenda: R\$${widget.product.sellingPrice} Quantidade: ${widget.product.amount}",
      ),
      trailing: SizedBox(
        width: 100,
        height: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.orange,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.addProductForm,
                  arguments: {
                    'sale': widget.product,
                    'refresh': widget.refresh
                  },
                );
              },
            ),
            // Delete
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Remove"),
                    content: const Text("Tem Certeza"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Sim"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      TextButton(
                        child: const Text("Não"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  ),
                ).then((isConfirmed) async {
                  if (isConfirmed) {
                    DatabaseProvider.instance.delete(
                      widget.product.id!,
                      productTable,
                    );

                    await widget.refresh();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
