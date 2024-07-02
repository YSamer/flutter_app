import 'package:flutter/material.dart';
import 'package:flutter_app/core/extensions/assetss_widgets.dart';
import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/views/widgets/main_text.dart';

class MainTextField extends StatefulWidget {
  final String hint;
  final String? title;
  final String? label;
  final FontWeight? fontWeight;
  final Color? colorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? init;
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final int? maxInputLength;
  final bool hideKeyboard;
  final OutlineInputBorder? border;
  final Color? filledColor;
  final Color? borderColor;
  final bool enable;
  final void Function(String value)? onSubmit;
  final bool unfocusWhenTapOutside;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final Color? hintColor;
  final int radius;
  final bool readOnly;
  final bool obscureText;
  final double? hintFontSize;
  final TextDirection? textDirection;
  const MainTextField(
      {super.key,
      this.hint = '',
      this.title,
      this.label,
      this.fontWeight,
      this.colorText,
      this.prefixIcon,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.init,
      this.maxInputLength,
      this.border,
      this.isDense = true,
      this.contentPadding,
      this.filledColor = Colors.white,
      this.suffix,
      this.onSubmit,
      this.enable = true,
      this.style,
      this.hideKeyboard = false,
      this.borderColor,
      this.suffixIcon,
      this.unfocusWhenTapOutside = false,
      this.onTap,
      this.onChanged,
      this.controller,
      this.validator,
      this.radius = 10,
      this.readOnly = false,
      this.obscureText = false,
      this.hintFontSize = 12,
      this.textDirection,
      this.hintColor = Colors.grey});

  @override
  State<MainTextField> createState() => MainTextFieldState();
}

class MainTextFieldState extends State<MainTextField> {
  TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(MainTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      controller = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (mounted) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = getLocale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...{
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 9,
              right: 8,
            ),
            child: MainText.title(
              widget.title ?? '',
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          2.hSize,
        },
        TextFormField(
          obscuringCharacter: '*',
          obscureText: widget.obscureText,
          controller: widget.controller,
          cursorHeight: 22.0,
          enabled: widget.enable,
          maxLines: widget.maxLines,
          maxLength: widget.maxInputLength,
          onFieldSubmitted: widget.onSubmit,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          initialValue: widget.init,
          style: widget.style ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onTapOutside: (event) {
            if (widget.unfocusWhenTapOutside) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
          validator: widget.validator,
          textDirection: widget.textDirection ??
              (isAr ? TextDirection.rtl : TextDirection.ltr),
          decoration: InputDecoration(
            isDense: widget.isDense,
            prefixIcon: widget.prefixIcon,
            suffix: widget.suffix,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            hintText: widget.hint.isNotEmpty ? widget.hint : null,
            labelText: widget.label,
            hintStyle: TextStyle(
                color: widget.hintColor, fontSize: widget.hintFontSize),
            labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
            border: _border(
              color: widget.borderColor ?? Colors.black,
              radius: widget.radius,
            ),
            disabledBorder: _border(
              color: widget.borderColor ?? Colors.grey,
              radius: widget.radius,
            ),
            enabledBorder: _border(
              color: widget.borderColor ?? Colors.grey.withOpacity(0.3),
              radius: widget.radius,
            ),
            focusedBorder: _border(
              color: widget.borderColor ?? Colors.black,
              radius: widget.radius,
            ),
            errorBorder: _border(
              color: Colors.red,
              radius: widget.radius,
            ),
            fillColor: widget.readOnly
                ? Colors.grey
                : widget.filledColor ?? Colors.white,
            filled: true,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border({required Color color, int radius = 25}) {
    return widget.border == null
        ? OutlineInputBorder(
            borderRadius: radius.cBorder,
            borderSide: BorderSide(color: color),
          )
        : widget.border!.copyWith(borderSide: BorderSide(color: color));
  }
}
