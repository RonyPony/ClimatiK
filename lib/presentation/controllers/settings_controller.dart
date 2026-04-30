import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, AppSettingsModel>((ref) => SettingsController());

class SettingsController extends StateNotifier<AppSettingsModel> {
  SettingsController() : super(AppSettingsModel.defaults());
  void setTheme(ThemeMode mode) => state = AppSettingsModel(themeMode: mode, tempUnit: state.tempUnit, windUnit: state.windUnit, animations: state.animations, refreshOnOpen: state.refreshOnOpen);
  void toggleAnimations(bool v) => state = AppSettingsModel(themeMode: state.themeMode, tempUnit: state.tempUnit, windUnit: state.windUnit, animations: v, refreshOnOpen: state.refreshOnOpen);
}
