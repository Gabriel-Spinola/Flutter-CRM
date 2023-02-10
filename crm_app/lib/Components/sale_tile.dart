import 'package:crm_app/Models/model.dart';
import 'package:crm_app/Models/product_model.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:crm_app/Utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Database/database_provider.dart';
import '../Models/product_model.dart';
import '../Models/unit_sale_model.dart';
import '../Views/products_list_page.dart';

/// The container that display each products on the **Products List Page**
///
/// [sale] is the `ProductModel` you're inserting into the list \
/// [refresh] is the function to refresh the state and reload all the data
class SaleTile extends StatefulWidget {
  final UnitSaleModel sale;
  final Future Function({bool isNone}) refresh;
  final Widget? listChildrenWidget;
  final double sizedBoxWidth;
  final double sizedBoxHeight;
  final double? discount;

  const SaleTile({
    required this.sale,
    required this.refresh,
    this.listChildrenWidget,
    this.discount,
    this.sizedBoxWidth = 100,
    this.sizedBoxHeight = 100,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleTile> createState() => _SaleTileState();
}

class _SaleTileState extends State<SaleTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${widget.sale.productName}, ID: ${widget.sale.id}",
        style: Styles.headLine2Style.copyWith(fontSize: 20.0),
      ),
      subtitle: Text(
        "Total: R\$${widget.sale.totalPrice}, Quantidade: ${widget.sale.quantitySold} un, desconto: R\$${widget.discount ?? 0}, lucro: R\$${widget.sale.profit}",
        style: Styles.headLine3Style.copyWith(fontSize: 16.5),
      ),
      trailing: SizedBox(
        width: widget.sizedBoxWidth,
        height: widget.sizedBoxHeight,
        child: Row(
          children: <Widget>[
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
                          widget.refresh();

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
                      unitSaleTable,
                    );

                    await widget.refresh(isNone: true);
                  }
                });
              },
            ),
            widget.listChildrenWidget != null
                ? widget.listChildrenWidget!
                : Container(),
          ],
        ),
      ),
    );
  }
}
