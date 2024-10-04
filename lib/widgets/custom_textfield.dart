import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_app/base/utils/size_constants.dart';

import '../base/utils/color_utils.dart';
import '../base/utils/font_style.dart';


class CustomTextField extends StatelessWidget {

  final String hint;


  final bool enabled;


  final bool isObscureText;


  final bool readOnly;


  final bool enableInteractiveSelection;


  final FocusNode focusNode;


  final TextInputType? textInputType;


  final BoxFit? prefixFit;


  final Icon? prefixIcon;


  final Color? prefixIconColor;


  final String? suffixIcon;


  final int? maxLength;


  final int maxLines;


  final TextInputAction? textInputAction;


  final List<TextInputFormatter>? textInputFormatter;


  final TextEditingController? controller;


  final Function? onPrefixIconClick;


  final Function? onSuffixIconClick;


  final Function? onFieldSubmitted;


  final Function(String)? onChanged;


  final Function()? onTap;


  final TextCapitalization capitalization;


  final TextDirection textDirection;


  final TextAlign textAlign;


  final TextStyle? valueTextStyle;


  final TextStyle? valueHintTextStyle;


  final Function(bool)? onTapObscure;


  final bool? isShowText;


  final Color? backgroundColor;


  final Color? cursorColor;


  final Iterable<String>? autofillHint;

  final BoxBorder? boxBorder;


  final Color? boxColor;


  const CustomTextField({
    super.key,
    required this.hint,
    required this.focusNode,
    required this.controller,
    this.enabled = true,
    this.isObscureText = false,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.textInputType,
    this.prefixFit,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.maxLength,
    this.maxLines = 1,
    this.textInputAction,
    this.textInputFormatter,
    this.onPrefixIconClick,
    this.onSuffixIconClick,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.isShowText,
    this.capitalization = TextCapitalization.none,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.start,
    this.backgroundColor = ColorUtils.white,
    this.cursorColor = ColorUtils.black,
    this.onTapObscure,
    this.valueTextStyle,
    this.valueHintTextStyle,
    this.autofillHint,
    this.boxBorder,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConstants.size30),
        color: boxColor,
        border: boxBorder,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConstants.size8),
        child: TextFormField(
          autofillHints: autofillHint,
          obscureText: isObscureText ? isShowText ?? false : false,
          cursorColor: cursorColor ?? ColorUtils.grey,
          textInputAction: textInputAction,
          maxLength: maxLength,
          maxLines: maxLines,
          focusNode: focusNode,
          enabled: enabled,
          textCapitalization: capitalization,
          style: valueTextStyle ?? FontStyle.openSansSemiBoldTextColor_16,
          textAlign: textAlign,
          textDirection: textDirection,
          readOnly: readOnly,
          keyboardType: textInputType,
          obscuringCharacter: '*',
          controller: controller,
          inputFormatters: textInputFormatter,
          decoration: _textInputDecoration(),
          onChanged: (value) {
            onChanged?.call(value);
          },
          onTap: _onFieldTap,
          onFieldSubmitted: (value) => _onValueSubmitted(value),
        ),
      ),
    );
  }


  InputDecoration _textInputDecoration() => InputDecoration(
    hintStyle: valueHintTextStyle ?? FontStyle.openSansSemiBoldTextColor_16,
    hintText: hint,
    border: InputBorder.none,
    prefixIcon: prefixIcon,
    prefixIconColor: prefixIconColor,
  );


  void _onValueSubmitted(String value) {
    if (onFieldSubmitted != null) {
      onFieldSubmitted!(value);
    }
  }


  void _onFieldTap() {
    onTap?.call();
  }
}
