import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.green[50]!,
  onPrimary: Colors.black,
  secondary: Colors.green[300]!,
  onSecondary: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  background: Colors.grey[200]!,
  onBackground: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  // Add more colors if needed
);

final ThemeData mainAppTheme = ThemeData(
  colorScheme: colorScheme,
  primaryColor: colorScheme.primary,
  secondaryHeaderColor: colorScheme.secondary,
  buttonTheme: ButtonThemeData(
    buttonColor: colorScheme.primary,
    textTheme: ButtonTextTheme.primary,
  ),
  scaffoldBackgroundColor: colorScheme.background,
);
