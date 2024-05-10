import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Utilities/size_config.dart';

/// ValidationTextWidget that represent style of each one of them and shows as list of condition that you want to the app user
class ValidationTextWidget extends StatelessWidget {
  /// Constructor
  const ValidationTextWidget(
      {super.key,
      required this.color,
      required this.text,
      required this.value});

  /// The color of the text
  final Color color;

  /// The text that will be shown
  final String text;

  /// The value that will be shown
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: SizeConfig.width! * 0.03,
          height: SizeConfig.width! * 0.03,
          child: CircleAvatar(
            backgroundColor: color,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.width! * 0.03),
          child: Text(
            text.replaceFirst('-', value.toString()),
            style: TextStyle(fontSize: SizeConfig.width! * 0.04, color: color),
          ),
        )
      ],
    );
  }
}
