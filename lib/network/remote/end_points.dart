
class EndPoints {
  // ================= Base =================
  static const String baseUrl = 'http://192.168.1.24:3000/api/';
  // For Android Emulator use 10.0.2.2
  // For real device use your PC IP

  // ================= Auth =================
  static const String login = "/auth/login";
  static const String LOGOUT = 'auth/logout';



  // ================= Materials =================
  static const String materials = "/materials";

  static String updateMaterial(String id) => "/materials/$id";
  static String deleteMaterial(String id) => "/materials/$id";

  // ================= Assignments =================
  static const String assignments = "/assignments";

  static String submitAssignment(String id) =>
      "/assignments/$id/submit";

  static String assignmentSubmissions(String id) =>
      "/assignments/$id/submissions";

  // ================= Exams =================
  static const String exams = "/exams";

  static String startExam(String id) =>
      "/exams/$id/start";

  static String answerExam(String attemptId) =>
      "/exams/attempts/$attemptId/answer";

  static String endExam(String attemptId) =>
      "/exams/attempts/$attemptId/end";

  // ================= Reports =================
  static const String reports = "/reports";

  static const String myReports = "/reports/me";
  static const String teacherReports = "/reports/teacher";

  static String childReport(String studentId) =>
      "/reports/child/$studentId";

  // ================= Timetable =================
  static const String timetable = "/timetable";

  static String timetableByClass(String className) =>
      "/timetable/$className";

  // ================= Messages =================
  static const String messages = "/messages";

  static String messagesWithUser(String userId) =>
      "/messages/$userId";

  static const String HOME = 'home';

}