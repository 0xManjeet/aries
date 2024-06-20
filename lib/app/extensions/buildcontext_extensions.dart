import 'package:flutter/material.dart';

extension NoxExtsBc on BuildContext {
  ThemeData get theme => Theme.of(this);
  NavigatorState get navigator => Navigator.of(this);
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isLight => theme.brightness == Brightness.light;
}
