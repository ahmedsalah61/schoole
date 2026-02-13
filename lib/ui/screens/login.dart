import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoole/constants.dart';
import 'package:schoole/cubit/auth_cubit.dart';
import 'package:schoole/network/local/cash_helper.dart';
import 'package:schoole/theme/colors.dart';
import 'package:schoole/ui/components/components.dart';
import 'package:schoole/ui/widgets/login_widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var emailFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();

  var formkeyLoginScreen = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var cubit = AuthCubit.get(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // ================= LOGIN SUCCESS =================
        if (state is LoginSuccessState) {
          final loginModel = state.loginModel;
          final user = loginModel.user;
          final tokenValue = loginModel.token;

          if (user == null || tokenValue == null) {
            showToast(
              text: "Invalid login response",
              state: ToastState.error,
            );
            return;
          }

          final userId = user.id ?? "";
          final deviceToken = fcmToken ?? "fake_fcm_token";

          // Register FCM token
          cubit.registerNotification(
            userId: userId,
            deviceToken: deviceToken,
          );

          // Save role flags
          CacheHelper.saveData(
            key: 'isteacher',
            value: isteacher,
          );

          CacheHelper.saveData(
            key: 'isparent',
            value: isparent,
          );

          // Save user id
          CacheHelper.saveData(
            key: 'user_id',
            value: userId,
          ).then((_) {
            user_id = userId;
          });

          // Save token
          CacheHelper.saveData(
            key: 'token',
            value: tokenValue,
          ).then((_) {
            token = tokenValue;
            Navigator.of(context).pushReplacementNamed('/home');
          });

          showToast(
            text: "Login Successful",
            state: ToastState.success,
          );

          cubit.isAnimated = false;
          cubit.ratioButtonWidth = 0.4;
        }

        // ================= LOGIN ERROR =================
        if (state is LoginErrorState) {
          showToast(
            text: "Login Failed",
            state: ToastState.error,
          );

          cubit.isAnimated = false;
          cubit.ratioButtonWidth = 0.4;
        }

        // ================= NOTIFICATION ERROR =================
        if (state is RegisterNotificationsErrorState) {
          showToast(
            text: 'Error in registering notifications',
            state: ToastState.error,
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar: null,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Wave(width),
                    Logo(width),
                  ],
                ),
                WhiteContainer(
                  context,
                  width,
                  height,
                  cubit,
                  emailController,
                  passwordController,
                  emailFocusNode,
                  passwordFocusNode,
                  formkeyLoginScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}