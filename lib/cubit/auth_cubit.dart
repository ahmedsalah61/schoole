import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoole/constants.dart';

import 'package:dio/dio.dart';
import 'package:schoole/models/error_model.dart';
import 'package:schoole/models/login_model.dart';
import 'package:schoole/network/remote/dio_helper.dart';
import 'package:schoole/network/remote/end_points.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_off;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibility());
  }

  var ratioButtonWidth = 0.4;

  bool isAnimated = false;

  void animateTheButton() {
    ratioButtonWidth = 0.15;
    emit(AnimateTheButton());
  }

  LoginModel? loginModel;

  void login({
    required String email,
    required String password,
  }) {
    isAnimated = true;
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.status);
      print(loginModel!.message);

      String role = loginModel!.data!.user!.role!;

      if (role == 'Teacher') {
        isteacher = true;
        isparent = false;
        print(isteacher);
      } else if (role == 'Parent') {
        isparent = true;
        isteacher = false;
        print(isparent);
      } else {
        isparent = false;
        isteacher = false;
      }

      ratioButtonWidth = 0.4;
      isAnimated = false;

      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      if (error is DioException) {
        print(error.response?.data);
        if (error.response?.data != null) {
          loginModel = LoginModel.fromJson(error.response!.data);
          emit(LoginErrorState(loginModel!));
        } else {
          // Create a generic error model or handle it
          emit(LoginErrorState(LoginModel.fromJson(
              {'status': false, 'message': error.message, 'data': null})));
        }
      } else {
        print(error.toString());
        // Handle generic error
        emit(LoginErrorState(LoginModel.fromJson(
            {'status': false, 'message': error.toString(), 'data': null})));
      }
    });
  }

  ErrorModel? errorModel;

  Future registerNotification(
      {required String userId, required String deviceToken}) async {
    emit(RegisterNotificationsLoadingState());
    DioHelper.postData(
      url: 'addDeviceToken',
      data: {
        'user_id': userId,
        'token': deviceToken,
      },
    ).then((value) {
      emit(RegisterNotificationsSuccessState());
    }).catchError((error) {
      //errorModel = LoginModel.fromJson(error.response.data);
      emit(RegisterNotificationsErrorState());
      print(error.toString());
    });
  }
}
