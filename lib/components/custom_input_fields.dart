import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatefulWidget {
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
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
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
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        inputFormatters: widget.inputFormatter,
        decoration: InputDecoration(
          hintText: widget.hintText,
          
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.blueAccent)
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
