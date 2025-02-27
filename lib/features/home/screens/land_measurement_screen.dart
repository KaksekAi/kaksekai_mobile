import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/land_measurement_controller.dart';
import '../models/land_measurement.dart';
import '../widgets/land_measurement/walking_measurement_overlay.dart';
import '../widgets/land_measurement/area_results_card.dart';
import '../widgets/land_measurement/land_measurement_app_bar.dart';

class LandMeasurementScreen extends StatefulWidget {
  final MeasurementMethod? initialMethod;

  const LandMeasurementScreen({
    super.key,
    this.initialMethod,
  });

  @override
  State<LandMeasurementScreen> createState() => _LandMeasurementScreenState();
}

class _LandMeasurementScreenState extends State<LandMeasurementScreen>
    with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  bool _mapCreated = false;
  late final LandMeasurementController _landController;
  bool _disposed = false;
  bool _isMapDisposed = false;
  int _mapKey = 0;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(11.5564, 104.9282), // Phnom Penh coordinates
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _landController = LandMeasurementController();
    if (widget.initialMethod != null) {
      _landController.setMeasurementMethod(widget.initialMethod!);
    }
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _disposeMap();
    WidgetsBinding.instance.removeObserver(this);
    _landController.dispose();
    super.dispose();
  }

  Future<void> _disposeMap() async {
    if (!_isMapDisposed && _mapController != null) {
      _isMapDisposed = true;
      final controller = _mapController;
      _mapController = null;
      _mapCreated = false;

      if (controller != null) {
        controller.dispose();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (_isMapDisposed) {
          setState(() {
            _isMapDisposed = false;
            _mapCreated = false;
            _mapKey++;
          });
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _disposeMap();
        break;
      default:
        break;
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    if (_disposed || _mapCreated || !mounted) {
      controller.dispose();
      return;
    }

    _mapController = controller;
    _isMapDisposed = false;

    setState(() {
      _mapCreated = true;
    });

    try {
      await _landController.requestLocationPermission();
      if (_disposed || _mapController == null || !mounted) return;

      final position = await _landController.getCurrentLocation();
      if (_disposed || _mapController == null || !mounted) return;

      await _mapController?.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    } catch (error) {
      debugPrint('Error initializing map: $error');
      if (!_disposed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                const Text('មិនអាចរកទីតាំងបច្ចុប្បន្នបានទេ'),
              ],
            ),
            backgroundColor: const Color(0xFF1B5E20),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16 + MediaQuery.of(context).padding.bottom,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          await _disposeMap();
        }
      },
      child: ChangeNotifierProvider.value(
        value: _landController,
        child: Consumer<LandMeasurementController>(
          builder: (context, controller, _) {
            final bottomPadding = MediaQuery.of(context).padding.bottom;

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: LandMeasurementAppBar(
                controller: controller,
                onBackPressed: () async {
                  await _disposeMap();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  if (!_isMapDisposed)
                    GoogleMap(
                      key: ValueKey(_mapKey),
                      initialCameraPosition: _initialPosition,
                      onMapCreated: _onMapCreated,
                      markers: controller.markers,
                      polylines: controller.polylines,
                      polygons: controller.polygons,
                      circles: controller.circles,
                      onTap: controller.isDrawing ? controller.addPoint : null,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: true,
                      zoomControlsEnabled: false,
                      mapType: controller.isSatelliteView
                          ? MapType.satellite
                          : MapType.normal,
                    ),
                  if (!_mapCreated)
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF1B5E20),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'កំពុងផ្ទុកផែនទី...',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (controller.currentMethod == MeasurementMethod.walkAround)
                    _buildWalkingUI(controller, bottomPadding),
                  Positioned(
                    right: 16,
                    bottom: (controller.points.isEmpty ||
                                !controller.isResultsVisible
                            ? 100
                            : 240) +
                        bottomPadding,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.my_location,
                            color: Color(0xFF1B5E20)),
                        onPressed: () {
                          _landController.getCurrentLocation().then((position) {
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(position, 18),
                            );
                          });
                        },
                        tooltip: 'ទៅកាន់ទីតាំងបច្ចុប្បន្ន',
                      ),
                    ),
                  ),
                  // Toggle button for results
                  if (controller.points.isNotEmpty)
                    Positioned(
                      right: 16,
                      bottom: controller.isResultsVisible
                          ? 240 + bottomPadding
                          : 16 + bottomPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: controller.toggleResultsVisibility,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    controller.isResultsVisible
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                    color: const Color(0xFF1B5E20),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.isResultsVisible
                                        ? 'លាក់លទ្ធផល'
                                        : 'បង្ហាញលទ្ធផល',
                                    style: const TextStyle(
                                      color: Color(0xFF1B5E20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Results card
                  if (controller.points.isNotEmpty &&
                      controller.isResultsVisible)
                    Positioned(
                      bottom: 100 + bottomPadding,
                      left: 16,
                      right: 16,
                      child: AreaResultsCard(controller: controller),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWalkingUI(
      LandMeasurementController controller, double bottomPadding) {
    if (controller.isDrawing) {
      return WalkingMeasurementOverlay(controller: controller);
    }

    return Stack(
      children: [
        // Center start button
        if (controller.points.isEmpty)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_walk,
                          size: 48,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'ដើរវាស់វែងដី',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ដើរជុំវិញព្រំដីដើម្បីកំណត់ផ្ទៃក្រឡា',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.toggleDrawing(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 8),
                              Text(
                                'ចាប់ផ្តើម',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // Toggle button for results
        if (controller.points.isNotEmpty)
          Positioned(
            right: 16,
            bottom: controller.isResultsVisible
                ? 240 + bottomPadding
                : 16 + bottomPadding,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: controller.toggleResultsVisibility,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          controller.isResultsVisible
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: const Color(0xFF1B5E20),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isResultsVisible
                              ? 'លាក់លទ្ធផល'
                              : 'បង្ហាញលទ្ធផល',
                          style: const TextStyle(
                            color: Color(0xFF1B5E20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Results card
        if (controller.points.isNotEmpty && controller.isResultsVisible)
          Positioned(
            bottom: 100 + bottomPadding,
            left: 16,
            right: 16,
            child: AreaResultsCard(controller: controller),
          ),
      ],
    );
  }
}
