import 'package:equatable/equatable.dart';
import '../bloc/weather_analysis_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherDataLoaded extends WeatherAnalysisState {
  final bool isMonthly;
  final CurrentWeather? currentWeather;
  final MonthlyWeather? monthlyWeather;
  final String address;

  const WeatherDataLoaded({
    required this.isMonthly,
    this.currentWeather,
    this.monthlyWeather,
    this.address = '',
  });

  @override
  List<Object?> get props =>
      [isMonthly, currentWeather, monthlyWeather, address];
}

class CurrentWeather extends Equatable {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int cloudiness;
  final int pressure;
  final String description;

  const CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
    required this.pressure,
    required this.description,
  });

  @override
  List<Object> get props => [
        temperature,
        humidity,
        windSpeed,
        cloudiness,
        pressure,
        description,
      ];

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temp_c']?.toDouble() ?? 0.0,
      humidity: json['humidity'] ?? 0,
      windSpeed: json['wind_kph']?.toDouble() ?? 0.0,
      cloudiness: json['cloud'] ?? 0,
      pressure: json['pressure_mb']?.toInt() ?? 0,
      description: json['condition']['text'] ?? '',
    );
  }
}

class MonthlyWeather extends Equatable {
  final String month;
  final double averageTemperature;
  final double averageHumidity;
  final double averageWindSpeed;

  const MonthlyWeather({
    required this.month,
    required this.averageTemperature,
    required this.averageHumidity,
    required this.averageWindSpeed,
  });

  @override
  List<Object> get props => [
        month,
        averageTemperature,
        averageHumidity,
        averageWindSpeed,
      ];

  factory MonthlyWeather.fromJson(Map<String, dynamic> json) {
    return MonthlyWeather(
      month: json['month'] ?? '',
      averageTemperature: json['avgtemp_c']?.toDouble() ?? 0.0,
      averageHumidity: json['avghumidity']?.toDouble() ?? 0.0,
      averageWindSpeed: json['avgwind_kph']?.toDouble() ?? 0.0,
    );
  }
}

class WeatherData {
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int cloudiness;
  final int windDegree;
  final DateTime date;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.cloudiness,
    required this.windDegree,
    required this.date,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      cloudiness: json['clouds']['all'],
      windDegree: json['wind']['deg'],
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'cloudiness': cloudiness,
      'windDegree': windDegree,
      'date': date.millisecondsSinceEpoch ~/ 1000,
    };
  }
}

class MonthlyWeatherData {
  final List<WeatherData> dailyForecasts;
  final double averageTemperature;
  final double averageHumidity;
  final double averageWindSpeed;
  final String month;

  MonthlyWeatherData({
    required this.dailyForecasts,
    required this.averageTemperature,
    required this.averageHumidity,
    required this.averageWindSpeed,
    required this.month,
  });

  factory MonthlyWeatherData.fromDailyForecasts(List<WeatherData> forecasts) {
    final avgTemp =
        forecasts.map((e) => e.temperature).reduce((a, b) => a + b) /
            forecasts.length;
    final avgHumidity =
        forecasts.map((e) => e.humidity).reduce((a, b) => a + b) /
            forecasts.length;
    final avgWindSpeed =
        forecasts.map((e) => e.windSpeed).reduce((a, b) => a + b) /
            forecasts.length;

    return MonthlyWeatherData(
      dailyForecasts: forecasts,
      averageTemperature: avgTemp,
      averageHumidity: avgHumidity,
      averageWindSpeed: avgWindSpeed,
      month: _getMonthName(forecasts.first.date.month),
    );
  }

  static String _getMonthName(int month) {
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
