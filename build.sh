#!/bin/bash

# Clean and get dependencies
flutter clean; flutter pub get;

# Building for Android
flutter build appbundle;

# Building for iOS
flutter build ios --no-codesign; open ios/Runner.xcworkspace;