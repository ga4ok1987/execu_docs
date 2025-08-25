import 'package:flutter/material.dart';
import 'hover_button.dart';

Future<void> confirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          height: 200,
          width: 400,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HoverButton(
                      color: Colors.red,
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Відміна',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    HoverButton(
            
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        onConfirm();
                      },
                      child: const Text(
                        'Підтвердити',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
