import 'package:go_router/go_router.dart';

import '../../Features/home/presentation/views/home_view.dart';

abstract class AppRouter {
  static const kHomeView = '/';
  static final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
  ]);
}
