import 'package:json_annotation/json_annotation.dart';
import '../qc_lab_cpo_vehicle.dart';

part 'qc_lab_cpo_vehicles_response.g.dart';

@JsonSerializable()
class QcLabCpoVehiclesResponse {
  final bool success;
  final String message;
  final List<QcLabCpoVehicle>? data;

  QcLabCpoVehiclesResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcLabCpoVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$QcLabCpoVehiclesResponseFromJson(json);
}
