import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

class Router {
  static Future<T?> navigateTo<T>(
    BuildContext context, {
    required Widget page,
    String? title,
    IconData? icon,
    Color? backgroundColor,
    Color? titleColor,
    Color? subtitleColor,
    Color? iconColor,
  }) {
    AppBarState currentState = Provider.of<AppBarProvider>(context, listen: false).state;
    Provider.of<AppBarProvider>(context, listen: false).setTitle(
      AppBarState(
        title: title ?? currentState.title,
        icon: icon ?? currentState.icon,
        backgroundColor: backgroundColor ?? currentState.backgroundColor,
        titleColor: titleColor ?? currentState.titleColor,
        subtitleColor: subtitleColor ?? currentState.subtitleColor,
        iconColor: iconColor ?? currentState.iconColor,
      ),
    );
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
