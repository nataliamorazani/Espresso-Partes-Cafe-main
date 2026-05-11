import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInput extends StatelessWidget {
  final Map<String, dynamic>? formData;
  final FocusNode? focusNode;
  final String label;
  final String? objectKey;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final bool requiredField;
  final bool isMoney;
  final bool done;
  final bool readOnly;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const CustomInput({
    Key? key,
    this.formData,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.objectKey,
    required this.label,
    this.validator,
    this.requiredField = false,
    this.isMoney = false,
    this.done = false,
    this.readOnly = false,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> inputFormatters = [
      FilteringTextInputFormatter.digitsOnly,
      // Fit the validating format.
      //fazer o formater para dinheiro
      CurrencyInputFormatter(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        inputFormatters: isMoney ? inputFormatters : null,
        readOnly: readOnly,
        textCapitalization: TextCapitalization.sentences,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        initialValue:
            formData != null ? formData![objectKey]?.toString() : null,
        decoration: InputDecoration(
          labelText: requiredField ? "$label *" : label,
          // isDense: true,
          contentPadding: const EdgeInsets.only(top: 5),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
          ),
          enabledBorder: UnderlineInputBorder(
            //<-- SEE HERE
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.tertiary.withOpacity(.2),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            //<-- SEE HERE
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: keyboardType == TextInputType.multiline ? 2 : 1,
        onSaved: (value) => formData != null && objectKey != null
            ? formData![objectKey!] = value ?? ''
            : null,
        textInputAction: keyboardType == TextInputType.multiline
            ? TextInputAction.newline
            : done
                ? TextInputAction.done
                : TextInputAction.next,
        validator: (value) {
          final stringValue = value ?? '';

          if (requiredField && stringValue.trim().isEmpty) {
            return 'Campo obrigatorio.';
          }

          if (validator != null) {
            return validator!(stringValue);
          }
          return null;
        },
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
