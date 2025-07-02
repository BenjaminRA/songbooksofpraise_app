import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SettingsProviderTextSize {
  small,
  medium,
  large,
}

class SettingsProvider extends ChangeNotifier {
  SettingsProviderTextSize _textSize = SettingsProviderTextSize.medium;
  Brightness _brightness = Brightness.light;
  bool _keepScreenOn = true;
  int _defaultTranspose = 0;
  bool _showChordsByDefault = false;

  SettingsProvider({
    SettingsProviderTextSize textSize = SettingsProviderTextSize.medium,
    Brightness brightness = Brightness.light,
    bool keepScreenOn = true,
    int defaultTranspose = 0,
    bool showChordsByDefault = false,
  })  : _textSize = textSize,
        _brightness = brightness,
        _keepScreenOn = keepScreenOn,
        _defaultTranspose = defaultTranspose,
        _showChordsByDefault = showChordsByDefault;

  SettingsProviderTextSize get textSize => _textSize;
  Brightness get brightness => _brightness;
  bool get keepScreenOn => _keepScreenOn;
  int get defaultTranspose => _defaultTranspose;
  bool get showChordsByDefault => _showChordsByDefault;

  void setTextSize(SettingsProviderTextSize newSize) {
    _textSize = newSize;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('textSize', newSize.name);
    });

    notifyListeners();
  }

  void setBrightness(Brightness newBrightness) {
    _brightness = newBrightness;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('brightness', newBrightness == Brightness.dark ? 'dark' : 'light');
    });

    notifyListeners();
  }

  void setKeepScreenOn(bool value) {
    _keepScreenOn = value;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('keepScreenOn', value);
    });

    notifyListeners();
  }

  void setDefaultTranspose(int value) {
    _defaultTranspose = value;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('defaultTranspose', value);
    });

    notifyListeners();
  }

  void setShowChordsByDefault(bool value) {
    _showChordsByDefault = value;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('showChordsByDefault', value);
    });

    notifyListeners();
  }
}
