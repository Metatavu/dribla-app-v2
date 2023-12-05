import "package:flutter/material.dart";

class StyledElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Color shadowColor;

  const StyledElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.shadowColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}
