import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/planting_date_controller.dart';
import '../widgets/planting_date/weather_info_card.dart';
import '../widgets/planting_date/location_info_card.dart';
import '../widgets/planting_date/sliding_analysis_card.dart';

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

  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  final Color _primaryColor = const Color(0xFF1B5E20);
  final Color _secondaryColor = const Color(0xFF2E7D32);
  final Color _backgroundColor = Colors.grey[50]!;

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
        return AlertDialog(
          title: Text(
            'ការណែនាំ',
            style: TextStyle(color: _primaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('1. បញ្ចូលព័ត៌មានដំណាំ និងដីរបស់អ្នក'),
                SizedBox(height: 8),
                Text('2. ថតរូប ឬជ្រើសរើសរូបភាពដីរបស់អ្នក'),
                SizedBox(height: 8),
                Text('3. ផ្ទៀងផ្ទាត់ទីតាំងរបស់អ្នក'),
                SizedBox(height: 8),
                Text('4. ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ'),
                SizedBox(height: 8),
                Text('5. ចុចប៊ូតុង "វិភាគលក្ខខណ្ឌដាំដុះ"'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'យល់ព្រម',
                style: TextStyle(color: _primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showInstructions,
            tooltip: 'ការណែនាំ',
          ),
        ],
      ),
      body: Consumer<PlantingDateController>(
        builder: (context, controller, child) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (controller.errorMessage != null)
                        Card(
                          color: Colors.red.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage!,
                                    style:
                                        TextStyle(color: Colors.red.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ព័ត៌មានដំណាំ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _plantController,
                                focusNode: _plantFocus,
                                decoration: _buildInputDecoration('ដំណាំ'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'សូមបញ្ចូលប្រភេទដំណាំ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _seedTypeController,
                                focusNode: _seedTypeFocus,
                                decoration: _buildInputDecoration('ប្រភេទពូជ'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'សូមបញ្ចូលប្រភេទពូជ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _landSizeController,
                                focusNode: _landSizeFocus,
                                keyboardType: TextInputType.number,
                                decoration:
                                    _buildInputDecoration('ទំហំដី (ហិកតា)'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'សូមបញ្ចូលទំហំដី';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'សូមបញ្ចូលលេខត្រឹមត្រូវ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _landTypeController,
                                focusNode: _landTypeFocus,
                                decoration: _buildInputDecoration('ប្រភេទដី'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'សូមបញ្ចូលប្រភេទដី';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
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
                      ElevatedButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _selectedDate == null
                              ? 'ជ្រើសរើសកាលបរិច្ឆេទ'
                              : 'កាលបរិច្ឆេទ: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: (_selectedDate != null &&
                                !controller.isAnalyzing &&
                                _formKey.currentState?.validate() == true)
                            ? () => controller.analyzePlantingConditions(
                                  cropType: _plantController.text,
                                  landSize:
                                      double.parse(_landSizeController.text),
                                  seedType: _seedTypeController.text,
                                  landType: _landTypeController.text,
                                  selectedDate: _selectedDate!,
                                )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _secondaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: controller.isAnalyzing
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'វិភាគលក្ខខណ្ឌដាំដុះ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      if (controller.analysisResult != null) ...[
                        const SizedBox(height: 24),
                        SlidingAnalysisCard(
                          result: controller.analysisResult!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: _primaryColor),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
