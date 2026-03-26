import 'package:flutter/material.dart';

typedef OnIconPressedCallback = void Function(String appCode);

class ShareableCodeWidget extends StatelessWidget {
  final String appCode;
  final OnIconPressedCallback? onIconPressed;

  const ShareableCodeWidget({
    super.key,
    required this.appCode,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () => onIconPressed?.call(appCode),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: Text(
              appCode,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.share),
            onPressed: () => onIconPressed?.call(appCode),
          ),
        ),
      ],
    );
  }
}
