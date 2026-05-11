import 'package:flutter/material.dart';

class Callback {
  static void snackBar(
    BuildContext context, {
    String title = "Ocorreu um erro inesperado",
    Function()? onPress,
    String? label,
    bool error = true,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.secondary,
        content: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        action: onPress == null
            ? null
            : SnackBarAction(
                label: label!,
                onPressed: onPress,
              ),
      ),
    );
  }

  static Future<bool> confirm({
    required BuildContext context,
    title = 'Confirmar',
    required content,
    confirmText = "Confirmar",
    cancelText = "Cancelar",
  }) async {
    final res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 23,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                cancelText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // Fechar o AlertDialog
              },
            ),
            TextButton(
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                // Lógica de confirmação aqui
                Navigator.of(context).pop(true); // Fechar o AlertDialog
              },
            ),
          ],
        );
      },
    );
    return res ?? false;
  }
}
