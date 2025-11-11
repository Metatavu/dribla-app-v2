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
          child: Text(
            appCode,
            style: theme.textTheme.bodySmall,
          ),
          flex: 1,
        ),
        Expanded(
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.share),
            onPressed: () => onIconPressed?.call(appCode),
          ),
          flex: 1,
        ),
      ],
    );
  }
}
