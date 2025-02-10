import 'package:flutter/material.dart';
import '../../models/weather_data.dart';

class WeatherInfoCard extends StatelessWidget {
  final CurrentWeather weather;
  final Color primaryColor;

  const WeatherInfoCard({
    super.key,
    required this.weather,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ព័ត៌មានអាកាសធាតុ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.thermostat, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'សីតុណ្ហភាព: ${weather.temperature.toStringAsFixed(1)}°C',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.water_drop, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'សំណើម: ${weather.humidity}%',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.air, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'ល្បឿនខ្យល់: ${weather.windSpeed.toStringAsFixed(1)} km/h',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.cloud, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'ពពក: ${weather.cloudiness}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
