

import 'package:flutter/material.dart';

class Discruption extends StatelessWidget {
  const Discruption({
    super.key, required this.x,
  });
  final String x;
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Text(
          x,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
