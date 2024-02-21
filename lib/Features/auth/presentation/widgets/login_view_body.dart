import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tnzeem/core/utils/assets_manger.dart';

import '../../../../core/functions/login_with_gmail.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/custom_btn.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            AssetsManger.kLogin,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomIconBtn(
            text: 'تسجيل بجوجل',
            width: double.infinity,
            height: 40.h,
            icon: SvgPicture.asset(
              AssetsManger.kGmailIcon,
              height: 30,
            ),
            onTap: () {
              Authentication().signInWithGoogle(onSignIn: () {
                context.pushReplacement(AppRouter.kHomeView);
              });
            },
          ),
        ],
      ),
    );
  }
}
