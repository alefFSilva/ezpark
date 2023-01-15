import 'package:flutter/material.dart';

import '../../../core/theme/logo/animated_logo.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: AnimatedLogo(),
      ),
    );
  }
}
