import 'package:flutter/material.dart';

import '../../constants/images.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late final AnimationController _loadingAnimation;

  @override
  void initState() {
    super.initState();

    _loadingAnimation = AnimationController(
      vsync: this,
      lowerBound: .5,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _loadingAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _loadingAnimation,
          child: Transform.scale(
            scale: _loadingAnimation.value,
            child: Image.asset(
              logoPath,
              height: 90,
              width: 90,
            ),
          ),
        );
      },
    );
  }
}
