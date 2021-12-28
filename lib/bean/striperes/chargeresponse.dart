class StripeChargeResponse {
  dynamic id;
  dynamic object;
  dynamic amount;
  dynamic amountCaptured;
  dynamic amountRefunded;
  dynamic application;
  dynamic applicationFee;
  dynamic applicationFeeAmount;
  dynamic balanceTransaction;
  BillingDetails billingDetails;
  dynamic calculatedStatementDescriptor;
  dynamic captured;
  dynamic created;
  dynamic currency;
  dynamic customer;
  dynamic description;
  dynamic destination;
  dynamic dispute;
  dynamic disputed;
  dynamic failureCode;
  dynamic failureMessage;
  // FraudDetails fraudDetails;
  dynamic invoice;
  dynamic livemode;
  dynamic onBehalfOf;
  dynamic order;
  Outcome outcome;
  dynamic paid;
  dynamic paymentIntent;
  dynamic paymentMethod;
  PaymentMethodDetails paymentMethodDetails;
  dynamic receiptEmail;
  dynamic receiptNumber;
  dynamic receiptUrl;
  dynamic refunded;
  Refunds refunds;
  dynamic review;
  dynamic shipping;
  Source source;
  dynamic sourceTransfer;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  dynamic status;
  dynamic transferData;
  dynamic transferGroup;

  StripeChargeResponse({this.id, this.object, this.amount, this.amountCaptured, this.amountRefunded, this.application, this.applicationFee, this.applicationFeeAmount, this.balanceTransaction, this.billingDetails, this.calculatedStatementDescriptor, this.captured, this.created, this.currency, this.customer, this.description, this.destination, this.dispute, this.disputed, this.failureCode, this.failureMessage, this.invoice, this.livemode, this.onBehalfOf, this.order, this.outcome, this.paid, this.paymentIntent, this.paymentMethod, this.paymentMethodDetails, this.receiptEmail, this.receiptNumber, this.receiptUrl, this.refunded, this.refunds, this.review, this.shipping, this.source, this.sourceTransfer, this.statementDescriptor, this.statementDescriptorSuffix, this.status, this.transferData, this.transferGroup});

  StripeChargeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    amount = json['amount'];
    amountCaptured = json['amount_captured'];
    amountRefunded = json['amount_refunded'];
    application = json['application'];
    applicationFee = json['application_fee'];
    applicationFeeAmount = json['application_fee_amount'];
    balanceTransaction = json['balance_transaction'];
    billingDetails = json['billing_details'] != null ? new BillingDetails.fromJson(json['billing_details']) : null;
    calculatedStatementDescriptor = json['calculated_statement_descriptor'];
    captured = json['captured'];
    created = json['created'];
    currency = json['currency'];
    customer = json['customer'];
    description = json['description'];
    destination = json['destination'];
    dispute = json['dispute'];
    disputed = json['disputed'];
    failureCode = json['failure_code'];
    failureMessage = json['failure_message'];
    invoice = json['invoice'];
    livemode = json['livemode'];
    onBehalfOf = json['on_behalf_of'];
    order = json['order'];
    outcome = json['outcome'] != null ? new Outcome.fromJson(json['outcome']) : null;
    paid = json['paid'];
    paymentIntent = json['payment_intent'];
    paymentMethod = json['payment_method'];
    paymentMethodDetails = json['payment_method_details'] != null ? new PaymentMethodDetails.fromJson(json['payment_method_details']) : null;
    receiptEmail = json['receipt_email'];
    receiptNumber = json['receipt_number'];
    receiptUrl = json['receipt_url'];
    refunded = json['refunded'];
    refunds = json['refunds'] != null ? new Refunds.fromJson(json['refunds']) : null;
    review = json['review'];
    shipping = json['shipping'];
    source = json['source'] != null ? new Source.fromJson(json['source']) : null;
    sourceTransfer = json['source_transfer'];
    statementDescriptor = json['statement_descriptor'];
    statementDescriptorSuffix = json['statement_descriptor_suffix'];
    status = json['status'];
    transferData = json['transfer_data'];
    transferGroup = json['transfer_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['amount'] = this.amount;
    data['amount_captured'] = this.amountCaptured;
    data['amount_refunded'] = this.amountRefunded;
    data['application'] = this.application;
    data['application_fee'] = this.applicationFee;
    data['application_fee_amount'] = this.applicationFeeAmount;
    data['balance_transaction'] = this.balanceTransaction;
    if (this.billingDetails != null) {
      data['billing_details'] = this.billingDetails.toJson();
    }
    data['calculated_statement_descriptor'] = this.calculatedStatementDescriptor;
    data['captured'] = this.captured;
    data['created'] = this.created;
    data['currency'] = this.currency;
    data['customer'] = this.customer;
    data['description'] = this.description;
    data['destination'] = this.destination;
    data['dispute'] = this.dispute;
    data['disputed'] = this.disputed;
    data['failure_code'] = this.failureCode;
    data['failure_message'] = this.failureMessage;
    data['invoice'] = this.invoice;
    data['livemode'] = this.livemode;
    data['on_behalf_of'] = this.onBehalfOf;
    data['order'] = this.order;
    if (this.outcome != null) {
      data['outcome'] = this.outcome.toJson();
    }
    data['paid'] = this.paid;
    data['payment_intent'] = this.paymentIntent;
    data['payment_method'] = this.paymentMethod;
    if (this.paymentMethodDetails != null) {
      data['payment_method_details'] = this.paymentMethodDetails.toJson();
    }
    data['receipt_email'] = this.receiptEmail;
    data['receipt_number'] = this.receiptNumber;
    data['receipt_url'] = this.receiptUrl;
    data['refunded'] = this.refunded;
    if (this.refunds != null) {
      data['refunds'] = this.refunds.toJson();
    }
    data['review'] = this.review;
    data['shipping'] = this.shipping;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    data['source_transfer'] = this.sourceTransfer;
    data['statement_descriptor'] = this.statementDescriptor;
    data['statement_descriptor_suffix'] = this.statementDescriptorSuffix;
    data['status'] = this.status;
    data['transfer_data'] = this.transferData;
    data['transfer_group'] = this.transferGroup;
    return data;
  }
}

class BillingDetails {
  Address address;
  dynamic email;
  dynamic name;
  dynamic phone;

  BillingDetails({this.address, this.email, this.name, this.phone});

  BillingDetails.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
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

  Address({this.city, this.country, this.line1, this.line2, this.postalCode, this.state});

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


class Outcome {
  dynamic networkStatus;
  dynamic reason;
  dynamic riskLevel;
  dynamic riskScore;
  dynamic sellerMessage;
  dynamic type;

  Outcome({this.networkStatus, this.reason, this.riskLevel, this.riskScore, this.sellerMessage, this.type});

  Outcome.fromJson(Map<String, dynamic> json) {
    networkStatus = json['network_status'];
    reason = json['reason'];
    riskLevel = json['risk_level'];
    riskScore = json['risk_score'];
    sellerMessage = json['seller_message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['network_status'] = this.networkStatus;
    data['reason'] = this.reason;
    data['risk_level'] = this.riskLevel;
    data['risk_score'] = this.riskScore;
    data['seller_message'] = this.sellerMessage;
    data['type'] = this.type;
    return data;
  }
}

class PaymentMethodDetails {
  Card card;
  dynamic type;

  PaymentMethodDetails({this.card, this.type});

  PaymentMethodDetails.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Card {
  dynamic brand;
  Checks checks;
  dynamic country;
  dynamic expMonth;
  dynamic expYear;
  dynamic fingerprint;
  dynamic funding;
  dynamic installments;
  dynamic last4;
  dynamic network;
  dynamic threeDSecure;
  dynamic wallet;

  Card({this.brand, this.checks, this.country, this.expMonth, this.expYear, this.fingerprint, this.funding, this.installments, this.last4, this.network, this.threeDSecure, this.wallet});

  Card.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    checks = json['checks'] != null ? new Checks.fromJson(json['checks']) : null;
    country = json['country'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    installments = json['installments'];
    last4 = json['last4'];
    network = json['network'];
    threeDSecure = json['three_d_secure'];
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    if (this.checks != null) {
      data['checks'] = this.checks.toJson();
    }
    data['country'] = this.country;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['fingerprint'] = this.fingerprint;
    data['funding'] = this.funding;
    data['installments'] = this.installments;
    data['last4'] = this.last4;
    data['network'] = this.network;
    data['three_d_secure'] = this.threeDSecure;
    data['wallet'] = this.wallet;
    return data;
  }
}

class Checks {
  dynamic addressLine1Check;
  dynamic addressPostalCodeCheck;
  dynamic cvcCheck;

  Checks({this.addressLine1Check, this.addressPostalCodeCheck, this.cvcCheck});

  Checks.fromJson(Map<String, dynamic> json) {
    addressLine1Check = json['address_line1_check'];
    addressPostalCodeCheck = json['address_postal_code_check'];
    cvcCheck = json['cvc_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line1_check'] = this.addressLine1Check;
    data['address_postal_code_check'] = this.addressPostalCodeCheck;
    data['cvc_check'] = this.cvcCheck;
    return data;
  }
}

class Refunds {
  dynamic object;
  List<String> data;
  dynamic hasMore;
  dynamic totalCount;
  dynamic url;

  Refunds({this.object, this.data, this.hasMore, this.totalCount, this.url});

  Refunds.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    if (json['data'] != null) {
      data = new List<String>();
      // json['data'].forEach((v) { data.add(new Null.fromJson(v)); });
    }
    hasMore = json['has_more'];
    totalCount = json['total_count'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['has_more'] = this.hasMore;
    data['total_count'] = this.totalCount;
    data['url'] = this.url;
    return data;
  }
}

class Source {
  dynamic id;
  dynamic object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  dynamic brand;
  dynamic country;
  dynamic customer;
  dynamic cvcCheck;
  dynamic dynamicLast4;
  dynamic expMonth;
  dynamic expYear;
  dynamic fingerprint;
  dynamic funding;
  dynamic last4;
  dynamic name;
  dynamic tokenizationMethod;

  Source({this.id, this.object, this.addressCity, this.addressCountry, this.addressLine1, this.addressLine1Check, this.addressLine2, this.addressState, this.addressZip, this.addressZipCheck, this.brand, this.country, this.customer, this.cvcCheck, this.dynamicLast4, this.expMonth, this.expYear, this.fingerprint, this.funding, this.last4, this.name, this.tokenizationMethod});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    addressCity = json['address_city'];
    addressCountry = json['address_country'];
    addressLine1 = json['address_line1'];
    addressLine1Check = json['address_line1_check'];
    addressLine2 = json['address_line2'];
    addressState = json['address_state'];
    addressZip = json['address_zip'];
    addressZipCheck = json['address_zip_check'];
    brand = json['brand'];
    country = json['country'];
    customer = json['customer'];
    cvcCheck = json['cvc_check'];
    dynamicLast4 = json['dynamic_last4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    last4 = json['last4'];
    name = json['name'];
    tokenizationMethod = json['tokenization_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['address_city'] = this.addressCity;
    data['address_country'] = this.addressCountry;
    data['address_line1'] = this.addressLine1;
    data['address_line1_check'] = this.addressLine1Check;
    data['address_line2'] = this.addressLine2;
    data['address_state'] = this.addressState;
    data['address_zip'] = this.addressZip;
    data['address_zip_check'] = this.addressZipCheck;
    data['brand'] = this.brand;
    data['country'] = this.country;
    data['customer'] = this.customer;
    data['cvc_check'] = this.cvcCheck;
    data['dynamic_last4'] = this.dynamicLast4;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['fingerprint'] = this.fingerprint;
    data['funding'] = this.funding;
    data['last4'] = this.last4;
    data['name'] = this.name;
    data['tokenization_method'] = this.tokenizationMethod;
    return data;
  }
}




class RespError {
  ErrorSt error;

  RespError({this.error});

  RespError.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new ErrorSt.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class ErrorSt {
  dynamic charge;
  dynamic code;
  dynamic declineCode;
  dynamic docUrl;
  dynamic message;
  dynamic type;

  ErrorSt(
      {this.charge,
        this.code,
        this.declineCode,
        this.docUrl,
        this.message,
        this.type});

  ErrorSt.fromJson(Map<String, dynamic> json) {
    charge = json['charge'];
    code = json['code'];
    declineCode = json['decline_code'];
    docUrl = json['doc_url'];
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['charge'] = this.charge;
    data['code'] = this.code;
    data['decline_code'] = this.declineCode;
    data['doc_url'] = this.docUrl;
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }

  @override
  String toString() {
    return 'Error{charge: $charge, declineCode: $declineCode, docUrl: $docUrl, message: $message, type: $type}';
  }
}