import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:schoole/constants.dart';
import 'package:schoole/fackData/mock.dart';
import 'package:schoole/models/error_model.dart';
import 'package:schoole/models/marks_model.dart';

part 'marks_state.dart';

class MarksCubit extends Cubit<MarksState> {
  MarksCubit() : super(MarksInitial());

  static MarksCubit get(context) => BlocProvider.of(context);

  int markTypeIndex = 0;

  void changeCatIndexGuest(id) {
    markTypeIndex = marksType.indexOf(marksType[id]);
    emit(ChangeMarkTypeIndexState());
  }


  /////////////////////////////////////////////////////////////////////////////

  ErrorModel? errorModel;

  MarksModel? marksModel;

  Future getMarksWithType({required int user_id, required int type_id}) async {
    emit(GetMarksLoading());

    marksModel = null;

    String type = '';

    if (type_id == 0) {
      type = 'quiz';
    }
    else if (type_id == 1) {
      type = 'exam1';
    }
    else if (type_id == 2) {
      type = 'exam2';
    }
    else if (type_id == 3) {
      type = 'mid';
    }
    else {
      type = 'final';
    }

    MockDioHelper.postData(
        url: 'getMarks',
        data: {
          'id': user_id,
          'type': type,
        },
        token: token)
        .then((value) async {
      print('value.data: ${value}');
      marksModel = MarksModel.fromJson(value);

      print(marksModel!.data!.percentage);

      print(marksModel!.data!.marksStudentData!.length);

      emit(GetMarksSuccess());
    }).catchError((error) {
      print('error.response.data: ${error.response.data}');
      errorModel = ErrorModel.fromJson(error.response.data);
      emit(GetMarksError(errorModel!));
      print(error.toString());
    });
  }

}
