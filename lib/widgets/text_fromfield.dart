import 'package:flutter/material.dart';

class customTextField extends StatelessWidget {
  const customTextField({
    super.key,
    //  @required this.autofocus,
    required this.hintText,
    required this.controller,
    required this.autofocus,
    required this.maxlines,
  });
  final String hintText;
  final TextEditingController controller;
  final bool autofocus;
  final int maxlines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
    
      maxLines:maxlines ,
      autofocus: autofocus,
      validator: (value) {
        if (value!.isEmpty) {
          return 'this field is required';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(

        enabled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(50)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
