// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheckStatistics _$ManagerCheckStatisticsFromJson(
  Map<String, dynamic> json,
) => ManagerCheckStatistics(
  date: json['date'] as String?,
  summary: json['summary'] == null
      ? null
      : ManagerCheckSummary.fromJson(json['summary'] as Map<String, dynamic>),
  by_stage: (json['by_stage'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, ManagerCheckStageStat.fromJson(e as Map<String, dynamic>)),
  ),
  by_commodity: (json['by_commodity'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      ManagerCheckCommodityStat.fromJson(e as Map<String, dynamic>),
    ),
  ),
  lab_comparison: json['lab_comparison'] == null
      ? null
      : ManagerCheckLabComparison.fromJson(
          json['lab_comparison'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ManagerCheckStatisticsToJson(
  ManagerCheckStatistics instance,
) => <String, dynamic>{
  'date': instance.date,
  'summary': instance.summary,
  'by_stage': instance.by_stage,
  'by_commodity': instance.by_commodity,
  'lab_comparison': instance.lab_comparison,
};

ManagerCheckSummary _$ManagerCheckSummaryFromJson(Map<String, dynamic> json) =>
    ManagerCheckSummary(
      total_checks: (json['total_checks'] as num?)?.toInt(),
      approved: (json['approved'] as num?)?.toInt(),
      rejected: (json['rejected'] as num?)?.toInt(),
      approval_rate: (json['approval_rate'] as num?)?.toDouble(),
      rejection_rate: (json['rejection_rate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ManagerCheckSummaryToJson(
  ManagerCheckSummary instance,
) => <String, dynamic>{
  'total_checks': instance.total_checks,
  'approved': instance.approved,
  'rejected': instance.rejected,
  'approval_rate': instance.approval_rate,
  'rejection_rate': instance.rejection_rate,
};

ManagerCheckStageStat _$ManagerCheckStageStatFromJson(
  Map<String, dynamic> json,
) => ManagerCheckStageStat(
  total: (json['total'] as num?)?.toInt(),
  approved: (json['approved'] as num?)?.toInt(),
  rejected: (json['rejected'] as num?)?.toInt(),
  approval_rate: (json['approval_rate'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ManagerCheckStageStatToJson(
  ManagerCheckStageStat instance,
) => <String, dynamic>{
  'total': instance.total,
  'approved': instance.approved,
  'rejected': instance.rejected,
  'approval_rate': instance.approval_rate,
};

ManagerCheckCommodityStat _$ManagerCheckCommodityStatFromJson(
  Map<String, dynamic> json,
) => ManagerCheckCommodityStat(
  total: (json['total'] as num?)?.toInt(),
  approved: (json['approved'] as num?)?.toInt(),
  rejected: (json['rejected'] as num?)?.toInt(),
  approval_rate: (json['approval_rate'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ManagerCheckCommodityStatToJson(
  ManagerCheckCommodityStat instance,
) => <String, dynamic>{
  'total': instance.total,
  'approved': instance.approved,
  'rejected': instance.rejected,
  'approval_rate': instance.approval_rate,
};

ManagerCheckLabComparison _$ManagerCheckLabComparisonFromJson(
  Map<String, dynamic> json,
) => ManagerCheckLabComparison(
  total_lab_checks: (json['total_lab_checks'] as num?)?.toInt(),
  matches_operator: (json['matches_operator'] as num?)?.toInt(),
  discrepancies: (json['discrepancies'] as num?)?.toInt(),
  match_rate: (json['match_rate'] as num?)?.toDouble(),
  common_discrepancy_fields:
      (json['common_discrepancy_fields'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$ManagerCheckLabComparisonToJson(
  ManagerCheckLabComparison instance,
) => <String, dynamic>{
  'total_lab_checks': instance.total_lab_checks,
  'matches_operator': instance.matches_operator,
  'discrepancies': instance.discrepancies,
  'match_rate': instance.match_rate,
  'common_discrepancy_fields': instance.common_discrepancy_fields,
};
