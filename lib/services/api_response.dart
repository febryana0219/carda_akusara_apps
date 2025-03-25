class ApiResponse<T> {
  int? statusCode;
  String? message;
  dynamic totalScore;
  T? data;

  ApiResponse({this.statusCode, this.message, this.totalScore, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      apiResponseFromJsonData(json);

  Map<String, dynamic> toJson() => apiResponseToJson(this);
}

ApiResponse<T> apiResponseFromJsonData<T>(Map<String, dynamic> json) {
  return ApiResponse<T>(
    statusCode: json['statusCode'],
    message: json['message'],
    totalScore: json['totalScore'],
    data: json['data'],
  );
}

Map<String, dynamic> apiResponseToJson(ApiResponse response) => {
      "statusCode": response.statusCode,
      "message": response.message,
      "totalScore": response.totalScore,
      "data": response.data,
    };
