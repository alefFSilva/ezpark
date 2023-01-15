import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/splashscreen/presentation/splash_screen_page.dart';
import '../../route/router.dart';
import '../providers.dart';

class Initializer extends ConsumerWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<void>(
      initializerProvider,
      ((previous, next) {
        print('go to dashboard');
      }),
    );
    return const SplashScreenPage();
  }
}
