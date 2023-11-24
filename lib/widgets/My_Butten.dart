import 'package:flutter/material.dart';

class MyButten extends StatelessWidget {
  const MyButten(
      {required this.color, required this.tetel, required this.onPrees});
  final Color color;
  final String tetel;
  final VoidCallback onPrees;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 10,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: onPrees,
          minWidth: 200,
          height: 42,
          child: Text(
            tetel,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
