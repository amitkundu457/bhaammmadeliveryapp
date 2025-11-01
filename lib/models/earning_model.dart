class EarningModel {
  final int totalBaseEarning;
  final int totalOnTimeBonus;
  final int totalHighVolumeBonus;
  final int totalOtherBonus;
  final int totalIncentive;
  final int totalBonus;
  final int totalAmount;

  EarningModel({
    required this.totalBaseEarning,
    required this.totalOnTimeBonus,
    required this.totalHighVolumeBonus,
    required this.totalOtherBonus,
    required this.totalIncentive,
    required this.totalBonus,
    required this.totalAmount,
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return EarningModel(
      totalBaseEarning: data['total_base_earning'] ?? 0,
      totalOnTimeBonus: data['total_on_time_bonus'] ?? 0,
      totalHighVolumeBonus: data['total_high_volume_bonus'] ?? 0,
      totalOtherBonus: data['total_other_bonus'] ?? 0,
      totalIncentive: data['total_incentive'] ?? 0,
      totalBonus: data['total_bonus'] ?? 0,
      totalAmount: data['total_amount'] ?? 0,
    );
  }
}
