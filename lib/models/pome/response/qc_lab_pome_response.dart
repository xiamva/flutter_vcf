import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_vcf/models/pome/qc_lab_pome_vehicle.dart';


part 'qc_lab_pome_response.g.dart';

@JsonSerializable()
class QcLabPomeResponse {
  final bool success;
  final String? message;
  final int? total;
  final List<QcLabPomeVehicle>? data;

  QcLabPomeResponse({
    required this.success,
    this.message,
    this.total,
    this.data,
  });

  factory QcLabPomeResponse.fromJson(Map<String, dynamic> json) =>
      _$QcLabPomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPomeResponseToJson(this);
}
