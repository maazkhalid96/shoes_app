import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final int? maxline;
  final List<TextInputFormatter>? inputFormatter;
  const CustomInputField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    required this.controller,
    this.textInputType,
    this.maxline,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          hintText: hintText,
          
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.blueAccent)
              : null,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
