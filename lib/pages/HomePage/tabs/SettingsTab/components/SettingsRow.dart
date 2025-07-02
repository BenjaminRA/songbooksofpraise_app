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
          'Prevent screen from sleeping',
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
        action
      ],
    );
  }
}
