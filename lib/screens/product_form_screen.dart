import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/custom_elevated_button.dart';
import 'package:espresso_partes_cafe/components/custom_radio.dart';
import 'package:espresso_partes_cafe/components/custom_input.dart';
import 'package:espresso_partes_cafe/models/product.dart';
import 'package:espresso_partes_cafe/services/db_product_service.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  ProductType _productType = ProductType.product;
  bool _isEdit = false;
  final _formKey = GlobalKey<FormState>();

  final Map<String, Object> _formData = {
    "name": "",
    "price": "R\$ 0,00",
    "stock": "",
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final product = widget.product;

    if (product != null) {
      _isEdit = true;
      _formData['id'] = product.id;
      _formData['name'] = product.name;
      _formData['price'] = FormaterUtil.toReal(product.price);
      _formData['stock'] = product.stock;
      _productType = product.productType;
    }
  }

  void _submitForm(context) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    try {
      await Provider.of<DbProductService>(context, listen: false).addOrUpdate(
        id: int.tryParse(_formData['id'].toString()),
        name: _formData["name"].toString(),
        price: FormaterUtil.toDouble(_formData["price"].toString()),
        stock: int.tryParse(_formData["stock"].toString()) ?? 0,
        productType: _productType.index,
        longitude: double.tryParse(_formData["longitude"].toString()),
        latitude: double.tryParse(_formData["latitude"].toString()),
      );
      Navigator.of(context).pop();
    } catch (error) {
      Callback.snackBar(
        context,
        title: error.toString(),
      );
    }
  }

  _handleRadioChange(ProductType val) {
    setState(() {
      _productType = val;
    });
  }

  _remove() async {
    await Provider.of<DbProductService>(context, listen: false)
        .deleteById(widget.product!.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? "Editar Item" : "Novo Item"),
        actions: [
          if (_isEdit)
            IconButton(
              onPressed: () async {
                bool res = await Callback.confirm(
                  context: context,
                  content: "Excluir Item?",
                );
                if (res) {
                  _remove();
                }
              },
              icon: const Icon(
                Icons.delete_forever,
                size: 33,
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            CustomInput(
              formData: _formData,
              label: "Nome do Item",
              objectKey: "name",
              requiredField: true,
              // focusNode: _descriptionFocus,
            ),
            CustomInput(
              formData: _formData,
              label: "Valor",
              objectKey: "price",
              isMoney: true,
              keyboardType: TextInputType.number,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: Text("Tipo de Item"),
            ),
            CustomRadio<ProductType>(
              label: "Produto",
              onChanged: _handleRadioChange,
              value: ProductType.product,
              groupValue: _productType,
            ),
            CustomRadio<ProductType>(
              label: "Serviço",
              onChanged: _handleRadioChange,
              value: ProductType.service,
              groupValue: _productType,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: Divider(),
            ),
            CustomInput(
              formData: _formData,
              label: "Quantidade em estoque",
              objectKey: "stock",
              keyboardType: TextInputType.number,
              done: true,
            ),
            Container(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              alignment: AlignmentDirectional.centerEnd,
              child: CustomElevatedButton(
                onPressed: () => _submitForm(context),
                text: 'Salvar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
