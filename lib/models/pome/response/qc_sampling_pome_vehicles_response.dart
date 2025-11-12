import 'package:json_annotation/json_annotation.dart';
import '../qc_sampling_pome_vehicle.dart';

part 'qc_sampling_pome_vehicles_response.g.dart';

@JsonSerializable()
class QcSamplingPomeVehiclesResponse {
  bool? success;
  String? message;
  List<QcSamplingPomeVehicle>? data;
  int? total;

  QcSamplingPomeVehiclesResponse({
    this.success,
    this.message,
    this.data,
    this.total,
  });

  factory QcSamplingPomeVehiclesResponse.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPomeVehiclesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPomeVehiclesResponseToJson(this);
}
