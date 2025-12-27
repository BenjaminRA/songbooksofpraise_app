import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final String title;
  final String? description;
  final Widget action;

  const SettingsRow({
    super.key,
    required this.title,
    this.description,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ];

    if (description != null) {
      children.addAll([
        const SizedBox(height: 2),
        Text(
          description!,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ]);
    }

    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 4,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 3,
          child: action,
        ),
      ],
    );
  }
}
