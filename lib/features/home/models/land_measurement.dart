import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MeasurementMethod {
  pointByPoint,  // Default method - tap points to create polygon
  walkAround,    // Walk around the perimeter
  centerRadius,  // Measure from center point with radius
}

class LandMeasurement {
  final List<LatLng> points;
  final double? areaInSquareMeters;
  final double? areaInHectares;
  final double? areaInAcres;
  final double? areaInSquareKilometers;
  final double? perimeterInMeters;
  final double? perimeterInKilometers;
  final double? estimatedErrorPercentage;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final MeasurementMethod method;

  LandMeasurement({
    required this.points,
    this.areaInSquareMeters,
    this.areaInHectares,
    this.areaInAcres,
    this.areaInSquareKilometers,
    this.perimeterInMeters,
    this.perimeterInKilometers,
    this.estimatedErrorPercentage,
    required this.markers,
    required this.polygons,
    this.method = MeasurementMethod.pointByPoint,
  });

  factory LandMeasurement.empty() {
    return LandMeasurement(
      points: [],
      markers: {},
      polygons: {},
    );
  }

  LandMeasurement copyWith({
    List<LatLng>? points,
    double? areaInSquareMeters,
    double? areaInHectares,
    double? areaInAcres,
    double? areaInSquareKilometers,
    double? perimeterInMeters,
    double? perimeterInKilometers,
    double? estimatedErrorPercentage,
    Set<Marker>? markers,
    Set<Polygon>? polygons,
    MeasurementMethod? method,
  }) {
    return LandMeasurement(
      points: points ?? this.points,
      areaInSquareMeters: areaInSquareMeters ?? this.areaInSquareMeters,
      areaInHectares: areaInHectares ?? this.areaInHectares,
      areaInAcres: areaInAcres ?? this.areaInAcres,
      areaInSquareKilometers:
          areaInSquareKilometers ?? this.areaInSquareKilometers,
      perimeterInMeters: perimeterInMeters ?? this.perimeterInMeters,
      perimeterInKilometers:
          perimeterInKilometers ?? this.perimeterInKilometers,
      estimatedErrorPercentage:
          estimatedErrorPercentage ?? this.estimatedErrorPercentage,
      markers: markers ?? this.markers,
      polygons: polygons ?? this.polygons,
      method: method ?? this.method,
    );
  }
}
