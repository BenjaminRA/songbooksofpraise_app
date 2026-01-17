import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

enum SettingsProviderTextSize {
  small,
  medium,
  large,
}

class SettingsProvider extends ChangeNotifier {
  SettingsProviderTextSize _textSize = SettingsProviderTextSize.medium;
  Brightness _brightness = Brightness.light;
  bool _keepScreenOn = true;
  ChordNotation _defaultNotation = ChordNotation.Letter;
  bool _showChordsByDefault = false;
  bool _showSheetByDefault = false;

  SettingsProvider({
    SettingsProviderTextSize textSize = SettingsProviderTextSize.medium,
    Brightness brightness = Brightness.light,
    bool keepScreenOn = true,
    ChordNotation defaultNotation = ChordNotation.Letter,
    bool showChordsByDefault = false,
    bool showSheetByDefault = false,
  })  : _textSize = textSize,
        _brightness = brightness,
        _keepScreenOn = keepScreenOn,
        _defaultNotation = defaultNotation,
        _showChordsByDefault = showChordsByDefault,
        _showSheetByDefault = showSheetByDefault;

  SettingsProviderTextSize get textSize => _textSize;
  Brightness get brightness => _brightness;
  bool get keepScreenOn => _keepScreenOn;
  ChordNotation get defaultNotation => _defaultNotation;
  bool get showChordsByDefault => _showChordsByDefault;
  bool get showSheetByDefault => _showSheetByDefault;

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

  void setDefaultNotation(ChordNotation value) {
    _defaultNotation = value;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('defaultNotation', value == ChordNotation.Letter ? 'Letter' : 'Solfege');
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

  void setShowSheetByDefault(bool value) {
    _showSheetByDefault = value;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('showSheetByDefault', value);
    });

    notifyListeners();
  }
}
