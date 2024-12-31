import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final Color backgroundColor;
  final bool fillColor;
  final IconButton? suffixIcon;
  final int? maxLength;

  const AppInput({
    Key? key,
    this.fillColor = false,
    this.hintText,
    this.maxLength = 25,
    this.suffixIcon,
    this.backgroundColor = Colors.transparent,
    this.placeholder = "Enter your text",
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLength: maxLength,
      onChanged: onChanged,
      canRequestFocus: true,
      decoration: InputDecoration(
          hintText: hintText,
          filled: fillColor,
          label: hintText != null ? Text(hintText!) : null,
          fillColor: backgroundColor,
          border: fillColor == false
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.lg),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(Sizes.lg),
                ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? suffixIcon : null),
    );
  }
}
