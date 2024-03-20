import 'package:flutter/material.dart';

import '../utils/permission_handler.dart';

class CustomAlertWithTwoButtons extends StatelessWidget {
  /// Denied permissions settings dialog's title text
  final String titleText;

  /// Denied permissions settings dialog's setting button text
  final String settingsButtonText;

  /// Denied permissions settings dialog's cancel/negative button text
  final String negativeButtonText;

  /// Denied permissions settings dialog's title text style text
  final TextStyle? titleTextStyle;

  /// Denied permissions settings dialog's description text style text
  final TextStyle? descriptionTextStyle;

  /// Denied permissions settings dialog's setting button style
  final ButtonStyle? settingsButtonStyle;

  /// Denied permissions settings dialog's cancel/negative button style
  final ButtonStyle? negativeButtonStyle;

  /// pass String value for permanently denied permission dialog description
  final String descriptionText;

  const CustomAlertWithTwoButtons({
    super.key,
    required this.titleText,
    required this.descriptionText,
    required this.negativeButtonText,
    required this.settingsButtonText,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.settingsButtonStyle,
    this.negativeButtonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 20.0,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            titleText,
            style: titleTextStyle ?? Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 18.0),
          Text(
            descriptionText,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 10,
          ),
          const SizedBox(height: 23.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: negativeButtonStyle ??
                    OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).secondaryHeaderColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                child: Text(
                  negativeButtonText,
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await PermissionHandler().openSettings();
                },
                style: settingsButtonStyle ??
                    OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).secondaryHeaderColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                child: Text(
                  settingsButtonText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
