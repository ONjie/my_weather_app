import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class LightThemeState extends ThemeState {
  const LightThemeState() : super(ThemeMode.light);
}

class DarkThemeState extends ThemeState {
  const DarkThemeState() : super(ThemeMode.dark);
}