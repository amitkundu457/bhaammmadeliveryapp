class WalletModel {
  int? deliveryManId;
  int? totalWallet;

  WalletModel({this.deliveryManId, this.totalWallet});

  WalletModel.fromJson(Map<String, dynamic> json) {
    deliveryManId = json['delivery_man_id'];
    totalWallet = json['total_wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_man_id'] = this.deliveryManId;
    data['total_wallet'] = this.totalWallet;
    return data;
  }
}
