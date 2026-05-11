import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateChanged;
  final DatePickerEntryMode initialEntryMode;

  const AdaptativeDatePicker({
    this.selectedDate,
    this.onDateChanged,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    Key? key,
  }) : super(key: key);

  _showDatePicker(BuildContext context) {
    showDatePicker(
      initialEntryMode: initialEntryMode,
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateChanged!(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate ?? DateTime.now(),
              minimumDate: DateTime(1900),
              maximumDate: DateTime.now().add(const Duration(days: 365)),
              onDateTimeChanged: onDateChanged!,
            ),
          )
        : InkWell(
            onTap: () => _showDatePicker(context),
            // child: child,
          );
  }
}

// DateFormat('dd/MM/y').format(selectedDate!)
