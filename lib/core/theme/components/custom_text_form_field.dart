import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.controller,
    required this.onChanged,
    required this.labelText,
    this.keyboardType,
    this.validator,
    this.valuesToUppercase = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String? p1)? validator;
  final String labelText;
  final TextInputType? keyboardType;
  final bool valuesToUppercase;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      inputFormatters: valuesToUppercase
          ? [
              ValuesToUpperCaseTextFormatter(),
            ]
          : null,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      cursorColor: AppColors.neutral50,
      textAlign: TextAlign.center,
      style: textTheme.displayMedium!.copyWith(
        color: AppColors.neutral400,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: labelText,
        errorStyle: TextStyle(
          color: colorScheme.error,
        ),
        labelStyle: textTheme.labelSmall!.copyWith(
          color: AppColors.neutral500,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
      ),
    );
  }
}

class ValuesToUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
