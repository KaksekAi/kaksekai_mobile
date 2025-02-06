import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';

class WeatherAnalysisScreen extends StatefulWidget {
  const WeatherAnalysisScreen({super.key});

  @override
  State<WeatherAnalysisScreen> createState() => _WeatherAnalysisScreenState();
}

class _WeatherAnalysisScreenState extends State<WeatherAnalysisScreen> {
  String _weatherDescription = "កំពុងទាញយកទិន្នន័យអាកាសធាតុ...";
  double? _temperature;
  Position? _currentPosition;
  String _address = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _weatherDescription = "មិនអាចទាញយកទិន្នន័យអាកាសធាតុបានទេ";
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _address = '${place.street}, ${place.subLocality}, '
                '${place.locality}, ${place.administrativeArea}';
          });
        }
      } catch (e) {
        setState(() {
          _address = "មិនអាចរកទីតាំងបានទេ";
        });
      }

      _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _weatherDescription = "មានបញ្ហាក្នុងការទាញយកទិន្នន័យអាកាសធាតុ";
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    const String apiKey = "8d7371509f205f7a4f5d8479c38cd0b8";
    final Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherDescription = data["weather"][0]["description"];
          _temperature = data["main"]["temp"];
        });
      } else {
        setState(() {
          _weatherDescription = "មិនអាចទាញយកទិន្នន័យអាកាសធាតុបានទេ";
        });
      }
    } catch (e) {
      setState(() {
        _weatherDescription = "មានបញ្ហាក្នុងការទាញយកទិន្នន័យអាកាសធាតុ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud,
                  size: 100,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 24),
                Text(
                  "អាកាសធាតុបច្ចុប្បន្ន",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                if (_address.isNotEmpty) ...[
                  Text(
                    _address,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  _weatherDescription,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_temperature != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    "${_temperature!.toStringAsFixed(1)}°C",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
