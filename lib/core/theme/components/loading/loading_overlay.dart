import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logo/animated_logo.dart';

final loadingOverlayProvider =
    StateNotifierProvider<LoadingOverlayNotifier, bool>((ref) {
  return LoadingOverlayNotifier();
});

class LoadingOverlayNotifier extends StateNotifier<bool> {
  LoadingOverlayNotifier() : super(false);

  void toggle() => state = !state;
}

class LoadingOverlay extends ConsumerWidget {
  const LoadingOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(loadingOverlayProvider);
    return Stack(
      children: [
        child,
        Visibility(
          visible: isLoading,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: const Center(
            child: AnimatedLogo(),
          ),
        ),
      ],
    );
  }
}
