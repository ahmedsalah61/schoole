

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
    final height = MediaQuery
        .of(context)
        .size
        .height;

    //final width = MediaQuery.of(context).size.width;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    var cubit = AuthCubit.get(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState)  {
          print(state.loginModel.status!);
          print(state.loginModel.data!.token);

         final userId = state.loginModel.data?.user?.user_id ?? 1;
final deviceToken = fcmToken ?? "fake_fcm_token";
cubit.registerNotification(userId: userId.toString(), deviceToken: deviceToken);


          CacheHelper.saveData(
            key: 'isteacher',
            value: isteacher,
          ).then(
                (value) {
                  isteacher = isteacher;
            },
          );

          CacheHelper.saveData(
            key: 'isparent',
            value: isparent,
          ).then(
                (value) {
                  isparent = isparent;
            },
          );

          CacheHelper.saveData(
            key: 'user_id',
            value: state.loginModel.data!.user!.user_id,
          ).then(
                (value) {
              user_id = state.loginModel.data!.user!.user_id;
            },
          );

          CacheHelper.saveData(
            key: 'token',
            value: state.loginModel.data!.token,
          ).then(
                (value) {
              token = state.loginModel.data!.token;
              Navigator.of(context).pushReplacementNamed('/home');
            },
          );



          showToast(
            text: state.loginModel.message!,
            state: ToastState.success,
          );

          cubit.isAnimated = false;
          cubit.ratioButtonWidth = 0.4;


        }
        if (state is LoginErrorState) {
          showToast(
            text: state.loginModel.message!,
            state: ToastState.error,

          );
          cubit.isAnimated = false;
          cubit.ratioButtonWidth = 0.4;
        }


        if (state is RegisterNotificationsErrorState) {
          showToast(text: 'Error in registering notifications', state: ToastState.error);
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
            //physics: BouncingScrollPhysics(),
            //reverse: true,
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
                    formkeyLoginScreen)
              ],
            ),
          ),
        ),

      ),
    );
  }
}
