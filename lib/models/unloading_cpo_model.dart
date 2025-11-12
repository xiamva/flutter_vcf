// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'unloading_cpo_model.g.dart';

@JsonSerializable()
class UnloadingCpoModel {
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
  final String? bruto_weight;
  final String? vendor_ffa;
  final String? vendor_moisture;
  final String? created_at;

 

  factory UnloadingCpoModel.fromJson(Map<String, dynamic> json) 
    => _$UnloadingCpoModelFromJson(json);

  UnloadingCpoModel({
    required this.registration_id, required this.wb_ticket_no, required this.plate_number, required this.driver_name, required this.vendor_code, required this.vendor_name, required this.commodity_code, required this.commodity_name, required this.transporter_name, required this.regist_status, required this.unloading_status, required this.bruto_weight, required this.vendor_ffa, required this.vendor_moisture, required this.created_at,});
  
  Map<String, dynamic> toJson() => _$UnloadingCpoModelToJson(this);
}
