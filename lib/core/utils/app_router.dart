import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tnzeem/Features/auth/presentation/views/login_view.dart';
import 'package:tnzeem/Features/home/data/repos/firebase_func_repo_impl.dart';
import 'package:tnzeem/Features/splash_view/presentation/views/splash_view.dart';
import 'package:tnzeem/core/functions/login_with_gmail.dart';
import '../../Features/home/presentation/manger/cubit/firebase_func_cubit.dart';
import '../../Features/home/presentation/views/home_view.dart';

abstract class AppRouter {
  static const kHomeView = '/HomeView';
  static const kLoginView = '/LoginView';

  static final router = GoRouter(routes: [
    GoRoute(
      path: kHomeView,
      builder: (context, state) => BlocProvider(
        create: (context) => FirebaseFuncCubit(FirebaseFuncRepoImpl())
          ..getDate(uid: Authentication.user!.uid)
          ..getWorkDate(uid: Authentication.user!.uid),
        child: const HomeView(),
      ),
    ),
    GoRoute(
      path: kLoginView,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
  ]);
}
