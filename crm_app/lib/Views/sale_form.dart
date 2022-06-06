import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SaleForm extends StatefulWidget {
  const SaleForm({Key? key}) : super(key: key);

  @override
  State<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _loadFormData(SaleModel sale) {
    _formData['id'] = sale.id;
    _formData['product-name'] = sale.productName;
    _formData['price'] = sale.price;
    _formData['amount'] = sale.amount;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if user already exists
    try {
      var sale = ModalRoute.of(context)?.settings.arguments as SaleModel?;

      if (sale != null && sale.id != null) {
        _loadFormData(sale);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final bool? isValid = _form.currentState?.validate();

              if (isValid ?? false) {
                // Saves the form state, and trigger the onSaved event from the text fields
                _form.currentState?.save();

                context.read<DatabaseProvider>().insert(
                      SaleModel(
                        productName: _formData['product-name'],
                        price: _formData['price'],
                        amount: _formData['amount'],
                      ),
                      saleTable,
                    );
                //

                //print(_formData['product-name']);

                var refresh = ModalRoute.of(context)?.settings.arguments
                    as Future Function();
                await refresh();

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['product-name'],
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Um Erro ocorreu';
                  }

                  return null;
                },
                onSaved: (value) => _formData['product-name'] = value!,
              ),
              TextFormField(
                initialValue: _formData['price'],
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Um Erro ocorreu';
                  }

                  return null;
                },
                onSaved: (value) => _formData['price'] = double.parse(value!),
              ),
              TextFormField(
                initialValue: _formData['amount'],
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Um Erro ocorreu';
                  }

                  return null;
                },
                onSaved: (value) => _formData['amount'] = int.parse(value!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
