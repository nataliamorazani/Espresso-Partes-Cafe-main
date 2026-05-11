import 'package:flutter/material.dart';

class CustomRadio<T> extends StatelessWidget {
  final Function(T) onChanged;
  final dynamic value;
  final dynamic groupValue;
  final String label;
  const CustomRadio({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.groupValue,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: Transform.scale(
        scale: 1.3, // Defina o fator de escala desejado
        child: Radio<T>(
          splashRadius: 10,
          value: value,
          groupValue: groupValue,
          onChanged: (T? value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
