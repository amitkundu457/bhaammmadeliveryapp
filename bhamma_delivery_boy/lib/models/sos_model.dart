class SosModel {
  int? id;
  String? title;
  String? number;
  String? createdAt;
  String? updatedAt;

  SosModel({this.id, this.title, this.number, this.createdAt, this.updatedAt});

  SosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? "";
    number = json['number'] ?? "0";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['number'] = this.number;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
