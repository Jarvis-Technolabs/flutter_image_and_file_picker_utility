import 'package:flutter/material.dart';

import '../utils/permission_handler.dart';

class CustomAlertWithTwoButtons extends StatelessWidget {
  final String titleText;
  final String settingsButtonText;
  final String descriptionText;
  final String negativeButtonText;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final ButtonStyle? settingsButtonStyle;
  final ButtonStyle? negativeButtonStyle;

  const CustomAlertWithTwoButtons({super.key,
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
