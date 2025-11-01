class FeedbackModel {
  int? id;
  int? deliveryBoyId;
  String? customerId;
  String? comment;
  int? rating;
  String? createdAt;
  String? updatedAt;
  DeliveryBoy? deliveryBoy;
  DeliveryBoy? customer;

  FeedbackModel(
      {this.id,
      this.deliveryBoyId,
      this.customerId,
      this.comment,
      this.rating,
      this.createdAt,
      this.updatedAt,
      this.deliveryBoy,
      this.customer});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryBoyId = json['delivery_boy_id'];
    customerId = json['customer_id'];
    comment = json['comment'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryBoy = json['delivery_boy'] != null
        ? new DeliveryBoy.fromJson(json['delivery_boy'])
        : null;
    customer = json['customer'] != null
        ? new DeliveryBoy.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['customer_id'] = this.customerId;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.deliveryBoy != null) {
      data['delivery_boy'] = this.deliveryBoy!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class DeliveryBoy {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  int? status;
  String? createdAt;
  String? updatedAt;

  DeliveryBoy(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.status,
      this.createdAt,
      this.updatedAt});

  DeliveryBoy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
