import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tnzeem/core/functions/login_with_gmail.dart';
import 'package:tnzeem/core/utils/app_router.dart';
import 'package:tnzeem/core/utils/loading_manger.dart';
import 'package:tnzeem/core/utils/title_text.dart';
import '../../../../core/utils/custom_btn.dart';
import '../manger/cubit/firebase_func_cubit.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  String digitSeconds = '00', digitMinutes = '00', digitHours = '00';
  DateTime? startInDate;
  bool isLoading = false;
  // create reset func
  void reset() {
    setState(() {
      digitSeconds = '00';
      digitMinutes = '00';
      digitHours = '00';
    });
  }

  DateTime calcDateTime({required DateTime startDate}) {
    Duration difference = DateTime.now().difference(startDate);
    setState(() {
      startInDate = startDate;
      digitSeconds = '${difference.inSeconds % 60}';
      digitMinutes = '${difference.inMinutes % 60}';
      digitHours = '${difference.inHours}';
    });
    return startDate;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManger(
      isLoading: isLoading,
      child: SafeArea(
        child: BlocListener<FirebaseFuncCubit, FirebaseFuncState>(
          listener: (context, state) {
            if (state is FirebaseFuncSuccess) {
              startInDate = state.startDate;
              setState(() {
                isLoading = false;
              });
            } else if (state is FirebaseFuncLoading) {
              setState(() {
                isLoading = true;
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const TitleTextWidget(
                  lebal: 'عدد الساعات',
                  fontSize: 40,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    '$digitHours:$digitMinutes:$digitSeconds',
                    style: TextStyle(
                      fontSize: 80.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 500.h,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color(0xff323f68),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 35.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: const Center(
                              child: Text(
                            'الزتونة',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: ''
                            ),
                          )),
                        ),
                        const Text(
                          'يوم : الاربع',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'تاريخ : 21/02/2024',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'الساعة : 9:20',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),
                const Spacer(),
                CustomIconBtn(
                  text: 'تحديد عدد الساعات الان',
                  width: double.infinity,
                  height: 40.h,
                  textSize: 20,
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  icon: const Icon(Icons.watch_later_outlined),
                  onTap: () {
                    calcDateTime(startDate: startInDate!);
                  },
                ),
                CustomIconBtn(
                  text: 'تسجيل الخروج',
                  width: double.infinity,
                  height: 40.h,
                  textSize: 20,
                  textColor: Colors.white,
                  backgroundColor: Colors.red,
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Authentication().signOutFromGoogle(
                      startIn: startInDate!,
                      onSignIn: () {
                        context.pushReplacement(AppRouter.kLoginView);
                      },
                    );
                    log('message');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
