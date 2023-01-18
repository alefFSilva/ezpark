import 'package:ezpark/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:ezpark/features/entry/presentation/pages/new_entry_page.dart';
import 'package:ezpark/features/spots/presentation/pages/spots_list_page.dart';
import 'package:go_router/go_router.dart';

import '../initializer/widgets/initializer.dart';

enum Routes {
  dashboard('/dashboard'),
  spotsList('/spotslist'),
  newEntryPage('/newEntryPage');

  const Routes(this.description);
  final String description;
}

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const Initializer(),
    ),
    GoRoute(
      path: Routes.dashboard.description,
      builder: (_, __) => const DashBoardPage(),
    ),
    GoRoute(
      path: Routes.spotsList.description,
      builder: (_, __) => const SpotsListPage(),
    ),
    GoRoute(
      path: Routes.newEntryPage.description,
      builder: (_, __) => const NewEntryPage(),
    )
  ],
);
