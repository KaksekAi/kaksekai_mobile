import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/land_measurement.dart';
import '../widgets/land_measurement/measurement_method_selector.dart';
import 'land_measurement_screen.dart';

class LandMeasurementInstructionScreen extends StatefulWidget {
  final bool fromBottomNav;

  const LandMeasurementInstructionScreen({
    super.key,
    this.fromBottomNav = false,
  });

  @override
  State<LandMeasurementInstructionScreen> createState() =>
      _LandMeasurementInstructionScreenState();
}

class _LandMeasurementInstructionScreenState
    extends State<LandMeasurementInstructionScreen> {
  MeasurementMethod _selectedMethod = MeasurementMethod.pointByPoint;
  bool _isNavigating = false;

  void _onMethodChanged(MeasurementMethod method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  Future<void> _navigateToMeasurement() async {
    if (_isNavigating) return;

    setState(() => _isNavigating = true);

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandMeasurementScreen(
            initialMethod: _selectedMethod,
          ),
        ),
      );

      if (mounted && widget.fromBottomNav) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isNavigating,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'របៀបវាស់វែងដី',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: const Color(0xFF1B5E20),
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _isNavigating ? null : () => Navigator.pop(context),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'សូមជ្រើសរើសវិធីសាស្ត្រវាស់វែងដែលសមស្របសម្រាប់ដីរបស់អ្នក',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'អ្នកអាចប្តូរវិធីសាស្ត្រវាស់វែងនៅពេលណាក៏បាន',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: MeasurementMethodSelector(
                  currentMethod: _selectedMethod,
                  onMethodChanged: _onMethodChanged,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade200,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange.shade800,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'ចំណាំ៖',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ការវាស់វែងដីតាមរយៈកម្មវិធីនេះគឺជាការប៉ាន់ស្មានប៉ុណ្ណោះ។ សម្រាប់ការវាស់វែងផ្លូវការ សូមទាក់ទងអាជ្ញាធរមានសមត្ថកិច្ច។',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isNavigating ? null : _navigateToMeasurement,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isNavigating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.map, color: Colors.white),
                      label: Text(
                        _isNavigating ? 'កំពុងផ្ទុក...' : 'បន្តទៅកាន់ផែនទី',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
