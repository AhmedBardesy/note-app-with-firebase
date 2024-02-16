

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.widget,
    required this.function,
    required this.color,
  });
  final Widget widget;
  final void Function() function;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: function,
      color: color,
      textColor: Colors.white,
      child: widget,
    );
  }
}
