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

  // ================= Password Visibility =================
  bool isPassword = true;
  IconData suffix = Icons.visibility_off;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibility());
  }

  // ================= Button Animation =================
  double ratioButtonWidth = 0.4;
  bool isAnimated = false;

  void animateTheButton() {
    ratioButtonWidth = 0.15;
    emit(AnimateTheButton());
  }

  void _resetButton() {
    ratioButtonWidth = 0.4;
    isAnimated = false;
  }

  // ================= Login =================
  LoginModel? loginModel;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isAnimated = true;
    emit(LoginLoadingState());

    try {
      final response = await DioHelper.postData(
        url: EndPoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      loginModel = LoginModel.fromJson(response.data);

      final role = loginModel?.user?.role?.toLowerCase();

      if (role == 'teacher') {
        isteacher = true;
        isparent = false;
      } else if (role == 'parent') {
        isparent = true;
        isteacher = false;
      } else {
        isteacher = false;
        isparent = false;
      }

      _resetButton();
      emit(LoginSuccessState(loginModel!));
    } on DioException catch (error) {
      print("LOGIN ERROR: ${error.response?.data}");

      if (error.response?.data != null) {
        loginModel = LoginModel.fromJson(error.response!.data);
        emit(LoginErrorState(loginModel!));
      } else {
        emit(LoginErrorState(
          LoginModel.fromJson({
            'status': false,
            'message': error.message ?? 'Something went wrong',
            'data': null
          }),
        ));
      }

      _resetButton();
    } catch (error) {
      print("UNKNOWN ERROR: $error");

      emit(LoginErrorState(
        LoginModel.fromJson({
          'status': false,
          'message': error.toString(),
          'data': null
        }),
      ));

      _resetButton();
    }
  }

  // ================= Register Notification =================
  ErrorModel? errorModel;

  Future<void> registerNotification({
    required String userId,
    required String deviceToken,
  }) async {
    emit(RegisterNotificationsLoadingState());

    try {
      await DioHelper.postData(
        url: 'addDeviceToken', // Make sure this exists in backend
        data: {
          'user_id': userId,
          'token': deviceToken,
        },
      );

      emit(RegisterNotificationsSuccessState());
    } on DioException catch (error) {
      print("NOTIFICATION ERROR: ${error.response?.data}");
      emit(RegisterNotificationsErrorState());
    } catch (error) {
      print("UNKNOWN ERROR: $error");
      emit(RegisterNotificationsErrorState());
    }
  }
}