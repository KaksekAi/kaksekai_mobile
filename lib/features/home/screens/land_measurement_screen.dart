import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/land_measurement_controller.dart';
import '../models/land_measurement.dart';
import '../widgets/land_measurement/start_measurement_card.dart';
import '../widgets/land_measurement/measurement_method_selector.dart';

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
    _disposeMap();
    WidgetsBinding.instance.removeObserver(this);
    _landController.dispose();
    super.dispose();
  }

  void _disposeMap() {
    if (_mapController != null) {
      _mapController!.dispose();
      _mapController = null;
    }
    _mapCreated = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (_mapController == null) {
          setState(() {
            _mapCreated = false;
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

  void _onMapCreated(GoogleMapController controller) {
    if (!mounted) {
      controller.dispose();
      return;
    }

    if (_mapCreated) {
      controller.dispose();
      return;
    }

    setState(() {
      _mapController = controller;
      _mapCreated = true;
    });

    _landController.requestLocationPermission().then((_) {
      if (!mounted || _mapController == null) return;

      _landController.getCurrentLocation().then((position) {
        if (!mounted || _mapController == null) return;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(position),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          _disposeMap();
        }
      },
      child: ChangeNotifierProvider.value(
        value: _landController,
        child: Consumer<LandMeasurementController>(
          builder: (context, controller, _) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: const Text(
                  'វាស់វែងដី',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
                backgroundColor: const Color(0xFF1B5E20).withOpacity(0.95),
                elevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      _disposeMap();
                      Navigator.pop(context);
                    },
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        controller.isSatelliteView
                            ? Icons.map
                            : Icons.satellite_alt,
                        color: Colors.white,
                      ),
                      onPressed: controller.toggleMapType,
                      tooltip: controller.isSatelliteView
                          ? 'បង្ហាញផែនទីធម្មតា'
                          : 'បង្ហាញរូបភាពផ្កាយរណប',
                    ),
                  ),
                  if (controller.points.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          controller.reset();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('បានជម្រះទិន្នន័យ'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF1B5E20),
                            ),
                          );
                        },
                        tooltip: 'ចាប់ផ្តើមម្តងទៀត',
                      ),
                    ),
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!controller.isLoading && controller.points.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: FloatingActionButton.small(
                        heroTag: 'undo',
                        backgroundColor: Colors.orange.shade800,
                        onPressed: () {
                          controller.undoLastPoint();
                          if (controller.points.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('បានលុបចំណុចទាំងអស់'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFF1B5E20),
                              ),
                            );
                          }
                        },
                        tooltip: 'ត្រឡប់ក្រោយ',
                        elevation: 4,
                        child: const Icon(Icons.undo, color: Colors.white),
                      ),
                    ),
                  if (!controller.isLoading)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: FloatingActionButton.extended(
                        heroTag: 'draw',
                        backgroundColor: const Color(0xFF1B5E20),
                        onPressed: () {
                          controller.toggleDrawing();
                          if (controller.isDrawing) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ចុចលើផែនទីដើម្បីកំណត់ចំណុច'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFF1B5E20),
                              ),
                            );
                          }
                        },
                        elevation: 4,
                        highlightElevation: 8,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            controller.isDrawing
                                ? Icons.check
                                : Icons.touch_app,
                            key: ValueKey(controller.isDrawing),
                            color: Colors.white,
                          ),
                        ),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            controller.isDrawing ? 'បញ្ចប់' : 'ចាប់ផ្តើម',
                            key: ValueKey(controller.isDrawing),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  if (!_mapCreated)
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              color: Color(0xFF1B5E20),
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'កំពុងផ្ទុកផែនទី...',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'សូមរង់ចាំមួយភ្លែត',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  GoogleMap(
                    initialCameraPosition: _initialPosition,
                    onMapCreated: _onMapCreated,
                    markers: controller.markers,
                    polylines: controller.polylines,
                    polygons: controller.polygons,
                    circles: controller.circles,
                    onTap: controller.isDrawing ? controller.addPoint : null,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: false,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    mapType: controller.isSatelliteView
                        ? MapType.satellite
                        : MapType.normal,
                  ),
                  if (!controller.isDrawing && controller.points.isEmpty)
                    Column(
                      children: [
                        const StartMeasurementCard(),
                        if (widget.initialMethod == null)
                          MeasurementMethodSelector(
                            currentMethod: controller.currentMethod,
                            onMethodChanged: controller.setMeasurementMethod,
                          ),
                      ],
                    ),
                  if (controller.points.isNotEmpty)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      bottom: 100,
                      left: 16,
                      right: 16,
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.green.shade50,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade100.withOpacity(0.5),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B5E20)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF1B5E20)
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.area_chart,
                                        color: Color(0xFF1B5E20),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'ផ្ទៃក្រឡា',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF1B5E20),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${controller.area?.toStringAsFixed(2) ?? '0'} ម៉ែត្រការ៉េ',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B5E20),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (controller.areaInHectares != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green.shade100,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.shade50,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.straighten,
                                                size: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${controller.areaInHectares!.toStringAsFixed(4)} ហិកតា',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.crop_square,
                                                size: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${controller.measurement?.areaInAcres?.toStringAsFixed(4) ?? '0'} Acres',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.green.shade200,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.shade50,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Color(0xFF1B5E20),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'ចំនួនចំណុច: ${controller.points.length}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B5E20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (controller.measurement
                                            ?.estimatedErrorPercentage !=
                                        null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.orange.shade200,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange.shade50,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              size: 16,
                                              color: Colors.orange.shade900,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '±${controller.measurement?.estimatedErrorPercentage?.toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.orange.shade900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
