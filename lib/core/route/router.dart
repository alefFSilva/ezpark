import 'package:ezpark/features/dashboard/presentation/pages/dashboard_page.dart';
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
    GoRoute(
      path: Routes.dashboard.description,
      builder: (context, state) => const DashBoardPage(),
    ),
  ],
);
