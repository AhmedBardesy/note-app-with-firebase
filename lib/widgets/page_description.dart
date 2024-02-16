

import 'package:flutter/material.dart';

class Page_discription extends StatelessWidget {
  const Page_discription({
    super.key, required this.x,
  });
  final String x;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          x,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ],
    );
  }
}
