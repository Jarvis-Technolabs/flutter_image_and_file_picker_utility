import 'package:flutter/material.dart';

class DeniedPermissionsSettingsDialogModel {
  /// Denied permissions settings dialog's title text
  final String? titleText;

  /// Denied permissions settings dialog's setting button text
  final String? settingsButtonText;

  /// Denied permissions settings dialog's cancel/negative button text
  final String? negativeButtonText;

  /// Denied permissions settings dialog's title text style text
  final TextStyle? titleTextStyle;

  /// Denied permissions settings dialog's description text style text
  final TextStyle? descriptionTextStyle;

  /// Denied permissions settings dialog's setting button style
  final ButtonStyle? settingsButtonStyle;

  /// Denied permissions settings dialog's cancel/negative button style
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
