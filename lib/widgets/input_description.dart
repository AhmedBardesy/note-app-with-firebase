

import 'package:flutter/material.dart';

class Dis2 extends StatelessWidget {
  const Dis2({
    super.key,
    required this.x,
  });
  final String x;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          x,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
