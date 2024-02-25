import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tnzeem/core/functions/calc_all_work_date.dart';
import 'package:tnzeem/core/functions/login_with_gmail.dart';
import 'package:tnzeem/core/utils/app_router.dart';
import 'package:tnzeem/core/utils/custom_error_widget.dart';
import 'package:tnzeem/core/utils/custom_loading_indecator.dart';
import 'package:tnzeem/core/utils/loading_manger.dart';
import 'package:tnzeem/core/utils/subtitle_text.dart';
import 'package:tnzeem/core/utils/title_text.dart';
import '../../../../core/utils/custom_btn.dart';
import '../../../../core/utils/my_app_methods.dart';
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
  List<String> dateList = [];
  Map<String, dynamic> allWorkDate = {};
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
                        height: 40.h,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'الزتونة',
                          style: TextStyle(fontSize: 26, fontFamily: 'Marhey'),
                        )),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SubTitleTextWidget(
                              lebal: 'التاريخ',
                              color: Colors.cyanAccent,
                            ),
                            SubTitleTextWidget(
                              lebal: 'الساعات',
                              color: Colors.cyanAccent,
                            ),
                            SubTitleTextWidget(
                              lebal: 'الرقم',
                              color: Colors.cyanAccent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocConsumer<FirebaseFuncCubit, FirebaseFuncState>(
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
                        builder: (context, state) {
                          if (state is GetWorkDateSuccess) {
                            dateList = state.allWorkDate.keys.toList();
                            allWorkDate = state.allWorkDate;
                            return dateList.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 100),
                                      child: Text(
                                        'لا يوجد عدد ايام الي الان',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: state.allWorkDate.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: ListTile(
                                            trailing: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${i + 1}",
                                                  style: const TextStyle(
                                                      color: Colors.purple),
                                                ),
                                              ),
                                            ),
                                            leading: Text(
                                              dateList[i],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            title: state.allWorkDate[
                                                            dateList[i]]
                                                        ['workHours']['h'] ==
                                                    null
                                                ? const Text('لا يوجد ساعات')
                                                : Text(
                                                    "     ${state.allWorkDate[dateList[i]]['workHours']['h']}:${state.allWorkDate[dateList[i]]['workHours']['m']}:${state.allWorkDate[dateList[i]]['workHours']['s']}",
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                          } else if (state is GetWorkDateFailure) {
                            return const CustomLoadingIndecator();
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text(
                                  'لا يوجد عدد ايام الي الان',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ]),
              ),
              const Spacer(),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconBtn(
                      text: 'تحديد الساعات',
                      width: 180.w,
                      height: 40.h,
                      textSize: 14,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      icon: const Icon(Icons.watch_later_outlined),
                      onTap: () {
                        calcDateTime(startDate: startInDate!);
                      },
                    ),
                    CustomIconBtn(
                      text: 'تحديد كل الساعات',
                      width: 180.w,
                      height: 40.h,
                      textSize: 14,
                      textColor: Colors.black,
                      backgroundColor: Colors.yellow,
                      icon: const Icon(Icons.watch_later_outlined),
                      onTap: () {
                        Map<String, dynamic> finalHours = calcAllWorkDate(
                            dates: allWorkDate, dateList: dateList);
                        setState(() {
                          digitHours = "${finalHours['h']}";
                          digitMinutes = "${finalHours['m']}";
                          digitSeconds = "${finalHours['s']}";
                        });
                      },
                    ),
                  ],
                ),
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
                  MyAppMethods.showErrorORWarningDialog(
                    context: context,
                    subtitle: 'تسجيل الخروج',
                    isError: false,
                    fct: () {
                      Authentication().signOutFromGoogle(
                        startIn: startInDate!,
                        onSignIn: () {
                          context.pushReplacement(AppRouter.kLoginView);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
