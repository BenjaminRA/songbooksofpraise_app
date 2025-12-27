import 'package:flutter/material.dart';

class AppBarState {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? iconColor;
  final List<Widget>? actions;

  const AppBarState({
    required this.title,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.actions,
  });

  AppBarState copyWith({
    String? title,
    String? subtitle,
    IconData? icon,
    Color? backgroundColor,
    Color? titleColor,
    Color? subtitleColor,
    Color? iconColor,
    List<Widget>? actions,
  }) {
    return AppBarState(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      iconColor: iconColor ?? this.iconColor,
      actions: actions ?? this.actions,
    );
  }
}

class AppBarProvider extends ChangeNotifier {
  AppBarState _state = AppBarState(
    title: 'Default Title',
  );

  AppBarState get state => _state;

  List<AppBarState> _stateStack = [];

  bool get showBackButton => _stateStack.length > 1;

  AppBarProvider(AppBarState initialState) {
    _state = initialState;
    _stateStack = [initialState];
  }

  void setActions(List<Widget>? _actions) {
    _state = _state.copyWith(actions: _actions);
    notifyListeners();
  }

  void setTitle(AppBarState newState) {
    _state = newState;
    _stateStack.add(_state);
    notifyListeners();
  }

  void popTitle() {
    if (_stateStack.length > 1) {
      _stateStack.removeLast();
      _state = _stateStack.last;
      notifyListeners();
    }
  }

  List<String> get breadcrumbTitles {
    return _stateStack.map((state) => state.title).toList();
  }
}
