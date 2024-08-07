import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final Color color;
  final String title;
  final double fontSize;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  const CustomMaterialButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color = Colors.blue,
    this.margin,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      color: color,
      onPressed: onPressed,
      child: Text(
        title.toUpperCase(),
        maxLines: 1,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
