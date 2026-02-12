import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schoole/constants.dart';
import 'package:schoole/cubit/profile/profile_cubit.dart';
import 'package:schoole/theme/colors.dart';
import 'package:schoole/ui/components/components.dart';
import 'package:schoole/ui/widgets/profiles_widgets.dart';

// ---------------- FadeAnimation الجديد ----------------
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

// ---------------- TeacherProfile المعدلة ----------------
class TeacherProfile extends StatelessWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ProfileCubit()..getTeacherProfile(teacher_id: user_id),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ErrorGetTeacherProfile) {
            showToast(
                text: 'Error in Getting Teacher Profile',
                state: ToastState.error);
          }
        },
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: null,
            body: ConditionalBuilder(
              condition: cubit.teacherModel != null,
              builder: (context) => SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ===== Header =====
                      Container(
                        width: double.infinity,
                        height: height * 0.48,
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

                            // صورة الأستاذ مع FadeAnimation
                            FadeAnimation(
                              delay: 1,
                              child: Container(
                                width: width * 0.3,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.blue, width: 1),
                                  color: Colors.white,
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImage(
                                  fadeInCurve: Curves.easeIn,
                                  imageUrl:
                                      cubit.teacherModel!.data!.teacherInfo!.img!,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundImage: imageProvider,
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/image/user.png'),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.01),

                            // الاسم + الجنس
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cubit.teacherModel!.data!.teacherInfo!.name!,
                                  style: TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(width: width * 0.02),
                                cubit.teacherModel!.data!.teacherInfo!.gender ==
                                        'Male'
                                    ? Icon(Icons.male_outlined,
                                        size: 50.sp, color: Colors.blue)
                                    : Icon(Icons.female_outlined,
                                        size: 50.sp, color: Colors.pink),
                              ],
                            ),
                            SizedBox(height: height * 0.018),

                            // الايميل
                            Text(
                              cubit.teacherModel!.data!.teacherInfo!.email!,
                              style: TextStyle(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white54),
                            ),
                            SizedBox(height: height * 0.018),

                            // رقم الهاتف
                            Text(
                              cubit.teacherModel!.data!.teacherInfo!.phoneNumber!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 35.sp),
                            ),
                            SizedBox(height: height * 0.03),

                            // الراتب مع FadeAnimation
                            FadeAnimation(
                              delay: 1.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.attach_money_outlined,
                                      color: Colors.white, size: 55.sp),
                                  SizedBox(width: width * 0.01),
                                  Text('Salary: ',
                                      style: TextStyle(
                                          fontSize: 55.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Text(
                                    '${cubit.teacherModel!.data!.teacherInfo!.salary}',
                                    style: TextStyle(
                                        fontSize: 55.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: width * 0.04),
                                  Text('per month',
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white54))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      // ===== Subjects =====
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.06),
                            child: Text(
                              'Subjects',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 55.sp),
                            ),
                          ),
                          SizedBox(height: height * 0.03),

                          FadeAnimation(
                            delay: 1.2,
                            child: Padding(
                              padding: EdgeInsets.only(left: width * 0.06),
                              child: SizedBox(
                                height: height * 0.22,
                                child: ListView.separated(
                                  itemCount:
                                      cubit.teacherModel!.data!.subjects!.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: width * 0.04),
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return teacherSubjects(
                                      width,
                                      height,
                                      cubit.teacherModel!.data!.subjects![index]
                                          .grade!,
                                      cubit.teacherModel!.data!.subjects![index]
                                          .name!,
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      )
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
