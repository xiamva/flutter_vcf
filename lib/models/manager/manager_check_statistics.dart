import 'package:json_annotation/json_annotation.dart';

part 'manager_check_statistics.g.dart';

@JsonSerializable()
class ManagerCheckStatistics {
  final String? date;
  final ManagerCheckSummary? summary;
  final Map<String, ManagerCheckStageStat>? by_stage;
  final Map<String, ManagerCheckCommodityStat>? by_commodity;
  final ManagerCheckLabComparison? lab_comparison;

  ManagerCheckStatistics({
    this.date,
    this.summary,
    this.by_stage,
    this.by_commodity,
    this.lab_comparison,
  });

  factory ManagerCheckStatistics.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckStatisticsToJson(this);
}

@JsonSerializable()
class ManagerCheckSummary {
  final int? total_checks;
  final int? approved;
  final int? rejected;
  final double? approval_rate;
  final double? rejection_rate;

  ManagerCheckSummary({
    this.total_checks,
    this.approved,
    this.rejected,
    this.approval_rate,
    this.rejection_rate,
  });

  factory ManagerCheckSummary.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckSummaryToJson(this);
}

@JsonSerializable()
class ManagerCheckStageStat {
  final int? total;
  final int? approved;
  final int? rejected;
  final double? approval_rate;

  ManagerCheckStageStat({
    this.total,
    this.approved,
    this.rejected,
    this.approval_rate,
  });

  factory ManagerCheckStageStat.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckStageStatFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckStageStatToJson(this);
}

@JsonSerializable()
class ManagerCheckCommodityStat {
  final int? total;
  final int? approved;
  final int? rejected;
  final double? approval_rate;

  ManagerCheckCommodityStat({
    this.total,
    this.approved,
    this.rejected,
    this.approval_rate,
  });

  factory ManagerCheckCommodityStat.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckCommodityStatFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckCommodityStatToJson(this);
}

@JsonSerializable()
class ManagerCheckLabComparison {
  final int? total_lab_checks;
  final int? matches_operator;
  final int? discrepancies;
  final double? match_rate;
  final List<String>? common_discrepancy_fields;

  ManagerCheckLabComparison({
    this.total_lab_checks,
    this.matches_operator,
    this.discrepancies,
    this.match_rate,
    this.common_discrepancy_fields,
  });

  factory ManagerCheckLabComparison.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckLabComparisonFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckLabComparisonToJson(this);
}
