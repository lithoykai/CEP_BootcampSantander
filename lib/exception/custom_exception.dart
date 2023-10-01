class CustomException implements Exception {
  final String msg;
  int? statusCode;

  CustomException({required this.msg, this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
