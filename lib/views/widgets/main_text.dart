import 'package:flutter/material.dart';

class MainText extends StatelessWidget {
  const MainText(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontSize = 12,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final TextBaseline? textBaseline;

  const MainText.pageTitle(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontSize = 32,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.subPageTitle(
    this.text, {
    super.key,
    this.color = Colors.grey,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.title(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.textButton(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.heading(
    this.text, {
    super.key,
    this.color,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.subHeading(
    this.text, {
    super.key,
    this.color = Colors.black54,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.body(
    this.text, {
    super.key,
    this.color = Colors.black54,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.textBaseline,
  });

  const MainText.buttonText(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.fontFamily,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing = 1,
    this.textBaseline,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        textBaseline: textBaseline,
        decoration: decoration,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
