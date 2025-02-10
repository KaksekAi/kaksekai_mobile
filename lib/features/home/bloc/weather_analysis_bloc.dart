import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/farm_info.dart';
import '../models/weather_data.dart';
import '../repositories/weather_repository.dart';
import '../services/weather_analysis_service.dart';

// Events
abstract class WeatherAnalysisEvent extends Equatable {
  const WeatherAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeatherData extends WeatherAnalysisEvent {
  final bool isMonthly;

  const LoadWeatherData({required this.isMonthly});

  @override
  List<Object> get props => [isMonthly];
}

class AnalyzeWeatherForFarm extends WeatherAnalysisEvent {
  final FarmInfo farm;
  final bool isMonthly;

  const AnalyzeWeatherForFarm(this.farm, {required this.isMonthly});

  @override
  List<Object> get props => [farm, isMonthly];
}

// States
abstract class WeatherAnalysisState extends Equatable {
  const WeatherAnalysisState();

  @override
  List<Object?> get props => [];
}

class WeatherAnalysisLoading extends WeatherAnalysisState {}

class WeatherAnalysisError extends WeatherAnalysisState {
  final String message;

  const WeatherAnalysisError(this.message);

  @override
  List<Object> get props => [message];
}

class WeatherAnalysisComplete extends WeatherAnalysisState {
  final bool isMonthly;
  final CurrentWeather? currentWeather;
  final MonthlyWeather? monthlyWeather;
  final String address;
  final String analysis;

  const WeatherAnalysisComplete({
    required this.isMonthly,
    this.currentWeather,
    this.monthlyWeather,
    this.address = '',
    required this.analysis,
  });

  @override
  List<Object?> get props =>
      [isMonthly, currentWeather, monthlyWeather, address, analysis];
}

class WeatherAnalysisBloc
    extends Bloc<WeatherAnalysisEvent, WeatherAnalysisState> {
  final WeatherRepository weatherRepository;
  final WeatherAnalysisService analysisService;

  WeatherAnalysisBloc({
    required this.weatherRepository,
    required this.analysisService,
  }) : super(WeatherAnalysisLoading()) {
    on<LoadWeatherData>(_onLoadWeatherData);
    on<AnalyzeWeatherForFarm>(_onAnalyzeWeatherForFarm);
  }

  Future<void> _onLoadWeatherData(
    LoadWeatherData event,
    Emitter<WeatherAnalysisState> emit,
  ) async {
    try {
      emit(WeatherAnalysisLoading());
      final weatherData =
          await weatherRepository.getWeatherData(event.isMonthly);
      emit(WeatherAnalysisComplete(
        isMonthly: weatherData.isMonthly,
        currentWeather: weatherData.currentWeather,
        monthlyWeather: weatherData.monthlyWeather,
        address: weatherData.address,
        analysis: '',
      ));
    } catch (e) {
      emit(WeatherAnalysisError(e.toString()));
    }
  }

  Future<void> _onAnalyzeWeatherForFarm(
    AnalyzeWeatherForFarm event,
    Emitter<WeatherAnalysisState> emit,
  ) async {
    try {
      emit(WeatherAnalysisLoading());
      final weatherData =
          await weatherRepository.getWeatherData(event.isMonthly);
      final analysis = await analysisService.analyzeWeatherForFarm(
        event.farm,
        weatherData,
      );
      emit(WeatherAnalysisComplete(
        isMonthly: weatherData.isMonthly,
        currentWeather: weatherData.currentWeather,
        monthlyWeather: weatherData.monthlyWeather,
        address: weatherData.address,
        analysis: analysis,
      ));
    } catch (e) {
      emit(WeatherAnalysisError(e.toString()));
    }
  }
}
