class HttpResponse<T> {
  HttpResponse(
      {required this.success,
      required this.statusCode,
      required this.message,
      this.data});

  bool success;
  int statusCode;
  String message;
  T? data;
}
