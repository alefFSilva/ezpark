import 'package:flutter/material.dart';

void showSnackBarMessage(
  BuildContext context, {
  required String message,
  bool isAnErrorMessage = false,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isAnErrorMessage
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        content: Text(
          message,
          style: TextStyle(
            color: isAnErrorMessage
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
