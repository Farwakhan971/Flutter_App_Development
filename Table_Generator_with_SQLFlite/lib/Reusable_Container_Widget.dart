import 'package:flutter/material.dart';

class IconColumn extends StatelessWidget {
  IconColumn({required this.icon, this.label});
  final IconData? icon;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 60.0,
        ),
        const SizedBox(
          height: 12.0,
        ),
        label ?? const SizedBox(),
      ],
    );
  }
}
