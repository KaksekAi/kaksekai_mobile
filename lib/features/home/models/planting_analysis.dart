import 'dart:convert';
import 'package:flutter/material.dart';

class PlantingAnalysis {
  final String id;
  final String cropType;
  final String seedType;
  final double landSize;
  final String landType;
  final DateTime analysisDate;
  final DateTimeRange plantingDateRange;
  final String location;
  final String result;

  PlantingAnalysis({
    required this.id,
    required this.cropType,
    required this.seedType,
    required this.landSize,
    required this.landType,
    required this.analysisDate,
    required this.plantingDateRange,
    required this.location,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropType': cropType,
      'seedType': seedType,
      'landSize': landSize,
      'landType': landType,
      'analysisDate': analysisDate.toIso8601String(),
      'plantingDateStart': plantingDateRange.start.toIso8601String(),
      'plantingDateEnd': plantingDateRange.end.toIso8601String(),
      'location': location,
      'result': result,
    };
  }

  factory PlantingAnalysis.fromJson(Map<String, dynamic> json) {
    return PlantingAnalysis(
      id: json['id'],
      cropType: json['cropType'],
      seedType: json['seedType'],
      landSize: json['landSize'].toDouble(),
      landType: json['landType'],
      analysisDate: DateTime.parse(json['analysisDate']),
      plantingDateRange: DateTimeRange(
        start: DateTime.parse(json['plantingDateStart']),
        end: DateTime.parse(json['plantingDateEnd']),
      ),
      location: json['location'],
      result: json['result'],
    );
  }
}
