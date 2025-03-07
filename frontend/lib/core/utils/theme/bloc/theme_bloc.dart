// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/utils/theme/bloc/theme_state.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const LightThemeState()) {
    on<ChangeThemeEvent>(_onChangeTheme);

    _loadThemeMode().then((isDark) {
      if (isDark) {
        emit(const DarkThemeState());
      } else {
        emit(const LightThemeState());
      }
    });
  }

  _onChangeTheme(ChangeThemeEvent event, Emitter<ThemeState> emit) async {
    if (state is LightThemeState) {
      emit(const DarkThemeState());
      await _saveThemeMode(isDark: true);
    } else {
      emit(const LightThemeState());
      await _saveThemeMode(isDark: false);
    }
  }

  Future<void> _saveThemeMode({required bool isDark}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  Future<bool> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? false; // Default to light mode
  }
}
