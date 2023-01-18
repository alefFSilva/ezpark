import 'package:flutter/material.dart';

import '../../sizes/spacings.dart';
import '../colors/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.message,
    required this.onPressed,
  }) : super(key: key);

  final String message;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(
        message,
        style: textTheme.titleMedium!.copyWith(
          color: colorScheme.error,
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  style: BorderStyle.solid,
                  color: AppColors.neutral100,
                ),
              ),
              child: Text(
                'Cancelar',
                style: textTheme.displaySmall!.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: Spacings.m,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                primary: colorScheme.error,
                elevation: 2,
                shadowColor: Colors.black,
                onPrimary: Theme.of(context).colorScheme.error,
              ),
              child: Text(
                'Ok',
                style: textTheme.displaySmall!.copyWith(
                  color: AppColors.neutral1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
