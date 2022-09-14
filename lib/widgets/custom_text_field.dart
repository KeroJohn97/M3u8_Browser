import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final bool obscureText;
  final TextStyle? labelStyle;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final bool readOnly;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextStyle? hintStyle;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatter;
  final TextStyle? textStyle;
  final FocusNode? focusNode;
  final int? maxLines;
  final void Function(String value)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final Function(bool isObscure)? onHasFocus;
  final Function(String text)? onChanged;
  final bool showBorder;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
    this.obscureText = false,
    this.labelStyle,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.floatingLabelBehavior,
    this.hintStyle,
    this.hintText,
    this.inputFormatter,
    this.textStyle,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.words,
    this.onHasFocus,
    this.onChanged,
    this.showBorder = true,
    this.maxLines,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        // color: Colors.black,
        width: 1.0,
      ),
    );

    final focusedBorder = border.copyWith(
      borderSide: const BorderSide(
        // color: Colors.black,
        width: 2.0,
      ),
    );

    return TextFormField(
      maxLines: widget.maxLines ?? 1,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      style: widget.textStyle,
      controller: widget.controller,
      obscureText: widget.obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.textInputType,
      autofocus: false,
      inputFormatters: widget.inputFormatter,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        errorMaxLines: 2,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        hintText: widget.hintText,
        isDense: true,
        labelText: widget.label,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: widget.showBorder
            ? border
            : const OutlineInputBorder(borderSide: BorderSide.none),
        errorBorder: widget.showBorder
            ? border
            : const OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: widget.showBorder
            ? border
            : const OutlineInputBorder(borderSide: BorderSide.none),
        disabledBorder: widget.showBorder
            ? border
            : const OutlineInputBorder(borderSide: BorderSide.none),
        errorStyle: const TextStyle(
          // color: Colors.redAccent,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
        focusedErrorBorder: widget.showBorder
            ? focusedBorder
            : const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: widget.showBorder
            ? focusedBorder
            : const OutlineInputBorder(borderSide: BorderSide.none),
        labelStyle: widget.labelStyle ??
            const TextStyle(
                // color: Colors.redAccent
                ),
        hintStyle: widget.hintStyle,
      ),
      validator: widget.validator,
    );
  }
}
