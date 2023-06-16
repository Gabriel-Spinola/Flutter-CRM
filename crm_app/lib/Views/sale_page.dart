import 'package:crm_app/Components/product_tile.dart';
import 'package:crm_app/Components/sale_tile.dart';
import 'package:crm_app/Components/searchbar.dart';
import 'package:crm_app/Database/database_provider.dart';
import 'package:crm_app/Models/sale_model.dart';
import 'package:crm_app/Routes/app_routes.dart';
import 'package:crm_app/Utils/app_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:crm_app/Models/product_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../Models/unit_sale_model.dart';
import '../Utils/app_style.dart';

/// Sale Page Inspired by Vhsys
/// TODO: Fix the columns, and create the sale formulary work
class SalePage extends StatefulWidget {
  const SalePage({Key? key}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _newQuantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _changeController = TextEditingController();

  final Map<String, double> _pricing = {};
  final List<ProductModel> _products = [];
  Map<String, double> _discounts = {};

  List<UnitSaleModel> _unitSales = [];
  ProductModel? data;
  ProductModel? _dropDownSelectItem;

  double _total = 0.0;

  bool _isLoading = false;
  bool isAdding = false;

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  Future _refresh({bool isNone = false}) async {
    setState(() => _isLoading = true);

    _unitSales = await UnitSaleModel.readAllUnitSales() as List<UnitSaleModel>;
    isAdding = false;
    _discountController.text = "0";

    if (isNone) {
      _total = 0.0;
    }

    for (int i = 0; i < _unitSales.length; i++) {
      if (i > 0) {
        _total = _unitSales.fold(
          0,
          (previous, current) => previous + current.totalPrice,
        );
      } else {
        _total = _unitSales[i].totalPrice;
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Text("Loading..."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Page'),
        actions: <Widget>[
          Center(
            child: Text(
              'Valor total: R\$$_total',
              style: Styles.headLine2Style.copyWith(color: Colors.white),
            ),
          ),
          _confirmSale(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //productViewer(),
            _productDropDownViewer(),
            const Gap(25.0),
            Form(
              key: _form,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _unitSales.length,
                itemBuilder: (context, index) {
                  return SaleTile(
                    sale: _unitSales[index],
                    refresh: _refresh,
                    sizedBoxWidth: 120,
                    sizedBoxHeight: 120,
                    discount: _discounts.isNotEmpty
                        ? _discounts[_unitSales[index].productName]
                        : 0,
                    listChildrenWidget:
                        _updateQuantityAndDiscountButtons(index),
                  );
                },
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmSale() {
    return IconButton(
      icon: const Icon(Icons.save),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmar"),
          content: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Valor do cliente",
            ),
            controller: _changeController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                for (var sale in _unitSales) {
                  context.read<DatabaseProvider>().insert(sale, saleTable);

                  context
                      .read<DatabaseProvider>()
                      .delete(sale.id!, unitSaleTable);

                  for (var product in _products) {
                    context.read<DatabaseProvider>().update(
                          ProductModel(
                            id: product.id,
                            productName: product.productName,
                            costPrice: product.costPrice,
                            sellingPrice: product.sellingPrice,
                            amount: product.amount - sale.quantitySold,
                          ),
                          productTable,
                        );
                  }

                  _products.clear();
                }

                double change = int.parse(_changeController.text) - _total;

                _total = 0.0;
                _refresh();
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("O troco é $change"),
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _updateQuantityAndDiscountButtons(int index) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.discount, color: Colors.yellow),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Desconto"),
              content: TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Insira o valor do desconto",
                ),
                controller: _discountController,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Confirmar"),
                  onPressed: () {
                    double discount = double.parse(_discountController.text);

                    context.read<DatabaseProvider>().update(
                          UnitSaleModel(
                            id: _unitSales[index].id,
                            productName: _unitSales[index].productName,
                            totalPrice:
                                _pricing[_unitSales[index].productName]! -
                                    discount,
                            profit: _unitSales[index].profit - discount,
                            quantitySold: _unitSales[index].quantitySold,
                            timeCreated: _unitSales[index].timeCreated,
                          ),
                          unitSaleTable,
                        );

                    _discounts.addEntries(
                      <String, double>{
                        data!.productName: discount,
                      }.entries,
                    );

                    _refresh();

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.format_list_numbered),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Quantidade"),
              content: TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Insira a quantidade",
                ),
                controller: _newQuantityController,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    int quantity = int.parse(_newQuantityController.text);

                    context.read<DatabaseProvider>().update(
                          UnitSaleModel(
                            id: _unitSales[index].id,
                            productName: _unitSales[index].productName,
                            totalPrice:
                                _pricing[_unitSales[index].productName]! *
                                    quantity,
                            profit: _unitSales[index].profit * quantity,
                            quantitySold: quantity,
                            timeCreated: _unitSales[index].timeCreated,
                          ),
                          unitSaleTable,
                        );

                    _refresh();

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _productDropDownViewer() {
    return SizedBox(
      width: AppLayout.getWidth(500.0),
      child: DropdownSearch<ProductModel>(
        selectedItem: _dropDownSelectItem,
        popupProps: const PopupProps.menu(showSearchBox: true),
        asyncItems: (String filter) => ProductModel.searchModel(
          filter,
          productTable,
          "${ProductFields.productName} LIKE ?",
        ),
        itemAsString: (ProductModel productModel) => productModel.productName,
        onChanged: (model) {
          _dropDownSelectItem = model;
          data = model!;
        },
        dropdownButtonProps: DropdownButtonProps(
          tooltip: "Strings",
          icon: const Icon(
            Icons.add,
            size: 30.0,
            color: Colors.green,
          ),
          onPressed: _addSale,
        ),
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration:
              InputDecoration(labelText: "Selecione Um Produto"),
        ),
      ),
    );
  }

  void _addSale() {
    if (data == null) return;

    int quantity = 1;
    int? id;

    if (_unitSales.isNotEmpty) {
      for (var unitSale in _unitSales) {
        if (data!.productName == unitSale.productName) {
          quantity = unitSale.quantitySold + 1;
          id = unitSale.id;
        }
      }
    }

    _pricing.addEntries(
      <String, double>{
        data!.productName: data!.sellingPrice,
      }.entries,
    );

    var newUnitSale = UnitSaleModel(
      id: id,
      productName: data!.productName,
      totalPrice: data!.sellingPrice,
      profit: data!.sellingPrice - data!.costPrice,
      quantitySold: quantity,
      timeCreated: DateTime.now(),
    );

    if (quantity <= 1) {
      context.read<DatabaseProvider>().insert(newUnitSale, unitSaleTable);
    } else {
      context.read<DatabaseProvider>().update(
            UnitSaleModel(
              id: id,
              productName: newUnitSale.productName,
              totalPrice: _pricing[newUnitSale.productName]! * quantity,
              profit: newUnitSale.profit * quantity,
              quantitySold: quantity,
              timeCreated: newUnitSale.timeCreated,
            ),
            unitSaleTable,
          );
    }

    _products.add(data!);
    _refresh();
  }

  @override
  void dispose() {
    _newQuantityController.dispose();
    _discountController.dispose();
    _changeController.dispose();

    super.dispose();
  }
}
