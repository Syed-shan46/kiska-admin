import 'package:flutter/material.dart';


class MyCircularIcon extends StatelessWidget {
  const MyCircularIcon(
      {super.key,
        this.width,
        this.height,
        this.size,
        required this.icon,
        this.color,
        this.backGroundColor,
        this.onPressed});

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backGroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        /* color: backGroundColor != null
            ? backGroundColor!
            : MyHelperFunctions.isDarkMode(context)
            ? MyColor.black.withOpacity(0.9)
            : MyColor.light.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
        */

      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: size),
      ),
    );
  }
}
