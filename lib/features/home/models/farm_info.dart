
class FarmInfo {
  final String id;
  final String cropType;
  final double landSize;
  final int cropAge;
  final String location;
  final String? situation;
  final String? notes;

  FarmInfo({
    required this.id,
    required this.cropType,
    required this.landSize,
    required this.cropAge,
    required this.location,
    this.situation,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'cropType': cropType,
        'landSize': landSize,
        'cropAge': cropAge,
        'location': location,
        'situation': situation,
        'notes': notes,
      };

  factory FarmInfo.fromJson(Map<String, dynamic> json) => FarmInfo(
        id: json['id'] as String,
        cropType: json['cropType'] as String,
        landSize: (json['landSize'] as num).toDouble(),
        cropAge: json['cropAge'] as int,
        location: json['location'] as String,
        situation: json['situation'] as String?,
        notes: json['notes'] as String?,
      );
}
