class PaymentAttachPaymongo {
  PaymentAttachPaymongoData data;

  PaymentAttachPaymongo({this.data});

  PaymentAttachPaymongo.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentAttachPaymongoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PaymentAttachPaymongoData {
  String id;
  String type;
  Attributes attributes;

  PaymentAttachPaymongoData({this.id, this.type, this.attributes});

  PaymentAttachPaymongoData.fromJson(Map<String, dynamic> json) {
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
  int amount;
  String currency;
  String description;
  String statementDescriptor;
  String status;
  bool livemode;
  String clientKey;
  int createdAt;
  int updatedAt;
  Null lastPaymentError;
  List<String> paymentMethodAllowed;
  List<Payments> payments;
  NextAction nextAction;
  PaymentMethodOptions paymentMethodOptions;

  Attributes(
      {this.amount,
        this.currency,
        this.description,
        this.statementDescriptor,
        this.status,
        this.livemode,
        this.clientKey,
        this.createdAt,
        this.updatedAt,
        this.lastPaymentError,
        this.paymentMethodAllowed,
        this.payments,
        this.nextAction,
        this.paymentMethodOptions});

  Attributes.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
    description = json['description'];
    statementDescriptor = json['statement_descriptor'];
    status = json['status'];
    livemode = json['livemode'];
    clientKey = json['client_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastPaymentError = json['last_payment_error'];
    paymentMethodAllowed = json['payment_method_allowed'].cast<String>();
    if (json['payments'] != null) {
      payments = new List<Payments>();
      json['payments'].forEach((v) {
        payments.add(new Payments.fromJson(v));
      });
    }
    nextAction = json['next_action'] != null
        ? new NextAction.fromJson(json['next_action'])
        : null;
    paymentMethodOptions = json['payment_method_options'] != null
        ? new PaymentMethodOptions.fromJson(json['payment_method_options'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['statement_descriptor'] = this.statementDescriptor;
    data['status'] = this.status;
    data['livemode'] = this.livemode;
    data['client_key'] = this.clientKey;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['last_payment_error'] = this.lastPaymentError;
    data['payment_method_allowed'] = this.paymentMethodAllowed;
    if (this.payments != null) {
      data['payments'] = this.payments.map((v) => v.toJson()).toList();
    }
    if (this.nextAction != null) {
      data['next_action'] = this.nextAction.toJson();
    }
    if (this.paymentMethodOptions != null) {
      data['payment_method_options'] = this.paymentMethodOptions.toJson();
    }
    return data;
  }
}

class Payments {
  String id;
  String type;
  AttributesU attributes;

  Payments({this.id, this.type, this.attributes});

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? new AttributesU.fromJson(json['attributes'])
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

class AttributesU {
  Null accessUrl;
  int amount;
  String balanceTransactionId;
  Billing billing;
  String currency;
  String description;
  bool disputed;
  Null externalReferenceNumber;
  int fee;
  int foreignFee;
  bool livemode;
  int netAmount;
  String origin;
  String paymentIntentId;
  Null payout;
  Source source;
  String statementDescriptor;
  String status;
  Null taxAmount;
  int availableAt;
  int createdAt;
  int paidAt;
  int updatedAt;

  AttributesU(
      {this.accessUrl,
        this.amount,
        this.balanceTransactionId,
        this.billing,
        this.currency,
        this.description,
        this.disputed,
        this.externalReferenceNumber,
        this.fee,
        this.foreignFee,
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

  AttributesU.fromJson(Map<String, dynamic> json) {
    accessUrl = json['access_url'];
    amount = json['amount'];
    balanceTransactionId = json['balance_transaction_id'];
    billing =
    json['billing'] != null ? new Billing.fromJson(json['billing']) : null;
    currency = json['currency'];
    description = json['description'];
    disputed = json['disputed'];
    externalReferenceNumber = json['external_reference_number'];
    fee = json['fee'];
    foreignFee = json['foreign_fee'];
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
    data['foreign_fee'] = this.foreignFee;
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

class Billing {
  Address address;
  String email;
  String name;
  String phone;

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
  String city;
  String country;
  String line1;
  String line2;
  String postalCode;
  String state;

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

class Source {
  String id;
  String type;
  String brand;
  String country;
  String last4;

  Source({this.id, this.type, this.brand, this.country, this.last4});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    brand = json['brand'];
    country = json['country'];
    last4 = json['last4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['brand'] = this.brand;
    data['country'] = this.country;
    data['last4'] = this.last4;
    return data;
  }
}

class NextAction {
  String type;
  Redirect redirect;

  NextAction({this.type, this.redirect});

  NextAction.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    redirect = json['redirect'] != null
        ? new Redirect.fromJson(json['redirect'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.redirect != null) {
      data['redirect'] = this.redirect.toJson();
    }
    return data;
  }
}

class Redirect {
  String url;
  String returnUrl;

  Redirect({this.url, this.returnUrl});

  Redirect.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    returnUrl = json['return_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['return_url'] = this.returnUrl;
    return data;
  }
}

class PaymentMethodOptions {
  Card card;

  PaymentMethodOptions({this.card});

  PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}

class Card {
  String requestThreeDSecure;

  Card({this.requestThreeDSecure});

  Card.fromJson(Map<String, dynamic> json) {
    requestThreeDSecure = json['request_three_d_secure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_three_d_secure'] = this.requestThreeDSecure;
    return data;
  }
}