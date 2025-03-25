class ApiHeader {
  static Map<String, String> getHeader(
      {String? accessToken, String? refreshToken}) {
    Map<String, String> header = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (accessToken != null) {
      header['Authorization'] = 'Bearer $accessToken';
    }

    if (refreshToken != null) {
      header['Refresh-Token'] = refreshToken;
    }

    return header;
  }
}
