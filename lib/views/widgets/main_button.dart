import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final bool expanded;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final double? elevation;
  final double? verticalPadding;
  final double? horizontalPadding;

  const MainButton({
    super.key,
    required this.child,
    this.onPressed,
    this.expanded = true,
    this.radius = 5,
    this.color = Colors.blue,
    this.borderColor,
    this.elevation,
    this.verticalPadding = 14,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: expanded ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 0,
            horizontal: horizontalPadding ?? 0,
          ),
          child: child,
        ),
      ),
    );
  }
}
