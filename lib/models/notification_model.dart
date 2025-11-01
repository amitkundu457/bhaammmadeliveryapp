class NotificationModel {
  List<All>? all;
  List<All>? unread;

  NotificationModel({this.all, this.unread});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all!.add(new All.fromJson(v));
      });
    }
    if (json['unread'] != null) {
      unread = <All>[];
      json['unread'].forEach((v) {
        unread!.add(new All.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.all != null) {
      data['all'] = this.all!.map((v) => v.toJson()).toList();
    }
    if (this.unread != null) {
      data['unread'] = this.unread!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class All {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  Data? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  All(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt});

  All.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'] ?? "";
    notifiableType = json['notifiable_type'] ?? "";
    notifiableId = json['notifiable_id'] ?? 0;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    readAt = json['read_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiable_type'] = this.notifiableType;
    data['notifiable_id'] = this.notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Data {
  String? message;
  int? orderId;

  Data({this.message, this.orderId});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    orderId = json['order_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['order_id'] = this.orderId;
    return data;
  }
}
