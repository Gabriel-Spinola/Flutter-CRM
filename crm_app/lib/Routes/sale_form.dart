import 'package:flutter/material.dart';

class SaleForm extends StatefulWidget {
  const SaleForm({Key? key}) : super(key: key);

  @override
  State<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
    );
  }
}
