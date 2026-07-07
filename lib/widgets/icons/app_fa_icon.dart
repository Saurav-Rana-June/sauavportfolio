import 'package:flutter/widgets.dart';

class AppFaIcon extends StatelessWidget {
  const AppFaIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  final IconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
