import 'package:flutter/material.dart';

class DeniedPermissionsSettingsDialogModel {
  final String? titleText;
  final String? settingsButtonText;
  final String? negativeButtonText;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final ButtonStyle? settingsButtonStyle;
  final ButtonStyle? negativeButtonStyle;

  DeniedPermissionsSettingsDialogModel({
    this.titleText,
    this.settingsButtonText,
    this.negativeButtonText,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.settingsButtonStyle,
    this.negativeButtonStyle,
  });
}
