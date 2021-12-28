class LoginData {
  dynamic status;
  dynamic message;
  BodyData data;
  CurrencyD currency;

  LoginData({this.status, this.message, this.data, this.currency});

  LoginData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new BodyData.fromJson(json['data']) : null;
    currency = json['Currency'] != null
        ? new CurrencyD.fromJson(json['Currency'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.currency != null) {
      data['Currency'] = this.currency.toJson();
    }
    return data;
  }
}

class BodyData {
  dynamic userId;
  dynamic userName;
  dynamic userEmail;
  dynamic userImage;
  dynamic userPhone;
  dynamic userPassword;
  dynamic deviceId;
  dynamic walletCredits;
  dynamic rewards;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic otp;
  dynamic phoneVerified;
  dynamic referralCode;

  BodyData(
      {this.userId,
        this.userName,
        this.userEmail,
        this.userImage,
        this.userPhone,
        this.userPassword,
        this.deviceId,
        this.walletCredits,
        this.rewards,
        this.createdAt,
        this.updatedAt,
        this.otp,
        this.phoneVerified,
        this.referralCode});

  BodyData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userImage = json['user_image'];
    userPhone = json['user_phone'];
    userPassword = json['user_password'];
    deviceId = json['device_id'];
    walletCredits = json['wallet_credits'];
    rewards = json['rewards'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
    phoneVerified = json['phone_verified'];
    referralCode = json['referral_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_image'] = this.userImage;
    data['user_phone'] = this.userPhone;
    data['user_password'] = this.userPassword;
    data['device_id'] = this.deviceId;
    data['wallet_credits'] = this.walletCredits;
    data['rewards'] = this.rewards;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['otp'] = this.otp;
    data['phone_verified'] = this.phoneVerified;
    data['referral_code'] = this.referralCode;
    return data;
  }
}

class CurrencyD {
  dynamic currencyId;
  dynamic currency;
  dynamic currencySign;

  CurrencyD({this.currencyId, this.currency, this.currencySign});

  CurrencyD.fromJson(Map<String, dynamic> json) {
    currencyId = json['currency_id'];
    currency = json['currency'];
    currencySign = json['currency_sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_id'] = this.currencyId;
    data['currency'] = this.currency;
    data['currency_sign'] = this.currencySign;
    return data;
  }
}