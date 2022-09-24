import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/modal/weather.dart';

class WeatherAPI {
  WeatherAPI._();

  static final WeatherAPI weatherAPI = WeatherAPI._();

  Future<Weather?> fetchWeatherAPI({required String city}) async {
    const String baseURL = "https://api.openweathermap.org";
    final String endPoint = "/data/2.5/weather?q=$city,in&appid= YOUR API ID ";

    http.Response res = await http.get(Uri.parse(baseURL + endPoint));

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(res.body);

      Weather weather = Weather.fromJSON(json: decodedData);
      return weather;
    }
    return null;
  }
}
