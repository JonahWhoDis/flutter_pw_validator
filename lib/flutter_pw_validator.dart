library flutter_pw_validator;

import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Utilities/conditions_helper.dart';
import 'package:flutter_pw_validator/Utilities/validator.dart';

import 'Components/validation_bar_widget.dart';
import 'Components/validation_text_widget.dart';
import 'Resource/my_colors.dart';
import 'Resource/strings.dart';
import 'Utilities/size_config.dart';

/// FlutterPwValidator is a password validator widget that helps you to validate your password with some conditions.
class FlutterPwValidator extends StatefulWidget {
  /// Constructor
  FlutterPwValidator({
    super.key,
    required this.width,
    required this.height,
    required this.minLength,
    required this.onSuccess,
    required this.controller,
    this.uppercaseCharCount = 0,
    this.lowercaseCharCount = 0,
    this.numericCharCount = 1,
    this.specialCharCount = 0,
    this.defaultColor = MyColors.gray,
    this.successColor = MyColors.green,
    this.failureColor = MyColors.red,
    this.strings,
    this.onFail,
    this.keyLocal,
  }) {
    //Initial entered size for global use
    SizeConfig.width = width;
    SizeConfig.height = height;
  }

  /// Constructor
  final int minLength,
      uppercaseCharCount,
      lowercaseCharCount,
      numericCharCount,
      specialCharCount;

  /// Default color of the bar
  final Color defaultColor, successColor, failureColor;

  /// Width and height of the widget
  final double width, height;

  /// Callback function that will be called when all conditions are true
  final Function onSuccess;

  /// Callback function that will be called when any of the conditions are false
  final Function? onFail;

  /// The controller that will be used to get the entered text
  final TextEditingController controller;

  /// The strings that will be used to show the conditions
  final FlutterPwValidatorStrings? strings;

  /// Key for the widget
  final Key? keyLocal;

  @override
  State<StatefulWidget> createState() => FlutterPwValidatorState();

  /// Returns the translated strings
  FlutterPwValidatorStrings get translatedStrings =>
      strings ?? FlutterPwValidatorStrings();
}

/// FlutterPwValidatorState is the state of the FlutterPwValidator widget
class FlutterPwValidatorState extends State<FlutterPwValidator> {
  /// Estimate that this the first run or not
  late bool _isFirstRun;

  /// Variables that hold current condition states
  dynamic _hasMinLength,
      _hasMinUppercaseChar,
      _hasMinLowercaseChar,
      _hasMinNumericChar,
      _hasMinSpecialChar;

  //Initial instances of ConditionHelper and Validator class
  late final ConditionsHelper _conditionsHelper;
  final Validator _validator = Validator();

  /// Get called each time that user entered a character in EditText
  void validate() {
    /// For each condition we called validators and get their new state
    _hasMinLength = _conditionsHelper.checkCondition(
        widget.minLength,
        _validator.hasMinLength,
        widget.controller,
        widget.translatedStrings.atLeast,
        _hasMinLength);

    _hasMinUppercaseChar = _conditionsHelper.checkCondition(
        widget.uppercaseCharCount,
        _validator.hasMinUppercase,
        widget.controller,
        widget.translatedStrings.uppercaseLetters,
        _hasMinUppercaseChar);

    _hasMinLowercaseChar = _conditionsHelper.checkCondition(
        widget.lowercaseCharCount,
        _validator.hasMinLowercase,
        widget.controller,
        widget.translatedStrings.lowercaseLetters,
        _hasMinLowercaseChar);

    _hasMinNumericChar = _conditionsHelper.checkCondition(
        widget.numericCharCount,
        _validator.hasMinNumericChar,
        widget.controller,
        widget.translatedStrings.numericCharacters,
        _hasMinNumericChar);

    _hasMinSpecialChar = _conditionsHelper.checkCondition(
        widget.specialCharCount,
        _validator.hasMinSpecialChar,
        widget.controller,
        widget.translatedStrings.specialCharacters,
        _hasMinSpecialChar);

    /// Checks if all condition are true then call the onSuccess and if not, calls onFail method
    int conditionsCount = _conditionsHelper.getter()!.length;
    int trueCondition = 0;
    for (bool value in _conditionsHelper.getter()!.values) {
      if (value == true) trueCondition += 1;
    }
    if (conditionsCount == trueCondition) {
      widget.onSuccess();
    } else if (widget.onFail != null) {
      widget.onFail!();
    }

    //To prevent from calling the setState() after dispose()
    if (!mounted) return;

    //Rebuild the UI
    setState(() {});
    trueCondition = 0;
  }

  @override
  void initState() {
    super.initState();
    _isFirstRun = true;

    _conditionsHelper = ConditionsHelper(widget.translatedStrings);

    /// Sets user entered value for each condition
    _conditionsHelper.setSelectedCondition(
        widget.minLength,
        widget.uppercaseCharCount,
        widget.lowercaseCharCount,
        widget.numericCharCount,
        widget.specialCharCount);

    /// Adds a listener callback on TextField to run after input get changed
    widget.controller.addListener(() {
      _isFirstRun = false;
      validate();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.width,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Iterate through the conditions map values to check if there is any true values then create green ValidationBarComponent.
                for (bool value in _conditionsHelper.getter()!.values)
                  if (value == true)
                    ValidationBarComponent(color: widget.successColor),
                // Iterate through the conditions map values to check if there is any false values then create red ValidationBarComponent.
                for (bool value in _conditionsHelper.getter()!.values)
                  if (value == false)
                    ValidationBarComponent(color: widget.defaultColor)
              ],
            ),
          ),
          Flexible(
            flex: 7,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                //Iterate through the condition map entries and generate new ValidationTextWidget for each item in Green or Red Color
                children: _conditionsHelper.getter()!.entries.map((entry) {
                  int? value;
                  if (entry.key == widget.translatedStrings.atLeast) {
                    value = widget.minLength;
                  }
                  if (entry.key == widget.translatedStrings.uppercaseLetters) {
                    value = widget.uppercaseCharCount;
                  }
                  if (entry.key == widget.translatedStrings.lowercaseLetters) {
                    value = widget.lowercaseCharCount;
                  }
                  if (entry.key == widget.translatedStrings.numericCharacters) {
                    value = widget.numericCharCount;
                  }
                  if (entry.key == widget.translatedStrings.specialCharacters) {
                    value = widget.specialCharCount;
                  }
                  return ValidationTextWidget(
                    color: _isFirstRun
                        ? widget.defaultColor
                        : entry.value
                            ? widget.successColor
                            : widget.failureColor,
                    text: entry.key,
                    value: value,
                  );
                }).toList()),
          )
        ],
      ),
    );
  }
}
