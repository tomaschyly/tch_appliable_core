import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final Widget icon;
  final void Function()? onPressed;
  final double width;
  final double height;
  final double iconWidth;
  final double iconHeight;
  final Color? backgroundColor;
  final Color? borderColor;

  /// IconButtonWidget initialization
  IconButtonWidget({
    required this.icon,
    this.onPressed,
    this.width = 48,
    this.height = 48,
    this.iconWidth = 24,
    this.iconHeight = 24,
    this.backgroundColor,
    this.borderColor,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: borderColor ?? theme.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                width: iconWidth,
                height: iconHeight,
                child: icon,
              ),
            ),
          ),
          splashColor: theme.primaryColor,
          onTap: onPressed,
        ),
      ),
    );
  }
}
