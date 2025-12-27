import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

class AppBarWithProvider extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<NavigatorState> currentKey;
  const AppBarWithProvider(this.currentKey, {super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appBarState = context.watch<AppBarProvider>().state;
    final showBackButton = context.watch<AppBarProvider>().showBackButton;

    return AppBar(
      backgroundColor: appBarState.backgroundColor,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              color: appBarState.titleColor,
              onPressed: () {
                currentKey.currentState?.pop();
                // Provider.of<AppBarProvider>(context, listen: false).popTitle();
              },
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            appBarState.icon,
            color: appBarState.iconColor ?? Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: appBarState.title,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      appBarState.title,
                      style: TextStyle(
                        color: appBarState.titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (appBarState.subtitle != null)
                  Text(
                    appBarState.subtitle!,
                    style: TextStyle(
                      color: appBarState.subtitleColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: appBarState.actions,
    );
  }
}
