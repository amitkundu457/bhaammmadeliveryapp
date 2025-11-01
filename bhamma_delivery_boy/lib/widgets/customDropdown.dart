import 'package:flutter/material.dart';

import '../utils/default_colors.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.alignment,
    this.width,
    this.focusNode,
    this.icon,
    this.autofocus = false,
    this.textStyle,
    this.items,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.borderColor,
    this.value,
  });

  final Alignment? alignment;
  final double? width;
  final FocusNode? focusNode;
  final Widget? icon;
  final bool autofocus;
  final TextStyle? textStyle;
  final List<String>? items;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onChanged;
  final Color? borderColor;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final borderClr =
        borderColor ?? (isDarkMode ? DefaultColor.white : Colors.grey);

    return alignment != null
        ? Align(
            alignment: alignment!,
            child: dropdownWidget(borderClr, colorScheme, context),
          )
        : dropdownWidget(borderClr, colorScheme, context);
  }

  Widget dropdownWidget(Color borderClr, ColorScheme colorScheme, context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: DropdownButtonFormField<String>(
        value: value,
        focusNode: focusNode,
        icon: icon ??
            Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
        style: textStyle ?? TextStyle(color: colorScheme.onSurface),
        decoration: getDecoration(borderClr, colorScheme, context),
        items: items?.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style:
                  hintStyle ?? TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  InputDecoration getDecoration(
      Color borderClr, ColorScheme colorScheme, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      hintText: hintText ?? "",
      hintStyle: hintStyle ??
          TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      isDense: true,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
      fillColor: fillColor ?? colorScheme.surface,
      filled: filled,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: borderClr,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: borderClr,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: borderClr,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: isDarkMode ? 0.31 : 1,
        ),
      ),
    );
  }
}
