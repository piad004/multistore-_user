import 'package:flutter/material.dart';
import 'package:user/Themes/colors.dart';

class EntryField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String image;
  final String initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLength;
  final int maxLines;
  int minLines = 1;
  final String hint;
  final InputBorder border;
  final Widget suffixIcon;
  final Function onTap;
  final TextCapitalization textCapitalization;
  final Color imageColor;
  final FormFieldValidator<String> validator;
  final String errorText;
  bool enable = true;
  EdgeInsetsGeometry contentPadding =
      EdgeInsets.only(left: 20, top: 0, bottom: 0);

  EntryField(
      {this.controller,
      this.label,
      this.image,
      this.initialValue,
      this.readOnly,
      this.keyboardType,
      this.maxLength,
      this.hint,
      this.border,
      this.maxLines,
      this.suffixIcon,
      this.onTap,
      this.textCapitalization,
      this.imageColor,
      this.validator,
      this.errorText,
      this.enable,
      this.minLines,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
      child: TextFormField(
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        cursorColor: kMainColor,
        onTap: onTap,
        autofocus: false,
        controller: controller,
        initialValue: initialValue,
        validator: validator,
        enabled: enable,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: label,
          hintText: hint,
          contentPadding: contentPadding,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600, color: kHintColor, fontSize: 16),
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          errorText: errorText,
          counter: Offstage(),
          icon: (image != null)
              ? ImageIcon(
                  AssetImage(image),
                  color: imageColor ?? kMainColor,
                  size: 20.0,
                )
              : null,
        ),
      ),
    );
  }
}
