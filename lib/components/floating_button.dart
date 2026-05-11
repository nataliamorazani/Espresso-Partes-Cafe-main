import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final void Function() onPress;
  final IconData icon;
  final Color? color;
  const FloatingButton({
    super.key,
    required this.onPress,
    this.icon = Icons.add,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.0,
      width: 65.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: color,
          onPressed: onPress,
          child: Icon(
            icon,
            size: 30,
          ),
        ),
      ),
    );
  }
}
