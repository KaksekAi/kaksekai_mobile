import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_analysis_bloc.dart';
import '../models/farm_info.dart';
import '../services/farm_service.dart';
import '../widgets/weather_analysis/weather_card.dart';
import '../widgets/weather_analysis/analysis_type_selector.dart';
import '../widgets/weather_analysis/analysis_card.dart';
import '../widgets/weather_analysis/farm_selector.dart';

class WeatherAnalysisScreen extends StatefulWidget {
  const WeatherAnalysisScreen({super.key});

  @override
  State<WeatherAnalysisScreen> createState() => _WeatherAnalysisScreenState();
}

class _WeatherAnalysisScreenState extends State<WeatherAnalysisScreen> {
  final FarmService _farmService = FarmService();
  List<FarmInfo> _farms = [];
  FarmInfo? _selectedFarm;
  bool _isMonthly = false;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<WeatherAnalysisBloc>()
        .add(LoadWeatherData(isMonthly: _isMonthly));
  }

  Future<void> _loadFarms() async {
    final farms = await _farmService.getFarmList();
    if (mounted) {
      setState(() {
        _farms = farms;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'វិភាគអាកាសធាតុ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'ត្រឡប់ក្រោយ',
        ),
        actions: [
          BlocBuilder<WeatherAnalysisBloc, WeatherAnalysisState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => context
                    .read<WeatherAnalysisBloc>()
                    .add(LoadWeatherData(isMonthly: _isMonthly)),
                tooltip: 'ធ្វើបច្ចុប្បន្នភាព',
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: BlocBuilder<WeatherAnalysisBloc, WeatherAnalysisState>(
          builder: (context, state) {
            if (state is WeatherAnalysisLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF2E7D32)),
                    SizedBox(height: 16),
                    Text('កំពុងទាញយកទិន្នន័យអាកាសធាតុ...'),
                  ],
                ),
              );
            }

            if (state is WeatherAnalysisError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<WeatherAnalysisBloc>()
                          .add(LoadWeatherData(isMonthly: _isMonthly)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('ព្យាយាមម្តងទៀត'),
                    ),
                  ],
                ),
              );
            }

            if (state is WeatherAnalysisComplete) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<WeatherAnalysisBloc>()
                      .add(LoadWeatherData(isMonthly: _isMonthly));
                },
                color: const Color(0xFF2E7D32),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnalysisTypeSelector(
                          isMonthly: _isMonthly,
                          onTypeChanged: (isMonthly) {
                            setState(() => _isMonthly = isMonthly);
                            context
                                .read<WeatherAnalysisBloc>()
                                .add(LoadWeatherData(isMonthly: isMonthly));
                          },
                        ),
                        const SizedBox(height: 24),
                        WeatherCard(weatherData: state),
                        const SizedBox(height: 24),
                        FarmSelector(
                          farms: _farms,
                          selectedFarm: _selectedFarm,
                          onFarmSelected: (FarmInfo? value) {
                            setState(() {
                              _selectedFarm = value;
                            });
                          },
                          isAnalyzing: false,
                          onAnalyze: () {
                            context.read<WeatherAnalysisBloc>().add(
                                  AnalyzeWeatherForFarm(
                                    _selectedFarm!,
                                    isMonthly: _isMonthly,
                                  ),
                                );
                          },
                          isMonthly: _isMonthly,
                        ),
                        if (state.analysis.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          AnalysisCard(analysis: state.analysis),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
