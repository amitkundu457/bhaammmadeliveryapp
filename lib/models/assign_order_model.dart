class AssignOrderModel {
  int? id;
  int? userId;
  String? licenceNumber;
  String? licenceIssueDate;
  String? licenceExpiryDate;
  String? licenceCategory;
  String? licenceIssuingAuthority;
  String? licenceImages;
  String? bankName;
  String? holderName;
  String? iban;
  String? passportNumber;
  String? passportIssueDate;
  String? passportExpiryDate;
  String? passportIssuingCountry;
  String? fullName;
  String? dateOfBirth;
  String? passportImages;
  String? cardNumber;
  String? cardIssueDate;
  String? cardExpiryDate;
  String? cardImages;
  String? profileImage;
  int? vehicleTypeId;
  String? vehicleNumber;
  String? nifNumber;
  String? address;
  String? phone;
  String? createdAt;
  String? updatedAt;
  Deliveryman? deliveryman;
  List<DeliveryRequests>? deliveryRequests;

  AssignOrderModel(
      {this.id,
      this.userId,
      this.licenceNumber,
      this.licenceIssueDate,
      this.licenceExpiryDate,
      this.licenceCategory,
      this.licenceIssuingAuthority,
      this.licenceImages,
      this.bankName,
      this.holderName,
      this.iban,
      this.passportNumber,
      this.passportIssueDate,
      this.passportExpiryDate,
      this.passportIssuingCountry,
      this.fullName,
      this.dateOfBirth,
      this.passportImages,
      this.cardNumber,
      this.cardIssueDate,
      this.cardExpiryDate,
      this.cardImages,
      this.profileImage,
      this.vehicleTypeId,
      this.vehicleNumber,
      this.nifNumber,
      this.address,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.deliveryman,
      this.deliveryRequests});

  AssignOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    licenceNumber = json['licence_number'];
    licenceIssueDate = json['licence_issue_date'];
    licenceExpiryDate = json['licence_expiry_date'];
    licenceCategory = json['licence_category'];
    licenceIssuingAuthority = json['licence_issuing_authority'];
    licenceImages = json['licence_images'];
    bankName = json['bank_name'];
    holderName = json['holder_name'];
    iban = json['iban'];
    passportNumber = json['passport_number'];
    passportIssueDate = json['passport_issue_date'];
    passportExpiryDate = json['passport_expiry_date'];
    passportIssuingCountry = json['passport_issuing_country'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    passportImages = json['passport_images'];
    cardNumber = json['card_number'];
    cardIssueDate = json['card_issue_date'];
    cardExpiryDate = json['card_expiry_date'];
    cardImages = json['card_images'];
    profileImage = json['profile_image'];
    vehicleTypeId = json['vehicle_type_id'];
    vehicleNumber = json['vehicle_number'];
    nifNumber = json['nif_number'];
    address = json['address'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryman = json['deliveryman'] != null
        ? new Deliveryman.fromJson(json['deliveryman'])
        : null;
    if (json['delivery_requests'] != null) {
      deliveryRequests = <DeliveryRequests>[];
      json['delivery_requests'].forEach((v) {
        deliveryRequests!.add(new DeliveryRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['licence_number'] = this.licenceNumber;
    data['licence_issue_date'] = this.licenceIssueDate;
    data['licence_expiry_date'] = this.licenceExpiryDate;
    data['licence_category'] = this.licenceCategory;
    data['licence_issuing_authority'] = this.licenceIssuingAuthority;
    data['licence_images'] = this.licenceImages;
    data['bank_name'] = this.bankName;
    data['holder_name'] = this.holderName;
    data['iban'] = this.iban;
    data['passport_number'] = this.passportNumber;
    data['passport_issue_date'] = this.passportIssueDate;
    data['passport_expiry_date'] = this.passportExpiryDate;
    data['passport_issuing_country'] = this.passportIssuingCountry;
    data['full_name'] = this.fullName;
    data['date_of_birth'] = this.dateOfBirth;
    data['passport_images'] = this.passportImages;
    data['card_number'] = this.cardNumber;
    data['card_issue_date'] = this.cardIssueDate;
    data['card_expiry_date'] = this.cardExpiryDate;
    data['card_images'] = this.cardImages;
    data['profile_image'] = this.profileImage;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['vehicle_number'] = this.vehicleNumber;
    data['nif_number'] = this.nifNumber;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.deliveryman != null) {
      data['deliveryman'] = this.deliveryman!.toJson();
    }
    if (this.deliveryRequests != null) {
      data['delivery_requests'] =
          this.deliveryRequests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deliveryman {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Deliveryman(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  Deliveryman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class DeliveryRequests {
  int? id;
  int? orderId;
  int? deliveryBoyId;
  String? status;
  String? deliveryStatus;
  String? createdAt;
  String? updatedAt;
  Purchase? purchase;

  DeliveryRequests(
      {this.id,
      this.orderId,
      this.deliveryBoyId,
      this.status,
      this.deliveryStatus,
      this.createdAt,
      this.updatedAt,
      this.purchase});

  DeliveryRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    deliveryBoyId = json['delivery_boy_id'];
    status = json['status'];
    deliveryStatus = json['delivery_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    purchase = json['purchase'] != null
        ? new Purchase.fromJson(json['purchase'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['status'] = this.status;
    data['delivery_status'] = this.deliveryStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.purchase != null) {
      data['purchase'] = this.purchase!.toJson();
    }
    return data;
  }
}

class Purchase {
  int? id;
  String? purchaseId;
  int? customerId;
  String? total;
  int? totalProductQuantity;
  String? currency;
  String? status;
  String? paymentStatus;
  String? paymentMethod;
  String? date;
  String? deliveryStatus;
  int? deliveryId;
  String? insDes;
  String? createdAt;
  String? updatedAt;
  List<PurchaseItems>? purchaseItems;
  Customer? customer;

  Purchase(
      {this.id,
      this.purchaseId,
      this.customerId,
      this.total,
      this.totalProductQuantity,
      this.currency,
      this.status,
      this.paymentStatus,
      this.paymentMethod,
      this.date,
      this.deliveryStatus,
      this.deliveryId,
      this.insDes,
      this.createdAt,
      this.updatedAt,
      this.purchaseItems,
      this.customer});

  Purchase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    purchaseId = json['purchase_id'];
    customerId = json['customer_id'];
    total = json['total'];
    totalProductQuantity = json['total_product_quantity'];
    currency = json['currency'];
    status = json['status'];
    paymentStatus = json['payment_status']??"";
    paymentMethod = json['payment_method'];
    date = json['date'];
    deliveryStatus = json['delivery_status'];
    deliveryId = json['delivery_id'];
    insDes = json['ins_des'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['purchase_items'] != null) {
      purchaseItems = <PurchaseItems>[];
      json['purchase_items'].forEach((v) {
        purchaseItems!.add(new PurchaseItems.fromJson(v));
      });
    }
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['purchase_id'] = this.purchaseId;
    data['customer_id'] = this.customerId;
    data['total'] = this.total;
    data['total_product_quantity'] = this.totalProductQuantity;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['date'] = this.date;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_id'] = this.deliveryId;
    data['ins_des'] = this.insDes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.purchaseItems != null) {
      data['purchase_items'] =
          this.purchaseItems!.map((v) => v.toJson()).toList();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class PurchaseItems {
  int? id;
  int? purchaseId;
  int? productId;
  int? quantity;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  ProductDetails? productDetails;

  PurchaseItems(
      {this.id,
      this.purchaseId,
      this.productId,
      this.quantity,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.productDetails});

  PurchaseItems.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    purchaseId = json['purchase_id'] ?? 0;
    productId = json['product_id'] ?? 0;
    quantity = json['quantity'] ?? 0;
    price = json['price'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    productDetails = json['product_details'] != null
        ? new ProductDetails.fromJson(json['product_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['purchase_id'] = this.purchaseId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails!.toJson();
    }
    return data;
  }
}

class ProductDetails {
  int? id;
  String? type;
  int? categoryId;
  int? unitId;
  String? title;
  String? amount;
  String? mrp;
  String? slug;
  String? shortDescription;
  int? totalStock;
  String? sku;
  int? coins;
  String? featureImage;
  String? description;
  String? specifications;
  String? attributes;
  String? createdAt;
  String? updatedAt;

  ProductDetails(
      {this.id,
      this.type,
      this.categoryId,
      this.unitId,
      this.title,
      this.amount,
      this.mrp,
      this.slug,
      this.shortDescription,
      this.totalStock,
      this.sku,
      this.coins,
      this.featureImage,
      this.description,
      this.specifications,
      this.attributes,
      this.createdAt,
      this.updatedAt});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    type = json['type'] ?? "";
    categoryId = json['category_id'] ?? 0;
    unitId = json['unit_id'] ?? 0;
    title = json['title'] ?? "";
    amount = json['amount'] ?? "";
    mrp = json['mrp'] ?? "";
    slug = json['slug'] ?? "";
    shortDescription = json['short_description'] ?? "";
    totalStock = json['total_stock'] ?? 0;
    sku = json['sku'] ?? "";
    coins = json['coins'] ?? 0;
    featureImage = json['feature_image'] ?? "";
    description = json['description'] ?? "";
    specifications = json['specifications'] ?? "";
    attributes = json['attributes'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['category_id'] = this.categoryId;
    data['unit_id'] = this.unitId;
    data['title'] = this.title;
    data['amount'] = this.amount;
    data['mrp'] = this.mrp;
    data['slug'] = this.slug;
    data['short_description'] = this.shortDescription;
    data['total_stock'] = this.totalStock;
    data['sku'] = this.sku;
    data['coins'] = this.coins;
    data['feature_image'] = this.featureImage;
    data['description'] = this.description;
    data['specifications'] = this.specifications;
    data['attributes'] = this.attributes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  Customerdetails? customerdetails;
  List<Address>? address;

  Customer(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.customerdetails,
      this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    emailVerifiedAt = json['email_verified_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    customerdetails = json['customerdetails'] != null
        ? new Customerdetails.fromJson(json['customerdetails'])
        : null;
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customerdetails != null) {
      data['customerdetails'] = this.customerdetails!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customerdetails {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? createdAt;
  String? updatedAt;

  Customerdetails(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.createdAt,
      this.updatedAt});

  Customerdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    address = json['address'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Address {
  int? id;
  int? userId;
  String? name;
  String? contactNumber;
  String? houseBuilding;
  String? roadAreaColony;
  String? pincode;
  String? city;
  String? state;
  String? nearbyPlace;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.userId,
      this.name,
      this.contactNumber,
      this.houseBuilding,
      this.roadAreaColony,
      this.pincode,
      this.city,
      this.state,
      this.nearbyPlace,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'] ?? "";
    contactNumber = json['contact_number'] ?? "";
    houseBuilding = json['house_building'] ?? "";
    roadAreaColony = json['road_area_colony'] ?? "";
    pincode = json['pincode'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    nearbyPlace = json['nearby_place'] ?? "";
    latitude = json['latitude'] ?? "";
    longitude = json['longitude'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['house_building'] = this.houseBuilding;
    data['road_area_colony'] = this.roadAreaColony;
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['nearby_place'] = this.nearbyPlace;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
