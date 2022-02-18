import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getweather() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String city = preferences.getString("city") ?? "ferozepur";
  String url =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=04911a8b07235b28179ace524ff01f14";
  var respons = await http.get(Uri.parse(url));
  return jsonDecode(respons.body);
}
