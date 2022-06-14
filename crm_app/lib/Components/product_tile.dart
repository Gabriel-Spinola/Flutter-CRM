import 'package:crm_app/Models/product_model.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../Database/database_provider.dart';
import '../Models/product_model.dart';
import '../Views/items_list.dart';

class SaleTile extends StatefulWidget {
  final ProductModel sale;
  final Future Function() refresh;

  const SaleTile({
    required this.sale,
    required this.refresh,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleTile> createState() => _SaleTileState();
}

class _SaleTileState extends State<SaleTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${widget.sale.productName}, ${widget.sale.id}"),
      subtitle: Text(
        "Preço: R\$${widget.sale.price}, Quantidade: ${widget.sale.amount}",
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
                Navigator.of(context).pushNamed(AppRoutes.productForm,
                    arguments: {
                      'sale': widget.sale,
                      'refresh': widget.refresh
                    });
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
                      widget.sale.id!,
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
