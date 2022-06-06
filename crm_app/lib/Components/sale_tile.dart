import 'package:crm_app/Models/sale_model.dart';
import 'package:flutter/material.dart';
import '../Database/database_provider.dart';
import '../Models/sale_model.dart';
import '../Views/items_list.dart';

class SaleTile extends StatefulWidget {
  final SaleModel sale;
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
      trailing: SizedBox(
        width: 100,
        height: 100,
        child: Row(
          children: <Widget>[
            // Delete
            IconButton(
              icon: const Icon(Icons.delete),
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
                    DatabaseProvider.instance
                        .delete(widget.sale.id!, saleTable);

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
