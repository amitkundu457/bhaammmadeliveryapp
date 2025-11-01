import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    this.controller,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.onChange,
    this.maxLength,
    this.isReadOnly = false,
    this.enableInteractiveSelection = true,
    this.filled = true,
    this.textCapitalization,
    this.validator,
    this.boxShadow,
    this.inputFormatters,
    this.onSubmitted,
    this.color,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool autofocus;
  final bool isReadOnly;
  final TextCapitalization? textCapitalization;
  final TextStyle? textStyle;
  final bool obscureText;
  final bool enableInteractiveSelection;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final BoxShadow? boxShadow;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final void Function(String)? onChange;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final Color? color;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initialize once
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Clean up when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.maxFinite,
      child: TextFormField(
        focusNode: _focusNode, // Use single instance per field
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        controller: widget.controller,
        autofocus: widget.autofocus,
        style: widget.textStyle ?? TextStyle(color: colorScheme.onSurface),
        obscureText: widget.obscureText,
        textInputAction: widget.textInputAction,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines ?? 1,
        decoration: getDecoration(colorScheme, isDarkMode),
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        readOnly: widget.isReadOnly,
        maxLength: widget.maxLength,
        onChanged: widget.onChange,
        onFieldSubmitted: widget.onSubmitted,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        enableInteractiveSelection: widget.enableInteractiveSelection,
      ),
    );
  }

  InputDecoration getDecoration(ColorScheme colorScheme, bool isDarkMode) {
    final borderColor = isDarkMode ? Colors.white : Colors.grey;

    return InputDecoration(
      hintText: widget.hintText ?? "",
      hintStyle: widget.hintStyle ??
          TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      prefixIcon: widget.prefix,
      labelStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      prefixIconConstraints: widget.prefixConstraints,
      suffixIcon: widget.suffix,
      suffixIconConstraints: widget.suffixConstraints,
      isDense: true,
      contentPadding: widget.contentPadding ?? const EdgeInsets.all(19),
      fillColor: widget.fillColor ?? colorScheme.surface,
      filled: widget.filled,
      labelText: widget.labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      errorStyle: TextStyle(color: colorScheme.error),
    );
  }
}
