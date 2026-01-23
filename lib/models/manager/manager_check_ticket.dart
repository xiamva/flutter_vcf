import 'package:json_annotation/json_annotation.dart';

part 'manager_check_ticket.g.dart';

@JsonSerializable()
class ManagerCheckTicket {
  final String? process_id;
  final String? registration_id;
  final String? wb_ticket_no;
  final String? plate_number;
  final String? driver_name;
  final String? vendor_name;
  final String? commodity_type;
  final String? current_stage;
  final String? created_at;
  final bool? has_manager_check;
  final int? manager_checks_count;
  final String? latest_check_status;

  ManagerCheckTicket({
    this.process_id,
    this.registration_id,
    this.wb_ticket_no,
    this.plate_number,
    this.driver_name,
    this.vendor_name,
    this.commodity_type,
    this.current_stage,
    this.created_at,
    this.has_manager_check,
    this.manager_checks_count,
    this.latest_check_status,
  });

  factory ManagerCheckTicket.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckTicketFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckTicketToJson(this);
}
