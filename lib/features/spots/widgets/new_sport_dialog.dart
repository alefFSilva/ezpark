import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/features/spots/widgets/new_spot_form.dart';
import 'package:flutter/material.dart';

import '../../../core/sizes/spacings.dart';

class NewSpotDialog extends StatelessWidget {
  const NewSpotDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Nova vaga',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Spacings.m.width,
        vertical: Spacings.xxs.height,
      ),
      content: const NewSpotForm(),
    );
  }
}
