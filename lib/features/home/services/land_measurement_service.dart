import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import '../models/land_measurement.dart';

class LandMeasurementService {
  static const double EARTH_RADIUS_METERS = 6371000;

  LandMeasurement calculateMeasurements(
    List<LatLng> points,
    MeasurementMethod method,
    LatLng? centerPoint,
    double radius,
  ) {
    if (method == MeasurementMethod.centerRadius) {
      if (centerPoint == null || radius <= 0) {
        return LandMeasurement(
          points: points,
          markers: _createMarkers(points, method, centerPoint),
          polygons: {},
          method: method,
        );
      }
      return _calculateCircularArea(centerPoint, radius, method);
    } else {
      if (points.length < 3) {
        return LandMeasurement(
          points: points,
          markers: _createMarkers(points, method, centerPoint),
          polygons: {},
          method: method,
        );
      }
      return _calculatePolygonArea(points, method);
    }
  }

  LandMeasurement _calculateCircularArea(
    LatLng center,
    double radius,
    MeasurementMethod method,
  ) {
    // Calculate circular area
    final areaInSquareMeters = math.pi * radius * radius;
    final areaInHectares = areaInSquareMeters / 10000;
    final areaInAcres = areaInSquareMeters / 4046.86;
    final areaInSquareKilometers = areaInSquareMeters / 1000000;
    final perimeterInMeters = 2 * math.pi * radius;
    final perimeterInKilometers = perimeterInMeters / 1000;

    // Estimate error based on GPS accuracy and radius
    final estimatedErrorPercentage = _estimateCircularErrorPercentage(radius);

    return LandMeasurement(
      points: [center],
      areaInSquareMeters: areaInSquareMeters,
      areaInHectares: areaInHectares,
      areaInAcres: areaInAcres,
      areaInSquareKilometers: areaInSquareKilometers,
      perimeterInMeters: perimeterInMeters,
      perimeterInKilometers: perimeterInKilometers,
      estimatedErrorPercentage: estimatedErrorPercentage,
      markers: _createMarkers([center], method, center),
      polygons: {},
      method: method,
    );
  }

  LandMeasurement _calculatePolygonArea(
    List<LatLng> points,
    MeasurementMethod method,
  ) {
    // Calculate area using Shoelace formula
    double area = 0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += points[i].latitude * points[j].longitude;
      area -= points[j].latitude * points[i].longitude;
    }
    final areaInSquareMeters = area.abs() * 111319.9 * 111319.9 / 2;

    // Calculate perimeter
    final perimeterInMeters = _calculatePerimeter(points);
    final perimeterInKilometers = perimeterInMeters / 1000;

    // Convert to other units
    final areaInHectares = areaInSquareMeters / 10000;
    final areaInAcres = areaInSquareMeters / 4046.86;
    final areaInSquareKilometers = areaInSquareMeters / 1000000;

    // Estimate error percentage based on method and shape
    final estimatedErrorPercentage = method == MeasurementMethod.walkAround
        ? _estimateWalkAroundErrorPercentage(points.length, areaInSquareMeters)
        : _estimatePolygonErrorPercentage(points.length, areaInSquareMeters);

    return LandMeasurement(
      points: points,
      areaInSquareMeters: areaInSquareMeters,
      areaInHectares: areaInHectares,
      areaInAcres: areaInAcres,
      areaInSquareKilometers: areaInSquareKilometers,
      perimeterInMeters: perimeterInMeters,
      perimeterInKilometers: perimeterInKilometers,
      estimatedErrorPercentage: estimatedErrorPercentage,
      markers: _createMarkers(points, method, null),
      polygons: _createPolygon(points),
      method: method,
    );
  }

  Set<Marker> _createMarkers(
    List<LatLng> points,
    MeasurementMethod method,
    LatLng? centerPoint,
  ) {
    final Set<Marker> markers = {};

    // Add regular points
    markers.addAll(points.asMap().entries.map(
      (entry) {
        final index = entry.key;
        final point = entry.value;
        return Marker(
          markerId: MarkerId('point_$index'),
          position: point,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          draggable: true,
          infoWindow: InfoWindow(title: 'ចំណុចទី ${index + 1}'),
        );
      },
    ));

    // Add center point for radius method
    if (method == MeasurementMethod.centerRadius && centerPoint != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('center_point'),
          position: centerPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          draggable: true,
          infoWindow: const InfoWindow(title: 'ចំណុចកណ្តាល'),
        ),
      );
    }

    return markers;
  }

  Set<Polygon> _createPolygon(List<LatLng> points) {
    return {
      Polygon(
        polygonId: const PolygonId('land'),
        points: points,
        fillColor: const Color(0xFF1B5E20).withOpacity(0.3),
        strokeColor: const Color(0xFF1B5E20),
        strokeWidth: 2,
      ),
    };
  }

  double _calculatePerimeter(List<LatLng> points) {
    double perimeter = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      perimeter += _calculateDistance(p1, p2);
    }
    return perimeter;
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double radius = EARTH_RADIUS_METERS;
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

  double _estimatePolygonErrorPercentage(
    int numberOfPoints,
    double areaInSquareMeters,
  ) {
    // Base error percentage starts at 5% for very simple shapes
    double baseError = 5.0;

    // Add error based on complexity (or lack thereof)
    if (numberOfPoints < 4) {
      baseError += 3.0; // Higher error for very simple shapes
    } else if (numberOfPoints > 10) {
      baseError -= 2.0; // Lower error for more complex shapes
    }

    // Add error based on area size (larger areas tend to have more error)
    if (areaInSquareMeters > 1000000) {
      // 1 square kilometer
      baseError += 2.0;
    } else if (areaInSquareMeters < 100) {
      // Very small areas
      baseError += 1.0;
    }

    return math.min(baseError, 15.0); // Cap at 15%
  }

  double _estimateWalkAroundErrorPercentage(
    int numberOfPoints,
    double areaInSquareMeters,
  ) {
    // Walking around tends to have higher base error
    double baseError = 8.0;

    // More points generally means more accurate measurement
    if (numberOfPoints > 20) {
      baseError -= 2.0;
    } else if (numberOfPoints < 10) {
      baseError += 2.0;
    }

    // Area size affects accuracy
    if (areaInSquareMeters > 1000000) {
      baseError += 3.0;
    } else if (areaInSquareMeters < 100) {
      baseError += 2.0;
    }

    return math.min(baseError, 20.0); // Cap at 20%
  }

  double _estimateCircularErrorPercentage(double radius) {
    // Base error for circular measurement
    double baseError = 6.0;

    // Larger radius means more potential error
    if (radius > 1000) {
      baseError += 3.0;
    } else if (radius > 500) {
      baseError += 2.0;
    } else if (radius < 10) {
      baseError += 2.0; // Very small circles are also prone to error
    }

    return math.min(baseError, 15.0); // Cap at 15%
  }
}
