import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/enums/spot_type.dart';
import 'package:flutter/material.dart';

import '../../../core/sizes/spacings.dart';
import 'spot_form.dart';

class SpotDialog extends StatelessWidget {
  const SpotDialog({
    Key? key,
    required this.spotFormAction,
    this.number,
    this.spotType,
  }) : super(key: key);

  final int? number;
  final SpotType? spotType;
  final RespositoryAction spotFormAction;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          '${spotFormAction == RespositoryAction.add ? 'Nova' : 'Editar'} vaga',
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
        content: SpotForm(
          number: number,
          spotType: spotType,
          spotFormAction: spotFormAction,
        ),
      );
}
