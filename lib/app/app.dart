import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/get_started_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/farm_management_screen.dart';
import '../features/home/screens/planting_date_screen.dart';
import '../features/home/screens/weather_analysis_screen.dart';
import '../features/home/screens/land_measurement_instruction_screen.dart';
import '../features/home/screens/ai_assistant_screen.dart';
import '../features/home/screens/about_me_screen.dart';
import '../features/home/bloc/weather_analysis_bloc.dart';
import '../features/home/repositories/weather_repository.dart';
import '../features/home/services/weather_analysis_service.dart';
import '../features/home/controllers/planting_date_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PlantingDateController(),
        ),
      ],
      child: MaterialApp(
        title: 'Kaksekai',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const GetStartedScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/farm-management': (context) => const FarmManagementScreen(),
          '/planting-date': (context) => const PlantingDateScreenProvider(),
          '/weather-analysis': (context) => BlocProvider(
                create: (context) => WeatherAnalysisBloc(
                  weatherRepository: WeatherRepository(),
                  analysisService: WeatherAnalysisService(),
                ),
                child: const WeatherAnalysisScreen(),
              ),
          '/land-measurement': (context) =>
              const LandMeasurementInstructionScreen(),
          '/ai-assistant': (context) => const AIAssistantScreen(),
          '/about-developer': (context) => const AboutMeScreen(),
        },
      ),
    );
  }
}
