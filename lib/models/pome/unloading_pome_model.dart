import 'package:json_annotation/json_annotation.dart';

part 'unloading_pome_model.g.dart';

@JsonSerializable()
class UnloadingPomeModel {
  final String? registration_id;
  final String? wb_ticket_no;
  final String? plate_number;
  final String? driver_name;
  final String? vendor_code;
  final String? vendor_name;
  final String? commodity_code;
  final String? commodity_name;
  final String? transporter_name;
  final String? regist_status;
  final String? unloading_status;
  final String? created_at;
  final String? bruto_weight;
  final String? vendor_ffa;
  final String? vendor_moisture;

  UnloadingPomeModel({
    this.registration_id,
    this.wb_ticket_no,
    this.plate_number,
    this.driver_name,
    this.vendor_code,
    this.vendor_name,
    this.commodity_code,
    this.commodity_name,
    this.transporter_name,
    this.regist_status,
    this.unloading_status,
    this.created_at,
    this.bruto_weight,
    this.vendor_ffa,
    this.vendor_moisture,
  });

  factory UnloadingPomeModel.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPomeModelToJson(this);
}
