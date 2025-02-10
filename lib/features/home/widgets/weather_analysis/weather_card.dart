import 'package:flutter/material.dart';
import '../../bloc/weather_analysis_bloc.dart';

class WeatherCard extends StatelessWidget {
  final WeatherAnalysisComplete weatherData;

  const WeatherCard({
    super.key,
    required this.weatherData,
  });

  Widget _buildWeatherInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (weatherData.isMonthly && weatherData.monthlyWeather != null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "ការព្យាករណ៍អាកាសធាតុប្រចាំខែ ${weatherData.monthlyWeather!.month}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.thermostat,
                          color: Colors.white, size: 48),
                      const SizedBox(width: 8),
                      Text(
                        "${weatherData.monthlyWeather!.averageTemperature.toStringAsFixed(1)}°C",
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "សីតុណ្ហភាពមធ្យម",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (weatherData.address.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            weatherData.address,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherInfoTile(
                          Icons.water_drop,
                          'សំណើមមធ្យម',
                          '${weatherData.monthlyWeather!.averageHumidity.toStringAsFixed(1)}%',
                        ),
                      ),
                      Expanded(
                        child: _buildWeatherInfoTile(
                          Icons.air,
                          'ល្បឿនខ្យល់មធ្យម',
                          '${weatherData.monthlyWeather!.averageWindSpeed.toStringAsFixed(1)} m/s',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (!weatherData.isMonthly && weatherData.currentWeather != null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "អាកាសធាតុបច្ចុប្បន្ន",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.thermostat,
                          color: Colors.white, size: 48),
                      const SizedBox(width: 8),
                      Text(
                        "${weatherData.currentWeather!.temperature.toStringAsFixed(1)}°C",
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherData.currentWeather!.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (weatherData.address.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            weatherData.address,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherInfoTile(
                          Icons.water_drop,
                          'សំណើម',
                          '${weatherData.currentWeather!.humidity}%',
                        ),
                      ),
                      Expanded(
                        child: _buildWeatherInfoTile(
                          Icons.air,
                          'ល្បឿនខ្យល់',
                          '${weatherData.currentWeather!.windSpeed} m/s',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherInfoTile(
                          Icons.cloud,
                          'មេឃ',
                          '${weatherData.currentWeather!.cloudiness}%',
                        ),
                      ),
                      Expanded(
                        child: _buildWeatherInfoTile(
                          Icons.speed,
                          'សម្ពាធខ្យល់',
                          '${weatherData.currentWeather!.pressure} hPa',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
