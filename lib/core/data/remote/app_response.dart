class AppResponse {
  dynamic data;
  String? message;
  late bool success;
  int? statusCode;

  AppResponse({
    this.data,
    this.message,
    this.success = false,
    this.statusCode,
  });

  AppResponse.fromJson(Map<String, dynamic> json, int? statusCode) {
    data = json['data'];
    message = (json['message'] ?? json['msg']).toString();
    success = json['success'] != null
        ? json['success'].toString() == 'true'
        : json['key'].toString() == 'success';
    statusCode = statusCode;
  }
}
