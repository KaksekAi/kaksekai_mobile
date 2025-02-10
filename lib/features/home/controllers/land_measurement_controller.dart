import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'dart:async';
import '../models/land_measurement.dart';
import '../services/land_measurement_service.dart';

class LandMeasurementController extends ChangeNotifier {
  final List<LatLng> _points = [];
  LandMeasurement? _measurement;
  bool _isLoading = false;
  bool _isDrawing = false;
  bool _isSatelliteView = false;
  MeasurementMethod _currentMethod = MeasurementMethod.pointByPoint;
  LatLng? _centerPoint;
  double _radius = 0.0;
  Timer? _locationTimer;
  Position? _lastPosition;

  // Getters
  List<LatLng> get points => _points;
  LandMeasurement? get measurement => _measurement;
  bool get isLoading => _isLoading;
  bool get isDrawing => _isDrawing;
  bool get isSatelliteView => _isSatelliteView;
  MeasurementMethod get currentMethod => _currentMethod;
  LatLng? get centerPoint => _centerPoint;
  double get radius => _radius;

  Set<Marker> get markers {
    final Set<Marker> allMarkers = {};

    // Add points markers
    allMarkers.addAll(_points.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      return Marker(
        markerId: MarkerId('point_$index'),
        position: point,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'ចំណុចទី ${index + 1}'),
      );
    }));

    // Add center point marker for radius method
    if (_currentMethod == MeasurementMethod.centerRadius &&
        _centerPoint != null) {
      allMarkers.add(
        Marker(
          markerId: const MarkerId('center_point'),
          position: _centerPoint!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'ចំណុចកណ្តាល'),
        ),
      );
    }

    return allMarkers;
  }

  Set<Circle> get circles {
    if (_currentMethod == MeasurementMethod.centerRadius &&
        _centerPoint != null &&
        _radius > 0) {
      return {
        Circle(
          circleId: const CircleId('measurement_circle'),
          center: _centerPoint!,
          radius: _radius,
          fillColor: const Color(0xFF1B5E20).withOpacity(0.2),
          strokeColor: const Color(0xFF1B5E20),
          strokeWidth: 2,
        ),
      };
    }
    return {};
  }

  Set<Polyline> get polylines {
    if (_points.length < 2) return {};

    return {
      Polyline(
        polylineId: const PolylineId('measurement_line'),
        points: [..._points, if (_points.length > 2) _points.first],
        color: const Color(0xFF1B5E20),
        width: 3,
      ),
    };
  }

  Set<Polygon> get polygons {
    if (_points.length < 3 || _currentMethod == MeasurementMethod.centerRadius)
      return {};

    return {
      Polygon(
        polygonId: const PolygonId('measurement_area'),
        points: _points,
        strokeWidth: 2,
        strokeColor: const Color(0xFF1B5E20),
        fillColor: const Color(0xFF1B5E20).withOpacity(0.2),
      ),
    };
  }

  void setMeasurementMethod(MeasurementMethod method) {
    if (_currentMethod != method) {
      _currentMethod = method;
      reset();
      notifyListeners();
    }
  }

  void toggleDrawing() {
    _isDrawing = !_isDrawing;
    if (!_isDrawing) {
      _updateMeasurements();
      _stopLocationTracking();
    } else if (_currentMethod == MeasurementMethod.walkAround) {
      _startLocationTracking();
    }
    notifyListeners();
  }

  void toggleMapType() {
    _isSatelliteView = !_isSatelliteView;
    notifyListeners();
  }

  void addPoint(LatLng point) {
    if (!_isDrawing) return;

    switch (_currentMethod) {
      case MeasurementMethod.pointByPoint:
        _points.add(point);
        if (_points.length >= 3) {
          _updateMeasurements();
        }
        break;
      case MeasurementMethod.centerRadius:
        if (_centerPoint == null) {
          _centerPoint = point;
        } else {
          _radius = _calculateDistance(_centerPoint!, point);
          _updateMeasurements();
        }
        break;
      case MeasurementMethod.walkAround:
        // Points are added automatically through location tracking
        break;
    }
    notifyListeners();
  }

  void _startLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final position = await Geolocator.getCurrentPosition();
        final point = LatLng(position.latitude, position.longitude);

        if (_lastPosition != null) {
          final distance = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );

          // Only add point if moved more than 5 meters
          if (distance > 5) {
            _points.add(point);
            _lastPosition = position;
            _updateMeasurements();
            notifyListeners();
          }
        } else {
          _lastPosition = position;
          _points.add(point);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error tracking location: $e');
      }
    });
  }

  void _stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
    _lastPosition = null;
  }

  void undoLastPoint() {
    if (_points.isNotEmpty) {
      _points.removeLast();
      _updateMeasurements();
      notifyListeners();
    }
  }

  void reset() {
    _points.clear();
    _measurement = null;
    _isDrawing = false;
    _centerPoint = null;
    _radius = 0;
    _stopLocationTracking();
    notifyListeners();
  }

  void _updateMeasurements() {
    switch (_currentMethod) {
      case MeasurementMethod.pointByPoint:
      case MeasurementMethod.walkAround:
        if (_points.length < 3) {
          _measurement = null;
          return;
        }
        break;
      case MeasurementMethod.centerRadius:
        if (_centerPoint == null || _radius <= 0) {
          _measurement = null;
          return;
        }
        break;
    }

    final service = LandMeasurementService();
    _measurement = service.calculateMeasurements(
        _points, _currentMethod, _centerPoint, _radius);
  }

  double? get area => _measurement?.areaInSquareMeters;
  double? get areaInHectares => _measurement?.areaInHectares;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<LatLng> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double radius = 6371000; // Earth's radius in meters
    final lat1 = p1.latitude * math.pi / 180;
    final lat2 = p2.latitude * math.pi / 180;
    final dLat = (p2.latitude - p1.latitude) * math.pi / 180;
    final dLon = (p2.longitude - p1.longitude) * math.pi / 180;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return radius * c;
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }
}
