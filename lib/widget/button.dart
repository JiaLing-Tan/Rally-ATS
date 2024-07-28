import 'package:flutter/material.dart';

class CustomizedButton extends StatefulWidget {
  final Function() onTap;
  final Color color;
  final String text;
  final IconData icon;
  final bool isLoading;

  const CustomizedButton(
      {super.key,
      required this.onTap,
      required this.color,
      required this.text,
      required this.icon,
      required this.isLoading});

  @override
  State<CustomizedButton> createState() => _CustomizedButtonState();
}

class _CustomizedButtonState extends State<CustomizedButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
