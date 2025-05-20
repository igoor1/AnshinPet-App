import 'package:flutter/material.dart';

class DialogUtils {
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    String title = "Confirmação",
    String content = "Deseja excluir?",
    String cancelText = "Cancelar",
    String confirmText = "Confirmar",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xffD32C2F),
              foregroundColor: Colors.white
            ),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
}