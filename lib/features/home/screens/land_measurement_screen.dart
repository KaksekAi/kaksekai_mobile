import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LandMeasurementScreen extends StatefulWidget {
  const LandMeasurementScreen({super.key});

  @override
  State<LandMeasurementScreen> createState() => _LandMeasurementScreenState();
}

class _LandMeasurementScreenState extends State<LandMeasurementScreen>
    with WidgetsBindingObserver {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  double? _area;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<LatLng> _points = [];
  bool _isDrawing = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(11.5564, 104.9282), // Phnom Penh coordinates
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestLocationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _mapController = null;
    _lengthController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _mapController != null) {
      setState(() {});
    }
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {}
  }

  void _onMapTap(LatLng position) {
    if (!_isDrawing) return;

    setState(() {
      _points.add(position);
      _markers = _points
          .map(
            (point) => Marker(
              markerId: MarkerId(point.toString()),
              position: point,
            ),
          )
          .toSet();

      if (_points.length >= 3) {
        _polygons = {
          Polygon(
            polygonId: const PolygonId('land'),
            points: _points,
            fillColor: Colors.green.withOpacity(0.3),
            strokeColor: Colors.green,
            strokeWidth: 2,
          ),
        };
      }
    });
    _calculatePolygonArea();
  }

  void _calculatePolygonArea() {
    if (_points.length < 3) return;

    double area = 0;
    for (int i = 0; i < _points.length; i++) {
      int j = (i + 1) % _points.length;
      area += _points[i].latitude * _points[j].longitude;
      area -= _points[j].latitude * _points[i].longitude;
    }
    area = area.abs() * 111319.9 * 111319.9 / 2;

    setState(() {
      _area = area;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                if (_mapController == null) {
                  setState(() {
                    _mapController = controller;
                  });
                }
              },
              markers: _markers,
              polygons: _polygons,
              onTap: _onMapTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
