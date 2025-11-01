import 'dart:convert';

class ProfileDetails {
  int? id;
  int? userId;
  String? licenceNumber;
  String? licenceIssueDate;
  String? licenceExpiryDate;
  String? licenceCategory;
  String? licenceIssuingAuthority;
  List<String>? licenceImages;
  String? bankName;
  String? holderName;
  String? iban;
  String? passportNumber;
  String? passportIssueDate;
  String? passportExpiryDate;
  String? passportIssuingCountry;
  String? fullName;
  String? dateOfBirth;
  List<String>? passportImages;
  String? cardNumber;
  String? cardIssueDate;
  String? cardExpiryDate;
  List<String>? cardImages;
  String? profileImage;
  String? vehicleTypeId;
  String? vehicleNumber;
  String? nifNumber;
  String? createdAt;
  String? updatedAt;
  String? address;
  String? phone;
  int? isOnline;
  User? user;

  ProfileDetails({
    this.id,
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
    this.createdAt,
    this.updatedAt,
    this.address,
    this.phone,
    this.isOnline,
    this.user,
  });

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    licenceNumber = json['licence_number'] ?? "";
    licenceIssueDate = json['licence_issue_date'] ?? "";
    licenceExpiryDate = json['licence_expiry_date'] ?? "";
    licenceCategory = json['licence_category'] ?? "";
    licenceIssuingAuthority = json['licence_issuing_authority'] ?? "";

    // Parse JSON string or List for licence_images
    if (json['licence_images'] is String) {
      try {
        final parsed = jsonDecode(json['licence_images']);
        licenceImages = parsed is List ? parsed.cast<String>() : [];
      } catch (e) {
        licenceImages = [];
      }
    } else if (json['licence_images'] is List) {
      licenceImages = (json['licence_images'] as List).cast<String>();
    } else {
      licenceImages = [];
    }

    bankName = json['bank_name'] ?? "";
    holderName = json['holder_name'] ?? "";
    iban = json['iban'] ?? "";
    passportNumber = json['passport_number'] ?? "";
    passportIssueDate = json['passport_issue_date'] ?? "";
    passportExpiryDate = json['passport_expiry_date'] ?? "";
    passportIssuingCountry = json['passport_issuing_country'] ?? "";
    fullName = json['full_name'] ?? "";
    dateOfBirth = json['date_of_birth'] ?? "";

    // Parse JSON string or List for passport_images
    if (json['passport_images'] is String) {
      try {
        final parsed = jsonDecode(json['passport_images']);
        passportImages = parsed is List ? parsed.cast<String>() : [];
      } catch (e) {
        passportImages = [];
      }
    } else if (json['passport_images'] is List) {
      passportImages = (json['passport_images'] as List).cast<String>();
    } else {
      passportImages = [];
    }

    cardNumber = json['card_number'] ?? "";
    cardIssueDate = json['card_issue_date'] ?? "";
    cardExpiryDate = json['card_expiry_date'] ?? "";

    // Parse JSON string or List for card_images
    if (json['card_images'] is String) {
      try {
        final parsed = jsonDecode(json['card_images']);
        cardImages = parsed is List ? parsed.cast<String>() : [];
      } catch (e) {
        cardImages = [];
      }
    } else if (json['card_images'] is List) {
      cardImages = (json['card_images'] as List).cast<String>();
    } else {
      cardImages = [];
    }

    profileImage = json['profile_image'] ?? "assets/images/p_image.jpeg";
    vehicleTypeId = json['vehicle_type_id']?.toString() ?? "";
    vehicleNumber = json['vehicle_number']?.toString() ?? "";
    nifNumber = json['nif_number']?.toString() ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    address = json['address'] ?? "";
    phone = json['phone'] ?? "";

    // Fix isOnline parsing
    isOnline = json['is_online'] is int
        ? json['is_online']
        : int.tryParse(json['is_online'].toString()) ?? null;

    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'licence_number': licenceNumber,
      'licence_issue_date': licenceIssueDate,
      'licence_expiry_date': licenceExpiryDate,
      'licence_category': licenceCategory,
      'licence_issuing_authority': licenceIssuingAuthority,
      'licence_images': licenceImages,
      'bank_name': bankName,
      'holder_name': holderName,
      'iban': iban,
      'passport_number': passportNumber,
      'passport_issue_date': passportIssueDate,
      'passport_expiry_date': passportExpiryDate,
      'passport_issuing_country': passportIssuingCountry,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'passport_images': passportImages,
      'card_number': cardNumber,
      'card_issue_date': cardIssueDate,
      'card_expiry_date': cardExpiryDate,
      'card_images': cardImages,
      'profile_image': profileImage,
      'vehicle_type_id': vehicleTypeId,
      'vehicle_number': vehicleNumber,
      'nif_number': nifNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'address': address,
      'phone': phone,
      'is_online': isOnline,
      'user': user?.toJson(),
    };
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? address;
  int? status;
  String? phone;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.status,
    this.phone,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    emailVerifiedAt = json['email_verified_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    address = json['address'] ?? "";
    status = json['status'] ?? "";
    phone = json['phone'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'address': address,
      'status': status,
      'phone': phone,
    };
  }
}
