import 'package:json_annotation/json_annotation.dart';
import '../manager_check_statistics.dart';

part 'manager_check_statistics_response.g.dart';

@JsonSerializable()
class ManagerCheckStatisticsResponse {
  final bool? success;
  final String? message;
  final ManagerCheckStatistics? data;

  ManagerCheckStatisticsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ManagerCheckStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckStatisticsResponseFromJson(json);
}
