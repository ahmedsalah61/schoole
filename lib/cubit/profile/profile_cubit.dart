import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:schoole/fackData/mock.dart';
import 'package:schoole/models/error_model.dart';
import 'package:schoole/models/profiles/profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  ErrorModel? errorModel;


  TeacherProfileModel? teacherModel;
  Future getTeacherProfile({
    required int teacher_id
  })async{
    emit(LoadingGetTeacherProfile());
    await MockDioHelper.postData(url: 'getTeacher',
        data: {
          'teacher_id':teacher_id
        }
    ).then((value){
      print(value);
      teacherModel = TeacherProfileModel.fromJson(value);

      emit(SuccessGetTeacherProfile());
    }).catchError((error){
      errorModel = error.response.data;
      emit(ErrorGetTeacherProfile(errorModel!));
    });
  }

  StudentProfileModel? studentModel;
  Future getStudentProfile({
    required int student_id
  })async{
    emit(LoadingGetStudentProfile());
    await MockDioHelper.postData(url:'getStudent',
        data: {
          'student_id':student_id
        }).then((value){
      print(value);
      studentModel = StudentProfileModel.fromJson(value);
      emit(SuccessGetStudentProfile());
    }).catchError((error){
      print(error.response.data);
      errorModel = error.response.data;
      emit(ErrorGetStudentProfile(errorModel!));
    });
  }

}
