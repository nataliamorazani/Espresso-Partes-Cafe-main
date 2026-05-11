import 'package:flutter/material.dart';

class InputSelect extends StatefulWidget {
  final String label;
  final List<String> data;
  final Function(int) onChanged;
  final int selectedIndex;
  const InputSelect({
    Key? key,
    required this.label,
    required this.data,
    required this.onChanged,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedIndex.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
            fontSize: 15,
          ),
        ),
        DropdownButton<String>(
          value: selectedOption,
          onChanged: (String? newValue) {
            if (newValue != null) {
              widget.onChanged(
                int.parse(newValue),
              );
              setState(() {
                selectedOption = newValue;
              });
            }
          },
          items: widget.data.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: widget.data
                  .indexWhere((element) => value == element)
                  .toString(),
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
