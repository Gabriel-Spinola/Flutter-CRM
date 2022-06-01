import 'package:crm_app/Models/sale_model.dart';
import 'package:flutter/material.dart';

class SaleTile extends StatelessWidget {
  final SaleModel sale;

  const SaleTile({required this.sale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sale.productName),
    );
  }
}
