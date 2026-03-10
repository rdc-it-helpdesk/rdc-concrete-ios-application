import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback for the button's onPressed event
  final String text; // Text to display on the button
  final Color backgroundColor; // Background color of the button
  final double
  width; // Width of the button (optional, can default to a wide button)
  final double height; // Height of the button (optional, can default to 50)
  final Color textColor; // Color of the text (optional, can default to white)
  final GlobalKey<FormState>? formKey; // Form key for validation

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    this.width = double.infinity, // Default to full width if not provided
    this.height = 50.0, // Default height of 50
    this.textColor = Colors.white, // Default text color is white
    this.formKey,
    required bool popOnPress, // Optional form key for validation
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey == null || formKey!.currentState!.validate()) {
          onPressed();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        backgroundColor: backgroundColor,
        minimumSize: Size(width, height),
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}
