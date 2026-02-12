import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:schoole/constants.dart';
import 'package:schoole/fackData/mock.dart';
import 'package:schoole/models/error_model.dart';
import 'package:schoole/models/notific/notifications_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of(context);



  /////////////////////////////////////////////////////////////////////////////

  // Absences

  ErrorModel? errorModel;

  AbsencesModel? absencesModel;

  Future getAbsences({required int student_id}) async {

    emit(GetAbsencesLoading());
    MockDioHelper.postData(
        url: 'getAbsences',
        data: {
          'student_id': student_id,
        },
        token: token)
        .then((value) async {
      print('value.data: ${value}');
      absencesModel = AbsencesModel.fromJson(value);

      emit(GetAbsencesSuccess());
    }).catchError((error) {
      print('error.response.data: ${error.response.data}');
      errorModel = ErrorModel.fromJson(error.response.data);
      emit(GetAbsencesError(errorModel!));
      print(error.toString());
    });

  }


////////////////////////////////////////////////////////////////////////////////
  //Notifications

  NotificationsModel? notificationsModel;

  Future getNotifications() async {

    emit(GetAbsencesLoading());
    MockDioHelper.getData(
        url: 'getNotifications',
        token: token)
        .then((value) async {
      print('value.data: ${value}');
      notificationsModel = NotificationsModel.fromJson(value);

      emit(GetNotificationsSuccess());
    }).catchError((error) {
      print('error.response.data: ${error.response.data}');
      errorModel = ErrorModel.fromJson(error.response.data);
      emit(GetNotificationsError(errorModel!));
      print(error.toString());
    });

  }


}
