import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import '../models/farm_info.dart';
import '../models/weather_data.dart';
import '../models/planting_analysis.dart';
import '../services/weather_analysis_service.dart';
import '../services/farm_service.dart';
import '../services/planting_analysis_storage_service.dart';
import '../../../utils/khmer_date_formatter.dart';

class PlantingDateController extends ChangeNotifier {
  final WeatherAnalysisService _weatherAnalysisService =
      WeatherAnalysisService();
  final FarmService _farmService = FarmService();
  final PlantingAnalysisStorageService _analysisStorage =
      PlantingAnalysisStorageService();
  final ImagePicker _picker = ImagePicker();

  Position? _currentPosition;
  String? _currentAddress;
  CurrentWeather? _currentWeather;
  File? _landImage;
  String? _analysisResult;
  bool _isAnalyzing = false;
  String? _errorMessage;

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  CurrentWeather? get currentWeather => _currentWeather;
  File? get landImage => _landImage;
  String? get analysisResult => _analysisResult;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;
      notifyListeners();

      await getAddressFromLatLng();
      await getWeatherData();
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = 'មិនអាចរកទីតាំងបានទេ';
      notifyListeners();
    }
  }

  Future<void> getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = 'មិនអាចរកអាសយដ្ឋានបានទេ';
      notifyListeners();
    }
  }

  Future<void> getWeatherData() async {
    if (_currentPosition == null) return;

    final apiKey = dotenv.env['WEATHER_API_KEY'];
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${_currentPosition!.latitude},${_currentPosition!.longitude}&days=7';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentWeather = CurrentWeather(
          temperature: data['current']['temp_c'].toDouble(),
          humidity: data['current']['humidity'],
          windSpeed: data['current']['wind_kph'].toDouble(),
          cloudiness: data['current']['cloud'],
          pressure: data['current']['pressure_mb'],
          description: data['current']['condition']['text'],
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = 'មិនអាចទាញយកទិន្នន័យអាកាសធាតុបានទេ';
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      _landImage = File(photo.path);
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _landImage = File(image.path);
      notifyListeners();
    }
  }

  Future<void> analyzePlantingConditions({
    required String cropType,
    required double landSize,
    required String seedType,
    required String landType,
    required DateTime selectedDate,
    required DateTime endDate,
  }) async {
    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final farmInfo = FarmInfo(
        id: const Uuid().v4(),
        cropType: cropType,
        landSize: landSize,
        cropAge: 0,
        location: _currentAddress ?? 'Unknown',
        situation: landType,
        notes:
            'ប្រភេទពូជ: $seedType\nកាលបរិច្ឆេទដាំដុះ: ${KhmerDateFormatter.formatDateRange(selectedDate, endDate)}',
      );

      final weatherData = WeatherDataLoaded(
        isMonthly: false,
        currentWeather: _currentWeather ??
            CurrentWeather(
              temperature: 0,
              humidity: 0,
              windSpeed: 0,
              cloudiness: 0,
              pressure: 0,
              description: '',
            ),
        address: _currentAddress ?? '',
      );

      final analysis = await _weatherAnalysisService.analyzeWeatherForFarm(
        farmInfo,
        weatherData,
      );

      await _farmService.addFarm(farmInfo);

      // Create and save the analysis
      final plantingAnalysis = PlantingAnalysis(
        id: const Uuid().v4(),
        cropType: cropType,
        seedType: seedType,
        landSize: landSize,
        landType: landType,
        analysisDate: DateTime.now(),
        plantingDateRange: DateTimeRange(start: selectedDate, end: endDate),
        location: _currentAddress ?? 'Unknown',
        result: analysis,
      );

      await _analysisStorage.saveAnalysis(plantingAnalysis);

      _analysisResult = analysis;
      _isAnalyzing = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error during analysis: $e');
      _analysisResult = null;
      _errorMessage = 'មិនអាចវិភាគបានទេ: ${e.toString()}';
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
