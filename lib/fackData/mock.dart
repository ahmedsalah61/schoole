import 'dart:async';
import 'package:dio/dio.dart';

class MockDioHelper {

  /// ------------------ POST Methods ------------------

  static Future<Map<String, dynamic>> postData({
    required String url,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    switch (url) {
      // 🔑 تسجيل الدخول
      case 'userLogin':
        return {
          "status": true,
          "message": "Login successful",
          "data": {
            "token": "fake_token_12345",
            "user": {
              "user_id": 1,
              "name": data?['email'] ?? "Ahmed Salah",
              "email": data?['email'] ?? "aeng30358@gmail.com",
              "role": "student",
              "gender": "male",
              "phone_number": "01128177599"
            }
          }
        };

      // 🚪 تسجيل الخروج
      case 'logout':
        return {"status": true, "message": "Logout successful"};

      // 📝 ارسال شكوى
      case 'sendComplaint':
        return {"status": true, "message": "Complaint sent successfully"};

      default:
        return {"status": false, "message": "Mock POST endpoint not found"};
    }
  }

  /// ------------------ POST Image Methods ------------------

  static Future<Map<String, dynamic>> postDataImage({
    required String url,
    required FormData data,
    String? token,
    ProgressCallback? onSendProgress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (onSendProgress != null) {
      for (int sent = 0; sent <= 100; sent += 20) {
        await Future.delayed(Duration(milliseconds: 50));
        onSendProgress(sent, 100);
      }
      
    }
    

    switch (url) {
      case 'addHomework':
        return {"status": true, "message": "Homework uploaded successfully"};

      default:
        return {"status": false, "message": "Mock postDataImage endpoint not found"};
    }
  }

  /// ------------------ GET Methods ------------------

  static Future<Map<String, dynamic>> getData({
    required String url,
    String? token,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    switch (url) {
      // 🏠 Home
      case 'appHome':
        return {
          "status": true,
          "data": {
            "user": {
              "name": "Ahmed Salah",
              "img": "https://via.placeholder.com/150",
              "grade": 12,
              "section_number": 2,
              "childs": [
                {
                  "id": 1,
                  "name": "Omar",
                  "img": "https://via.placeholder.com/150",
                  "grade": 5,
                  "section_number": 1
                },
                {
                  "id": 2,
                  "name": "Laila",
                  "img": "https://via.placeholder.com/150",
                  "grade": 3,
                  "section_number": 2
                }
              ]
            }
          }
        };

      // 📚 Sessions
      case 'sessions':
        return {
          "status": true,
          "data": [
            {
              "session_id": 1,
              "date": "2025-11-13",
              "body": "Math revision session",
              "maximum_students": 20,
              "current_booked": 15,
              "price": 50,
              "teacher_name": "Mr. Khaled",
              "subject_name": "Mathematics"
            },
            {
              "session_id": 2,
              "date": "2025-11-14",
              "body": "Physics lab practice",
              "maximum_students": 15,
              "current_booked": 8,
              "price": 60,
              "teacher_name": "Dr. Mona",
              "subject_name": "Physics"
            }
          ]
        };

      // 🧾 Notifications
      case 'notifications':
        return {
          "status": true,
          "data": [
            {
              "title": "Exam Reminder",
              "body": "Math exam on Sunday",
              "sender": "School Admin",
              "created_at": "2025-11-12"
            }
          ]
        };

      // 🏫 Absences
      case 'absences':
        return {
          "status": true,
          "data": [
            {"created_at": "2025-10-10", "name": "Math", "date": "2025-10-10"},
            {"created_at": "2025-10-12", "name": "Science", "date": "2025-10-12"}
          ]
        };

      // 📝 Homeworks
      case 'homeworks':
        return {
          "status": true,
          "data": [
            {
              "subject": "Math",
              "teacher_name": "Mr. Ali",
              "body": "Solve exercises 1–10 on page 45.",
              "file": "",
              "created_at": "2025-11-10"
            },
            {
              "subject": "English",
              "teacher_name": "Ms. Sara",
              "body": "Write a short essay about your hobby.",
              "file": "",
              "created_at": "2025-11-11"
            }
          ]
        };

      // 👨‍🎓 Student Profile
      case 'profile/student':
        return {
          "status": true,
          "data": {
            "student_data": {
              "id": 1,
              "name": "Ahmed Salah",
              "birth_date": "2004-05-10",
              "gender": "male",
              "email": "aeng30358@gmail.com",
              "img": "https://via.placeholder.com/150",
              "address": "Cairo, Egypt",
              "phone_number": "01128177599",
              "left_for_qusat": 5,
              "is_in_bus": 1,
              "left_for_bus": 3,
              "grade": 12,
              "section_number": 3
            },
            "absence_rate": 10,
            "marks_rate": 90
          }
        };

      // 👨‍🏫 Teacher Profile
      case 'profile/teacher':
        return {
          "status": true,
          "data": {
            "teacherInfo": {
              "id": 10,
              "name": "Mr. Khaled Hassan",
              "img": "https://via.placeholder.com/150",
              "phone_number": "01012345678",
              "salary": 8000,
              "gender": "male",
              "email": "khaled@school.com"
            },
            "subjects": [
              {"id": 1, "name": "Mathematics", "grade": 12},
              {"id": 2, "name": "Physics", "grade": 11}
            ]
          }
        };

      // 📰 Articles
      case 'articles':
        return {
          "status": true,
          "data": {
            "lastPageNumber": 1,
            "data": [
              {
                "id": 1,
                "title": "New Science Discovery",
                "body": "Scientists have discovered a new element.",
                "name": "Dr. Hany",
                "is_img": true,
                "media": "https://via.placeholder.com/200",
                "role": "Teacher",
                "img": "https://via.placeholder.com/150",
                "created_at": "2025-11-09"
              }
            ]
          }
        };

      // 🧮 Marks
      case 'marks':
        return {
          "status": true,
          "data": {
            "percentage": 90,
            "marks": [
              {
                "sub_name": "Math",
                "exam_type": "Midterm",
                "mark": 45,
                "created_at": "2025-11-01"
              },
              {
                "sub_name": "Science",
                "exam_type": "Final",
                "mark": 48,
                "created_at": "2025-11-05"
              }
            ]
          }
          
        };
        

      default:
        return {"status": false, "message": "Mock GET endpoint not found"};
    }
  }
}
