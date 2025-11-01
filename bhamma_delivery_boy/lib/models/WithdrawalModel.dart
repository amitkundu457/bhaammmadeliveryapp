class WithdrawalModel {
  final int id;
  final int deliveryManId;
  final String amount;
  final String status;
  final DateTime createdAt;

  WithdrawalModel({
    required this.id,
    required this.deliveryManId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'],
      deliveryManId: json['delivery_man_id'],
      amount: json['amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
