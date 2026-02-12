import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schoole/constants.dart';
import 'package:schoole/cubit/profile/profile_cubit.dart';
import 'package:schoole/theme/colors.dart';
import 'package:schoole/ui/components/components.dart';

// ------------------- FadeAnimation الجديد -------------------
class FadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({required this.delay, required this.child, Key? key})
      : super(key: key);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _translateY = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // تشغيل Animation بعد delay
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: Offset(0, _translateY.value),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

// ------------------- الصفحة المعدلة -------------------
class StudentProfile extends StatelessWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) =>
          ProfileCubit()..getStudentProfile(student_id: isparent ? childId : user_id),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ErrorGetStudentProfile) {
            showToast(
                text: 'Error in Getting Student Profile',
                state: ToastState.error);
          }
        },
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: null,
            body: ConditionalBuilder(
              condition: cubit.studentModel != null,
              builder: (context) => SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ===== Header =====
                      Container(
                        width: double.infinity,
                        height: height * 0.53,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0XFF0287D0),
                            Color(0xFF1C76D1),
                          ]),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.02),
                        child: Column(
                          children: [
                            // Back + Title
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.arrow_back_outlined,
                                    color: Colors.white,
                                    size: 50.sp,
                                  ),
                                ),
                                SizedBox(width: width * 0.24),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 60.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.03),

                            // Name + Gender
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cubit.studentModel!.data!.studentData!.name!,
                                  style: TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(width: width * 0.02),
                                cubit.studentModel!.data!.studentData!.gender ==
                                        'Male'
                                    ? Icon(
                                        Icons.male_outlined,
                                        size: 50.sp,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.female_outlined,
                                        size: 50.sp,
                                        color: Colors.pink,
                                      ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),

                            // BirthDate
                            Text(
                              cubit.studentModel!.data!.studentData!.birthDate!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 35.sp),
                            ),
                            SizedBox(height: height * 0.018),

                            // Class + Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Class: ${Mapclasses[cubit.studentModel!.data!.studentData!.grade!]} | ',
                                  style: TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                SizedBox(width: width * 0.01),
                                Text(
                                  'Section: ${cubit.studentModel!.data!.studentData!.sectionNumber!}',
                                  style: TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.015),

                            // Address
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.place_outlined,
                                    size: 35.sp, color: Colors.black),
                                SizedBox(width: width * 0.02),
                                Text(
                                  cubit.studentModel!.data!.studentData!.address!,
                                  style: TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white54),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.03),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      // ===== Email & Phone =====
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 35.sp)),
                            SizedBox(height: height * 0.01),
                            Text(
                              cubit.studentModel!.data!.studentData!.email!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 40.sp),
                            ),
                            SizedBox(height: height * 0.01),
                            Divider(thickness: 1, color: Colors.grey),
                            SizedBox(height: height * 0.01),
                            Text('Phone Number',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 35.sp)),
                            SizedBox(height: height * 0.01),
                            Text(
                              cubit.studentModel!.data!.studentData!.phoneNumber!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 40.sp),
                            ),
                            SizedBox(height: height * 0.01),
                            Divider(thickness: 1, color: Colors.grey),
                            SizedBox(height: height * 0.01),

                            // ===== Bus & Installment Row مع FadeAnimation =====
                            FadeAnimation(
                              delay: 1.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Bus Installment
                                  Container(
                                    width: width * 0.4,
                                    height: height * 0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          blurRadius: 5,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01,
                                        vertical: height * 0.02),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.bus_alert,
                                            size: 50.sp, color: Colors.blue),
                                        SizedBox(height: height * 0.01),
                                        Text(
                                          cubit.studentModel!.data!.studentData!
                                                      .isInBus! ==
                                                  1
                                              ? cubit.studentModel!.data!
                                                  .studentData!.leftForBus!
                                                  .toString()
                                              : 'Not Registered',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 40.sp),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Text('Bus Installment',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 35.sp)),
                                      ],
                                    ),
                                  ),

                                  // General Installment
                                  Container(
                                    width: width * 0.4,
                                    height: height * 0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          blurRadius: 5,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01,
                                        vertical: height * 0.02),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.monetization_on_outlined,
                                            size: 50.sp, color: Colors.blue),
                                        SizedBox(height: height * 0.01),
                                        Text(
                                          cubit.studentModel!.data!.studentData!
                                              .leftForQusat!
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 40.sp),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Text('Installment',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 35.sp)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              fallback: (context) => SpinKitApp(width),
            ),
          );
        },
      ),
    );
  }
}
