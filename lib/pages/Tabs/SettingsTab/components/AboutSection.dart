import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class AboutSectionItem {
  final IconData icon;
  final String label;
  final Function()? onPressed;

  const AboutSectionItem({
    required this.icon,
    required this.label,
    this.onPressed,
  });
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    final List<AboutSectionItem> items = [
      AboutSectionItem(
        icon: Icons.info,
        label: localizations.about,
        onPressed: () {
          print('asdasdasd');
        },
      ),
      AboutSectionItem(icon: Icons.privacy_tip, label: localizations.privacyPolicy),
      AboutSectionItem(icon: Icons.announcement, label: localizations.announcements),
      AboutSectionItem(icon: Icons.contact_support, label: localizations.contactUs),
    ];

    List<Widget> children = [
      Text(
        localizations.aboutAndSupport,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      // const SizedBox(height: 16.0),
    ];

    for (var i = 0; i < items.length; i++) {
      children.addAll([
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.translucent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(items[i].icon, color: Theme.of(context).primaryColor, size: 22.0),
              const SizedBox(width: 12.0),
              Text(
                items[i].label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey[700], size: 22.0),
            ],
          ),
        ),
        if (i < items.length - 1) Divider(color: Colors.grey[200], height: 1.0),
      ]);
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: children,
        ),
      ),
    );
  }
}
