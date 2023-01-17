import 'package:ezpark/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:ezpark/features/spots/spots_list/pages/spots_list_page.dart';
import 'package:go_router/go_router.dart';

import '../initializer/widgets/initializer.dart';

enum Routes {
  dashboard('/dashboard'),
  spotsList('/spotslist');

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
    GoRoute(
      path: Routes.spotsList.description,
      builder: (context, state) => const SpotsListPage(),
    )
  ],
);
