import 'package:go_router/go_router.dart';

import '../initializer/widgets/initializer.dart';

enum Routes {
  dashboard('/dashboard');

  const Routes(this.description);
  final String description;
}

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Initializer(),
    ),
  ],
);
