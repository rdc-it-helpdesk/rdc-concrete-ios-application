import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  // final Color? foregroundColor;
  final Color confirmColor;
  final Color cancelColor;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    // this.foregroundColor,
    required this.confirmColor,
    required this.cancelColor,
  });

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    // final Color buttonColor = foregroundColor ?? Theme.of(context).primaryColor;
    // final Color buttonColor1 = foregroundColor ?? Colors.redAccent;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(foregroundColor: cancelColor),
              child: Text(
                cancelText,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              style: TextButton.styleFrom(foregroundColor: confirmColor),
              child: Text(
                confirmText,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)
            //   )),
            //   onPressed: onConfirm,
            //   child: Text(confirmText, style: TextStyle(color: Colors.white),),
            // ),
          ],
        ),
      ],
    );
  }
}
