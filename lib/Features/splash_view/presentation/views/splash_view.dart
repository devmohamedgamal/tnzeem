import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tnzeem/core/functions/login_with_gmail.dart';

import '../../../../core/utils/app_router.dart';
import '../widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToOnBoarding();
  }

  _navigateToOnBoarding() async {
    await Future.delayed(const Duration(seconds: 2), () async {
      if (Authentication.user != null) {
        context.pushReplacement(AppRouter.kHomeView);
      } else {
        context.pushReplacement(AppRouter.kLoginView);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashViewBody(),
    );
  }
}
