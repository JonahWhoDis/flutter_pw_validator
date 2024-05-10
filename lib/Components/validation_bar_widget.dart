import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Utilities/size_config.dart';

/// ValidationBarWidget that represent style of each one of them and shows under the TextField
class ValidationBarComponent extends StatelessWidget {
  /// Constructor
  const ValidationBarComponent({super.key, required this.color});

  /// Color of the bar
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        /// We Can set, width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 0.005),
        height: SizeConfig.width! * 0.015,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(SizeConfig.width!))),
      ),
    );
  }
}