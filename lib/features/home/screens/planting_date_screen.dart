import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/planting_date_controller.dart';
import '../widgets/planting_date/weather_info_card.dart';
import '../widgets/planting_date/location_info_card.dart';
import '../widgets/planting_date/crop_info_form.dart';
import '../widgets/planting_date/planting_instructions_dialog.dart';
import '../widgets/planting_date/analyze_button.dart';
import 'planting_analysis_result_screen.dart';
import 'planting_analysis_history_screen.dart';

class PlantingDateScreenProvider extends StatelessWidget {
  const PlantingDateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantingDateController(),
      child: const PlantingDateScreen(),
    );
  }
}

class PlantingDateScreen extends StatefulWidget {
  const PlantingDateScreen({super.key});

  @override
  State<PlantingDateScreen> createState() => _PlantingDateScreenState();
}

class _PlantingDateScreenState extends State<PlantingDateScreen> {
  final TextEditingController _plantController = TextEditingController();
  final TextEditingController _seedTypeController = TextEditingController();
  final TextEditingController _landSizeController = TextEditingController();
  final TextEditingController _landTypeController = TextEditingController();

  // Add focus nodes
  final FocusNode _plantFocus = FocusNode();
  final FocusNode _seedTypeFocus = FocusNode();
  final FocusNode _landSizeFocus = FocusNode();
  final FocusNode _landTypeFocus = FocusNode();

  DateTimeRange? _selectedDateRange;
  final _formKey = GlobalKey<FormState>();

  final Color _primaryColor = const Color(0xFF1B5E20);
  final Color _secondaryColor = const Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlantingDateController>(context, listen: false)
          .getCurrentLocation();
      _showInstructions();
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    _plantController.dispose();
    _seedTypeController.dispose();
    _landSizeController.dispose();
    _landTypeController.dispose();

    // Dispose focus nodes
    _plantFocus.dispose();
    _seedTypeFocus.dispose();
    _landSizeFocus.dispose();
    _landTypeFocus.dispose();

    super.dispose();
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlantingInstructionsDialog(primaryColor: _primaryColor);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor,
                _secondaryColor,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantingAnalysisHistoryScreen(),
                ),
              );
            },
            tooltip: 'ប្រវត្តិវិភាគ',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showInstructions,
            tooltip: 'ការណែនាំ',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Consumer<PlantingDateController>(
          builder: (context, controller, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (controller.errorMessage != null)
                        _buildErrorCard(controller.errorMessage!),
                      const SizedBox(height: 16),
                      CropInfoForm(
                        plantController: _plantController,
                        seedTypeController: _seedTypeController,
                        landSizeController: _landSizeController,
                        landTypeController: _landTypeController,
                        plantFocus: _plantFocus,
                        seedTypeFocus: _seedTypeFocus,
                        landSizeFocus: _landSizeFocus,
                        landTypeFocus: _landTypeFocus,
                        primaryColor: _primaryColor,
                        selectedDateRange: _selectedDateRange,
                        onDateRangeSelected: (dateRange) {
                          setState(() {
                            _selectedDateRange = dateRange;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      LocationInfoCard(
                        currentAddress: controller.currentAddress,
                        primaryColor: _primaryColor,
                        onRefreshLocation: controller.getCurrentLocation,
                      ),
                      const SizedBox(height: 24),
                      if (controller.currentWeather != null)
                        WeatherInfoCard(
                          weather: controller.currentWeather!,
                          primaryColor: _primaryColor,
                        ),
                      const SizedBox(height: 24),
                      AnalyzeButton(
                        isEnabled: _selectedDateRange != null &&
                            !controller.isAnalyzing &&
                            _formKey.currentState?.validate() == true,
                        isAnalyzing: controller.isAnalyzing,
                        onPressed: () async {
                          await controller.analyzePlantingConditions(
                            cropType: _plantController.text,
                            landSize: double.parse(_landSizeController.text),
                            seedType: _seedTypeController.text,
                            landType: _landTypeController.text,
                            selectedDate: _selectedDateRange!.start,
                            endDate: _selectedDateRange!.end,
                          );

                          if (controller.analysisResult != null && mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlantingAnalysisResultScreen(
                                  analysisResult: controller.analysisResult!,
                                ),
                              ),
                            );
                          }
                        },
                        primaryColor: _primaryColor,
                        secondaryColor: _secondaryColor,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Card(
      elevation: 0,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
