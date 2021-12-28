class PayMongoPayment {
  PayPaymentData data;

  PayMongoPayment({this.data});

  PayMongoPayment.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PayPaymentData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PayPaymentData {
  dynamic id;
  dynamic type;
  PayAttributes attributes;

  PayPaymentData({this.id, this.type, this.attributes});

  PayPaymentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? new PayAttributes.fromJson(json['attributes'])
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

class PayAttributes {
  dynamic accessUrl;
  dynamic amount;
  dynamic balanceTransactionId;
  PayBilling billing;
  dynamic currency;
  dynamic description;
  dynamic disputed;
  dynamic externalReferenceNumber;
  dynamic fee;
  dynamic livemode;
  dynamic netAmount;
  dynamic origin;
  dynamic paymentIntentId;
  dynamic payout;
  Source source;
  dynamic statementDescriptor;
  dynamic status;
  dynamic taxAmount;
  dynamic availableAt;
  dynamic createdAt;
  dynamic paidAt;
  dynamic updatedAt;

  PayAttributes(
      {this.accessUrl,
        this.amount,
        this.balanceTransactionId,
        this.billing,
        this.currency,
        this.description,
        this.disputed,
        this.externalReferenceNumber,
        this.fee,
        this.livemode,
        this.netAmount,
        this.origin,
        this.paymentIntentId,
        this.payout,
        this.source,
        this.statementDescriptor,
        this.status,
        this.taxAmount,
        this.availableAt,
        this.createdAt,
        this.paidAt,
        this.updatedAt});

  PayAttributes.fromJson(Map<String, dynamic> json) {
    accessUrl = json['access_url'];
    amount = json['amount'];
    balanceTransactionId = json['balance_transaction_id'];
    billing =
    json['billing'] != null ? new PayBilling.fromJson(json['billing']) : null;
    currency = json['currency'];
    description = json['description'];
    disputed = json['disputed'];
    externalReferenceNumber = json['external_reference_number'];
    fee = json['fee'];
    livemode = json['livemode'];
    netAmount = json['net_amount'];
    origin = json['origin'];
    paymentIntentId = json['payment_intent_id'];
    payout = json['payout'];
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
    statementDescriptor = json['statement_descriptor'];
    status = json['status'];
    taxAmount = json['tax_amount'];
    availableAt = json['available_at'];
    createdAt = json['created_at'];
    paidAt = json['paid_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_url'] = this.accessUrl;
    data['amount'] = this.amount;
    data['balance_transaction_id'] = this.balanceTransactionId;
    if (this.billing != null) {
      data['billing'] = this.billing.toJson();
    }
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['disputed'] = this.disputed;
    data['external_reference_number'] = this.externalReferenceNumber;
    data['fee'] = this.fee;
    data['livemode'] = this.livemode;
    data['net_amount'] = this.netAmount;
    data['origin'] = this.origin;
    data['payment_intent_id'] = this.paymentIntentId;
    data['payout'] = this.payout;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    data['statement_descriptor'] = this.statementDescriptor;
    data['status'] = this.status;
    data['tax_amount'] = this.taxAmount;
    data['available_at'] = this.availableAt;
    data['created_at'] = this.createdAt;
    data['paid_at'] = this.paidAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PayBilling {
  PayAddress address;
  dynamic email;
  dynamic name;
  dynamic phone;

  PayBilling({this.address, this.email, this.name, this.phone});

  PayBilling.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? new PayAddress.fromJson(json['address']) : null;
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

class PayAddress {
  dynamic city;
  dynamic country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  PayAddress(
      {this.city,
        this.country,
        this.line1,
        this.line2,
        this.postalCode,
        this.state});

  PayAddress.fromJson(Map<String, dynamic> json) {
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

class Source {
  dynamic id;
  dynamic type;

  Source({this.id, this.type});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}