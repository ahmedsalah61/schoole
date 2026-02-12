class ErrorModel {
  String? message;
  bool? status;

  ErrorModel({this.message, this.status});

  ErrorModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      message = json['message'];
      status = json['status'];
    } else {
      // Provide default values or handle the situation accordingly.
      message = "Unknown Error";
      status = false;
    }
  }
}
