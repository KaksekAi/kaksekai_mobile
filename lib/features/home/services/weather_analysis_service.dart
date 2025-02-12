import '../models/farm_info.dart';
import '../models/weather_data.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class WeatherAnalysisService {
  GenerativeModel? _model;
  bool _isInitialized = false;

  WeatherAnalysisService() {
    _initializeModel();
  }

  void _initializeModel() {
    try {
      if (_model != null) {
        debugPrint('Model already initialized');
        _isInitialized = true;
        return;
      }

      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY is not set in .env file');
      }

      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
      _isInitialized = true;
      debugPrint('Gemini model initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Gemini model: $e');
      _isInitialized = false;
      _model = null;
    }
  }

  Future<String> analyzeWeatherForFarm(
    FarmInfo farm,
    WeatherDataLoaded weatherData,
  ) async {
    if (!_isInitialized || _model == null) {
      debugPrint('Attempting to reinitialize Gemini model...');
      _initializeModel();
      if (!_isInitialized || _model == null) {
        throw Exception('Gemini model is not initialized');
      }
    }

    String basicAnalysis;
    if (weatherData.isMonthly && weatherData.monthlyWeather != null) {
      basicAnalysis = _analyzeMonthlyWeather(farm, weatherData.monthlyWeather!);
    } else if (!weatherData.isMonthly && weatherData.currentWeather != null) {
      basicAnalysis = _analyzeCurrentWeather(farm, weatherData.currentWeather!);
    } else {
      return 'មិនមានទិន្នន័យអាកាសធាតុគ្រប់គ្រាន់សម្រាប់ការវិភាគ';
    }

    try {
      debugPrint('Getting AI recommendations...');
      final aiAnalysis =
          await _getAIRecommendations(farm, weatherData, basicAnalysis);
      debugPrint('AI recommendations received successfully');
      return '$basicAnalysis\n\n$aiAnalysis';
    } catch (e, stackTrace) {
      debugPrint('Error getting AI recommendations: $e');
      debugPrint('Stack trace: $stackTrace');
      return basicAnalysis;
    }
  }

  Future<String> _getAIRecommendations(
    FarmInfo farm,
    WeatherDataLoaded weatherData,
    String basicAnalysis,
  ) async {
    if (_model == null) {
      throw Exception('Gemini model is not initialized');
    }

    final prompt = '''
អ្នកជាជំនួយការអ្នកជំនាញកសិកម្មដែលមានបទពិសោធន៍ច្រើនឆ្នាំក្នុងការដាំដុះនៅកម្ពុជា។ សូមផ្តល់អនុសាសន៍លម្អិតដោយផ្អែកលើទិន្នន័យខាងក្រោម៖

ព័ត៌មានចម្ការ៖
- ប្រភេទដំណាំ៖ ${farm.cropType}
- ទំហំដី៖ ${farm.landSize} ហិកតា
- អាយុដំណាំ៖ ${farm.cropAge} ថ្ងៃ
- ទីតាំង៖ ${farm.location}
${farm.situation != null ? '- ស្ថានភាពបច្ចុប្បន្ន៖ ${farm.situation}' : ''}
${farm.notes != null ? '- កំណត់ចំណាំបន្ថែម៖ ${farm.notes}' : ''}

ទិន្នន័យអាកាសធាតុ៖
${weatherData.isMonthly ? _formatMonthlyWeatherForAI(weatherData.monthlyWeather!) : _formatCurrentWeatherForAI(weatherData.currentWeather!)}

ការវិភាគបឋម៖
$basicAnalysis

សូមផ្តល់អនុសាសន៍លម្អិតដោយប្រើទម្រង់ដូចខាងក្រោម៖

១. ការថែទាំដំណាំ៖
ក. ការស្រោចស្រព៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២
ខ. ការប្រើប្រាស់ជី៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២

២. ការគ្រប់គ្រងសមាសភាពចង្រៃ៖
ក. ការការពារជំងឺ៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២
ខ. ការគ្រប់គ្រងសត្វល្អិត៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២

៣. ការគ្រប់គ្រងដី៖
ក. ការរៀបចំដី៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២
ខ. ការថែរក្សាជីជាតិដី៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២

៤. ការត្រៀមបង្ការ៖
ក. ការការពារពីអាកាសធាតុ៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២
ខ. ការរៀបចំឧបករណ៍៖
- អនុសាសន៍ទី១
- អនុសាសន៍ទី២

សូមផ្តល់អនុសាសន៍ជាក់លាក់ និងអាចអនុវត្តបាន ដោយផ្អែកលើស្ថានភាពជាក់ស្តែង។
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      return response.text ?? 'មិនអាចទទួលបានអនុសាសន៍ពី AI';
    } catch (e) {
      debugPrint('Error generating AI content: $e');
      throw Exception('មិនអាចទទួលបានអនុសាសន៍ពី AI: $e');
    }
  }

  String _formatMonthlyWeatherForAI(MonthlyWeather weather) {
    return '''
អាកាសធាតុមធ្យមប្រចាំខែ៖
- សីតុណ្ហភាព៖ ${weather.averageTemperature.toStringAsFixed(1)}°C
- សំណើម៖ ${weather.averageHumidity.toStringAsFixed(1)}%
- ល្បឿនខ្យល់៖ ${weather.averageWindSpeed.toStringAsFixed(1)} m/s
''';
  }

  String _formatCurrentWeatherForAI(CurrentWeather weather) {
    return '''
អាកាសធាតុបច្ចុប្បន្ន៖
- សីតុណ្ហភាព៖ ${weather.temperature.toStringAsFixed(1)}°C
- សំណើម៖ ${weather.humidity}%
- ល្បឿនខ្យល់៖ ${weather.windSpeed.toStringAsFixed(1)} m/s
- ពពក៖ ${weather.cloudiness}%
- សម្ពាធខ្យល់៖ ${weather.pressure} hPa
- បរិយាយ៖ ${weather.description}
''';
  }

  String _analyzeMonthlyWeather(FarmInfo farm, MonthlyWeather weather) {
    final recommendations = <String>[];

    // Temperature analysis
    if (weather.averageTemperature < 20) {
      recommendations.add(
          'សីតុណ្ហភាពមធ្យមទាបពេក (${weather.averageTemperature.toStringAsFixed(1)}°C) សម្រាប់ការដាំដុះ ${farm.cropType}។ សូមពិចារណាប្រើវិធីការពារដំណាំពីអាកាសធាតុត្រជាក់។');
    } else if (weather.averageTemperature > 35) {
      recommendations.add(
          'សីតុណ្ហភាពមធ្យមខ្ពស់ពេក (${weather.averageTemperature.toStringAsFixed(1)}°C) សម្រាប់ការដាំដុះ ${farm.cropType}។ សូមពិចារណាប្រើវិធីការពារដំណាំពីកម្តៅ និងធ្វើម្លប់។');
    } else {
      recommendations.add(
          'សីតុណ្ហភាពមធ្យម (${weather.averageTemperature.toStringAsFixed(1)}°C) ល្អសមរម្យសម្រាប់ការដាំដុះ ${farm.cropType}។');
    }

    // Humidity analysis
    if (weather.averageHumidity < 40) {
      recommendations.add(
          'សំណើមមធ្យមទាបពេក (${weather.averageHumidity.toStringAsFixed(1)}%)។ សូមពិចារណាបង្កើនការស្រោចស្រព និងប្រើប្រព័ន្ធស្រោចស្រពតំណក់។');
    } else if (weather.averageHumidity > 80) {
      recommendations.add(
          'សំណើមមធ្យមខ្ពស់ពេក (${weather.averageHumidity.toStringAsFixed(1)}%)។ សូមប្រុងប្រយ័ត្នចំពោះជំងឺផ្សិត និងពិចារណាប្រើថ្នាំការពារផ្សិត។');
    } else {
      recommendations.add(
          'សំណើមមធ្យម (${weather.averageHumidity.toStringAsFixed(1)}%) ល្អសមរម្យសម្រាប់ការដាំដុះ។');
    }

    // Wind speed analysis
    if (weather.averageWindSpeed > 20) {
      recommendations.add(
          'ល្បឿនខ្យល់មធ្យមខ្ពស់ (${weather.averageWindSpeed.toStringAsFixed(1)} m/s)។ សូមពិចារណាប្រើរបាំងខ្យល់ ឬដាំដើមឈើការពារខ្យល់។');
    } else {
      recommendations.add(
          'ល្បឿនខ្យល់មធ្យម (${weather.averageWindSpeed.toStringAsFixed(1)} m/s) ល្អសមរម្យសម្រាប់ការដាំដុះ។');
    }

    return recommendations.join('\n\n');
  }

  String _analyzeCurrentWeather(FarmInfo farm, CurrentWeather weather) {
    final recommendations = <String>[];

    // Temperature analysis
    if (weather.temperature < 20) {
      recommendations.add(
          'សីតុណ្ហភាពទាបពេក (${weather.temperature.toStringAsFixed(1)}°C) សម្រាប់ការដាំដុះ ${farm.cropType}។ សូមពិចារណាប្រើវិធីការពារដំណាំពីអាកាសធាតុត្រជាក់។');
    } else if (weather.temperature > 35) {
      recommendations.add(
          'សីតុណ្ហភាពខ្ពស់ពេក (${weather.temperature.toStringAsFixed(1)}°C) សម្រាប់ការដាំដុះ ${farm.cropType}។ សូមពិចារណាប្រើវិធីការពារដំណាំពីកម្តៅ និងធ្វើម្លប់។');
    } else {
      recommendations.add(
          'សីតុណ្ហភាព (${weather.temperature.toStringAsFixed(1)}°C) ល្អសមរម្យសម្រាប់ការដាំដុះ ${farm.cropType}។');
    }

    // Humidity analysis
    if (weather.humidity < 40) {
      recommendations.add(
          'សំណើមទាបពេក (${weather.humidity}%)។ សូមពិចារណាបង្កើនការស្រោចស្រព និងប្រើប្រព័ន្ធស្រោចស្រពតំណក់។');
    } else if (weather.humidity > 80) {
      recommendations.add(
          'សំណើមខ្ពស់ពេក (${weather.humidity}%)។ សូមប្រុងប្រយ័ត្នចំពោះជំងឺផ្សិត និងពិចារណាប្រើថ្នាំការពារផ្សិត។');
    } else {
      recommendations
          .add('សំណើម (${weather.humidity}%) ល្អសមរម្យសម្រាប់ការដាំដុះ។');
    }

    // Wind speed analysis
    if (weather.windSpeed > 20) {
      recommendations.add(
          'ល្បឿនខ្យល់ខ្ពស់ (${weather.windSpeed.toStringAsFixed(1)} m/s)។ សូមពិចារណាប្រើរបាំងខ្យល់ ឬដាំដើមឈើការពារខ្យល់។');
    } else {
      recommendations.add(
          'ល្បឿនខ្យល់ (${weather.windSpeed.toStringAsFixed(1)} m/s) ល្អសមរម្យសម្រាប់ការដាំដុះ។');
    }

    // Cloud coverage analysis
    if (weather.cloudiness > 80) {
      recommendations.add(
          'មេឃមានពពកច្រើន (${weather.cloudiness}%)។ ដំណាំនឹងទទួលបានពន្លឺព្រះអាទិត្យតិច។');
    }

    // Pressure analysis
    if (weather.pressure < 1000) {
      recommendations.add(
          'សម្ពាធខ្យល់ទាប (${weather.pressure} hPa)។ អាចមានភ្លៀងធ្លាក់ក្នុងពេលឆាប់ៗនេះ។');
    }

    return recommendations.join('\n\n');
  }
}
