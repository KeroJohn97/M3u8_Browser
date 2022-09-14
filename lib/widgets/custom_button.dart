import 'package:flutter/material.dart';

import '../helpers/color_helper.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? voidCallback;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final Widget? leading;
  final double fontSize;
  final double borderRadius;
  const CustomButton({
    Key? key,
    required this.voidCallback,
    required this.text,
    this.backgroundColor = ColorHelper.primaryColor,
    this.textColor = Colors.black,
    this.height,
    this.width,
    this.leading,
    this.fontSize = 16.0,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () => voidCallback?.call(),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) leading!,
            Text(
              text,
              style: TextStyle(
                // color: textColor,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
