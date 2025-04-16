import "package:dribla_app_v2/dribla_colors.dart";
import "package:flutter/material.dart";
import "package:sizer/sizer.dart";

class StyledDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final Axis actionsDirection;
  final bool smallTitle;

  const StyledDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.actionsDirection = Axis.horizontal,
    this.smallTitle = false,
  });

  List<Widget> _buildActions(List<Widget> actions, Axis direction) {
    final SizedBox spacing = direction == Axis.horizontal
        ? const SizedBox(width: 16)
        : const SizedBox(height: 16);

    Iterable<Widget> addSpacing(Widget element) => [
          direction == Axis.horizontal ? Expanded(child: element) : element,
          if (element != actions.last) spacing,
        ];

    final actionsWithSpacingElements = actions.expand(addSpacing).toList();

    return direction == Axis.horizontal
        ? [Row(children: actionsWithSpacingElements)]
        : actionsWithSpacingElements;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: DriblaColors.black,
            border: Border.all(color: DriblaColors.white, width: 3.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(title!,
                  style: smallTitle
                      ? theme.textTheme.headlineMedium
                          ?.copyWith(fontSize: 19.sp)
                      : theme.textTheme.headlineMedium),
              const SizedBox(height: 24),
            ],
            if (content != null) ...[
              content!,
              const SizedBox(height: 24),
            ],
            if (actions != null && actions!.isNotEmpty)
              ..._buildActions(actions!, actionsDirection)
          ],
        ),
      ),
    );
  }
}
