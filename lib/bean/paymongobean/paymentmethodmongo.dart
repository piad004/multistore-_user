class PaymentMethodPaymongo {
  PaymentMethodPaymongoData data;

  PaymentMethodPaymongo({this.data});

  PaymentMethodPaymongo.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentMethodPaymongoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PaymentMethodPaymongoData {
  dynamic id;
  dynamic type;
  Attributes attributes;

  PaymentMethodPaymongoData({this.id, this.type, this.attributes});

  PaymentMethodPaymongoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
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

class Attributes {
  dynamic livemode;
  dynamic type;
  Billing billing;
  dynamic createdAt;
  dynamic updatedAt;
  Details details;

  Attributes(
      {this.livemode,
        this.type,
        this.billing,
        this.createdAt,
        this.updatedAt,
        this.details});

  Attributes.fromJson(Map<String, dynamic> json) {
    livemode = json['livemode'];
    type = json['type'];
    billing =
    json['billing'] != null ? new Billing.fromJson(json['billing']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['livemode'] = this.livemode;
    data['type'] = this.type;
    if (this.billing != null) {
      data['billing'] = this.billing.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}

class Billing {
  Address address;
  dynamic email;
  dynamic name;
  dynamic phone;

  Billing({this.address, this.email, this.name, this.phone});

  Billing.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
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

class Address {
  dynamic city;
  dynamic country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  Address(
      {this.city,
        this.country,
        this.line1,
        this.line2,
        this.postalCode,
        this.state});

  Address.fromJson(Map<String, dynamic> json) {
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

class Details {
  dynamic expMonth;
  dynamic expYear;
  dynamic last4;

  Details({this.expMonth, this.expYear, this.last4});

  Details.fromJson(Map<String, dynamic> json) {
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    last4 = json['last4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['last4'] = this.last4;
    return data;
  }
}