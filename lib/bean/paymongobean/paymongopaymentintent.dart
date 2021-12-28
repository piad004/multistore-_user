class PaymentIntentPaymongo {
  PaymentIntentPaymongoData data;

  PaymentIntentPaymongo({this.data});

  PaymentIntentPaymongo.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentIntentPaymongoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'PaymentIntentPaymongo{data: $data}';
  }
}

class PaymentIntentPaymongoData {
  dynamic id;
  dynamic type;
  Attributes attributes;

  PaymentIntentPaymongoData({this.id, this.type, this.attributes});

  PaymentIntentPaymongoData.fromJson(Map<String, dynamic> json) {
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

  @override
  String toString() {
    return 'PaymentIntentPaymongoData{id: $id, type: $type, attributes: $attributes}';
  }
}

class Attributes {
  dynamic amount;
  dynamic currency;
  dynamic description;
  dynamic statementDescriptor;
  dynamic status;
  dynamic livemode;
  dynamic clientKey;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic lastPaymentError;
  List<String> paymentMethodAllowed;
  List<dynamic> payments;
  dynamic nextAction;
  PaymentMethodOptions paymentMethodOptions;
  dynamic metadata;

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
        this.paymentMethodOptions,
        this.metadata});

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
      payments = new List<dynamic>();
      json['payments'].forEach((v) {
        payments.add(v);
      });
    }
    nextAction = json['next_action'];
    paymentMethodOptions = json['payment_method_options'] != null
        ? new PaymentMethodOptions.fromJson(json['payment_method_options'])
        : null;
    metadata = json['metadata'];
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
    data['next_action'] = this.nextAction;
    if (this.paymentMethodOptions != null) {
      data['payment_method_options'] = this.paymentMethodOptions.toJson();
    }
    data['metadata'] = this.metadata;
    return data;
  }

  @override
  String toString() {
    return 'Attributes{amount: $amount, currency: $currency, description: $description, statementDescriptor: $statementDescriptor, status: $status, livemode: $livemode, clientKey: $clientKey, createdAt: $createdAt, updatedAt: $updatedAt, lastPaymentError: $lastPaymentError, paymentMethodAllowed: $paymentMethodAllowed, payments: $payments, nextAction: $nextAction, paymentMethodOptions: $paymentMethodOptions, metadata: $metadata}';
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
  dynamic requestThreeDSecure;

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