import 'package:flutter/material.dart';

import '../colors/colors.dart';

class SomeErrorOcurred extends StatelessWidget {
  const SomeErrorOcurred({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ops, algum erro aconteceu',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.supportError,
            ),
      ),
    );
  }
}
