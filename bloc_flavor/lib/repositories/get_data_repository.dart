import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetDataRepository {
  final http.Client httpClient;

  GetDataRepository({@required this.httpClient}) : assert(httpClient != null);

  Future<String> getData(String dataUrl, String token) async {
    final http.Response response = await httpClient.get(
      dataUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      final String message = responseBody['message'];

      return message;
    }

    print(
        'Request failed : statuscode :${response.statusCode}\nreason:${responseBody['errMessage']}');
    throw 'Request failed : statuscode :${response.statusCode}\nreason:${responseBody['errMessage']}';
  }
}
