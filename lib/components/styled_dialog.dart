import "package:flutter/material.dart";

class StyledDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final Axis actionsDirection;

  const StyledDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.actionsDirection = Axis.horizontal,
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
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(title!, style: Theme.of(context).textTheme.headlineMedium),
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
