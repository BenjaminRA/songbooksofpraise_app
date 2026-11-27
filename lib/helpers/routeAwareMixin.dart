import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/TabNavigatorProvider.dart';

mixin RouteAwareMixin<T extends StatefulWidget> on State<T> {
  int? _songTabIndex;
  int? _previousTabIndex;

  Future<void> onBackFromAnotherTab() async {
    throw UnimplementedError();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final tabIndex = context.watch<TabNavigatorProvider>().tabIndex;
    _songTabIndex ??= tabIndex;

    if (_previousTabIndex != null && tabIndex == _songTabIndex && _previousTabIndex != tabIndex) {
      await onBackFromAnotherTab();
    }
    _previousTabIndex = tabIndex;
  }
}
