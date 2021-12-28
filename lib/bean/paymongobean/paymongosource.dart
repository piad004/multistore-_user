class PayMongoSource {
  PayMongoSourceData data;

  PayMongoSource({this.data});

  PayMongoSource.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PayMongoSourceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PayMongoSourceData {
  dynamic id;
  dynamic type;
  PSourceAttributes attributes;

  PayMongoSourceData({this.id, this.type, this.attributes});

  PayMongoSourceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? new PSourceAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    return data;
  }
}

class PSourceAttributes {
  dynamic amount;
  Billing billing;
  dynamic currency;
  dynamic livemode;
  Redirect redirect;
  dynamic status;
  dynamic type;
  dynamic createdAt;
  dynamic updatedAt;

  PSourceAttributes(
      {this.amount,
        this.billing,
        this.currency,
        this.livemode,
        this.redirect,
        this.status,
        this.type,
        this.createdAt,
        this.updatedAt});

  PSourceAttributes.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    billing =
    json['billing'] != null ? new Billing.fromJson(json['billing']) : null;
    currency = json['currency'];
    livemode = json['livemode'];
    redirect = json['redirect'] != null
        ? new Redirect.fromJson(json['redirect'])
        : null;
    status = json['status'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    if (this.billing != null) {
      data['billing'] = this.billing.toJson();
    }
    data['currency'] = this.currency;
    data['livemode'] = this.livemode;
    if (this.redirect != null) {
      data['redirect'] = this.redirect.toJson();
    }
    data['status'] = this.status;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Billing {
  PSourceAddress address;
  dynamic email;
  dynamic name;
  dynamic phone;

  Billing({this.address, this.email, this.name, this.phone});

  Billing.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? new PSourceAddress.fromJson(json['address']) : null;
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}

class PSourceAddress {
  dynamic city;
  dynamic country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  PSourceAddress(
      {this.city,
        this.country,
        this.line1,
        this.line2,
        this.postalCode,
        this.state});

  PSourceAddress.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    line1 = json['line1'];
    line2 = json['line2'];
    postalCode = json['postal_code'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['postal_code'] = this.postalCode;
    data['state'] = this.state;
    return data;
  }
}

class Redirect {
  dynamic checkoutUrl;
  dynamic failed;
  dynamic success;

  Redirect({this.checkoutUrl, this.failed, this.success});

  Redirect.fromJson(Map<String, dynamic> json) {
    checkoutUrl = json['checkout_url'];
    failed = json['failed'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkout_url'] = this.checkoutUrl;
    data['failed'] = this.failed;
    data['success'] = this.success;
    return data;
  }
}