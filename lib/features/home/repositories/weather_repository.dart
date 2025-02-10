import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherRepository {
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5";

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
    } catch (e) {
      return '';
    }
  }

  Future<WeatherDataLoaded> getWeatherData(bool isMonthly) async {
    try {
      final position = await getCurrentLocation();
      final address = await getAddressFromCoordinates(position);
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

      if (isMonthly) {
        final url = Uri.parse(
          "$_baseUrl/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric",
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // Calculate averages from the 5-day forecast
          double sumTemp = 0;
          double sumHumidity = 0;
          double sumWindSpeed = 0;
          final List<dynamic> list = data['list'];

          for (var item in list) {
            sumTemp += item['main']['temp'].toDouble();
            sumHumidity += item['main']['humidity'].toDouble();
            sumWindSpeed += item['wind']['speed'].toDouble();
          }

          final monthlyWeather = MonthlyWeather(
            month: _getMonthName(DateTime.now().month),
            averageTemperature: sumTemp / list.length,
            averageHumidity: sumHumidity / list.length,
            averageWindSpeed: sumWindSpeed / list.length,
          );

          return WeatherDataLoaded(
            isMonthly: true,
            monthlyWeather: monthlyWeather,
            address: address,
          );
        } else {
          throw Exception(
              'Failed to load monthly weather data: ${response.statusCode}');
        }
      } else {
        final url = Uri.parse(
          "$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric",
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          final currentWeather = CurrentWeather(
            temperature: data['main']['temp'].toDouble(),
            humidity: data['main']['humidity'],
            windSpeed: data['wind']['speed'].toDouble(),
            cloudiness: data['clouds']['all'],
            pressure: data['main']['pressure'],
            description: data['weather'][0]['description'],
          );

          return WeatherDataLoaded(
            isMonthly: false,
            currentWeather: currentWeather,
            address: address,
          );
        } else {
          throw Exception(
              'Failed to load current weather data: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Failed to load weather data: ${e.toString()}');
    }
  }

  String _getMonthName(int month) {
    const months = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ'
    ];
    return months[month - 1];
  }
}
