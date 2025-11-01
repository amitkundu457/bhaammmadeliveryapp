class HelpAndSupport {
  bool? status;
  String? message;
  Data? data;

  HelpAndSupport({this.status, this.message, this.data});

  HelpAndSupport.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? email;
  String? number;

  Data({this.email, this.number});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['number'] = this.number;
    return data;
  }
}
