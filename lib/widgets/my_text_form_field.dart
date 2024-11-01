import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

import 'package:flutter/services.dart';

class MyTextFormField extends StatefulWidget {
  final String hintText;
  final IconData prefixIconData;
  final Widget? suffixIcon;
  final Color iconColor;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextFormField({
    Key? key,
    required this.hintText,
    required this.prefixIconData,
    this.suffixIcon,
    required this.controller,
    required this.iconColor,
    this.obscureText = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Required ${widget.hintText}';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.roboto(color: grey, fontSize : 17),
        contentPadding: const EdgeInsets.all(15),
        filled: true,
        fillColor: white,
        prefixIcon: Icon(
          widget.prefixIconData,
          color: widget.iconColor,
        ),
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                child: widget.suffixIcon,
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
