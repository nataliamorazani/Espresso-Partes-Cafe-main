import 'package:espresso_partes_cafe/components/custom_elevated_button.dart';
import 'package:espresso_partes_cafe/components/custom_input.dart';
import 'package:espresso_partes_cafe/models/product.dart';
import 'package:espresso_partes_cafe/models/product_to_sell_edited.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';

class EditProductToSell extends StatefulWidget {
  final Product product;
  const EditProductToSell({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<EditProductToSell> createState() => _EditProductToSellState();
}

class _EditProductToSellState extends State<EditProductToSell> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, Object> _formData = {
    "name": "",
    "price": "",
    "amount": "",
  };

  @override
  void initState() {
    super.initState();
    _formData["name"] = widget.product.name;
    _formData["price"] = FormaterUtil.toReal(widget.product.price);
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Navigator.pop(
        context,
        ProductToSell(
          productId: widget.product.id,
          name: _formData["name"] as String,
          price: FormaterUtil.toDouble(_formData["price"].toString()),
          amount: int.tryParse(_formData["amount"].toString()) ?? 0,
          productType: widget.product.productType,
          createdAt: DateTime.now(),
        ));
  }

  String? _amountValidator(String value) {
    int? intVal = int.tryParse(value);
    if (intVal == null) {
      return "Quantidade deve ser um numero inteiro";
    }
    if (intVal < 1) {
      return "Quantidade deve ser maior que 0";
    }

    if (intVal > widget.product.stock) {
      return "Estoque insuficiente";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 15.0,
          right: 15.0,
          top: 15.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                objectKey: "name",
                label: "Nome do Item",
                formData: _formData,
                requiredField: true,
              ),
              CustomInput(
                objectKey: "price",
                label: "Valor",
                formData: _formData,
                isMoney: true,
                requiredField: true,
                keyboardType: TextInputType.number,
              ),
              CustomInput(
                objectKey: "amount",
                label: "Quantidade",
                formData: _formData,
                requiredField: true,
                keyboardType: TextInputType.number,
                validator: _amountValidator,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 20, bottom: 30),
                alignment: Alignment.bottomRight,
                child: CustomElevatedButton(
                  onPressed: _submitForm,
                  text: "Salvar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
