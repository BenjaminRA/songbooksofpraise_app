import 'package:flutter/material.dart';

class AppBarState {
  final String title;
  final IconData icon;

  const AppBarState({
    required this.title,
    required this.icon,
  });
}

class AppBarProvider extends ChangeNotifier {
  AppBarState _state = AppBarState(
    title: 'Default Title',
    icon: Icons.library_books,
  );

  AppBarState get state => _state;

  List<AppBarState> _stateStack = [];

  bool get showBackButton => _stateStack.length > 1;

  AppBarProvider(AppBarState initialState) {
    _state = initialState;
    _stateStack = [initialState];
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
}
