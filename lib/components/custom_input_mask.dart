import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';

enum MaskTypes {
  cpf,
  cnpj,
  phone,
  cep,
  interage,
  rg,
  ie,
  im,
}

class CustomInputMask extends StatelessWidget {
  final Map<String, dynamic>? formData;
  final FocusNode? focusNode;
  final String label;
  final String? objectKey;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final bool requiredField;
  final bool done;
  final MaskTypes maskType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const CustomInputMask({
    Key? key,
    this.formData,
    this.focusNode,
    this.keyboardType = TextInputType.number,
    this.objectKey,
    required this.label,
    this.validator,
    this.requiredField = false,
    this.done = false,
    required this.maskType,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<MaskTypes, String> masks = {
      MaskTypes.cpf: '###.###.###-##',
      MaskTypes.cnpj: '##.###.###/####-##',
      MaskTypes.cep: '#####-###',
      MaskTypes.phone: '(##) #####-####',
      MaskTypes.interage: '############',
      MaskTypes.rg: '##.###.###-#',
      MaskTypes.ie: '###.###.###.###',
      MaskTypes.im: '###.###-#',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: MaskedTextField(
        onChanged: onChanged,
        controller: controller,
        mask: masks[maskType],
        // maxLength: 14,
        keyboardType: TextInputType.number,
        initialValue:
            formData != null ? formData![objectKey]?.toString() : null,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
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
        maxLines: keyboardType == TextInputType.multiline ? 3 : 1,
        onSaved: (value) => formData != null && objectKey != null
            ? formData![objectKey!] = value ?? ''
            : null,
        textInputAction: done ? TextInputAction.done : TextInputAction.next,
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
