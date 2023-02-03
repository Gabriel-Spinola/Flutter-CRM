import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isEditing = false;

  void _loadFormData(ProductModel sale) {
    _formData['id'] = sale.id;
    _formData['product-name'] = sale.productName;
    _formData['costPrice'] = sale.costPrice;
    _formData['sellingPrice'] = sale.sellingPrice;
    _formData['amount'] = sale.amount;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if product already exists
    try {
      // try to receive arguments sent to this route
      var args = ModalRoute.of(context)?.settings.arguments as Map?;

      // if the route received arguments load the data
      // and this also means that the user is editing the product
      if (args != null && args['sale'].id != null) {
        _loadFormData(args['sale']);
        _isEditing = true;
      }
    } catch (e) {
      _formData['costPrice'] = '';
      _formData['sellingPrice'] = '';
      _formData['amount'] = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _productForm(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('User Form'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () async {
            final bool? isValid = _form.currentState?.validate();

            if (isValid ?? false) {
              // Saves the form state, and trigger the onSaved event from the text fields
              _form.currentState?.save();

              // if editing update the data
              if (_isEditing) {
                context.read<DatabaseProvider>().update(
                      ProductModel(
                        id: _formData['id'],
                        productName: _formData['product-name'],
                        costPrice: _formData['costPrice'],
                        sellingPrice: _formData['sellingPrice'],
                        amount: _formData['amount'],
                      ),
                      productTable,
                    );
                //

                // Refresh the page
                var args = ModalRoute.of(context)?.settings.arguments as Map;
                await args['refresh']();

                _isEditing = false;
              } else {
                // if adding a new product, insert the data to the database
                context.read<DatabaseProvider>().insert(
                      ProductModel(
                        productName: _formData['product-name'],
                        costPrice: _formData['costPrice'],
                        sellingPrice: _formData['sellingPrice'],
                        amount: _formData['amount'],
                      ),
                      productTable,
                    );
                //

                // refresh the page
                var refresh = ModalRoute.of(context)?.settings.arguments
                    as Future Function();
                await refresh();
              }

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _productForm() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            // * Product Name Field
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
            // * Cost Price Field
            TextFormField(
              initialValue: _formData['costPrice'].toString(),
              decoration: const InputDecoration(labelText: 'Preço de Custo'),
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
              onSaved: (value) => _formData['costPrice'] = double.parse(value!),
            ),
            // * Selling Price Field
            TextFormField(
              initialValue: _formData['sellingPrice'].toString(),
              decoration: const InputDecoration(labelText: 'Preço de Venda'),
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
              onSaved: (value) =>
                  _formData['sellingPrice'] = double.parse(value!),
            ),
            // * Amount Field
            TextFormField(
              initialValue: _formData['amount'].toString(),
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
    );
  }
}
