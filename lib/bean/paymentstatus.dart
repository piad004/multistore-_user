class PaymentVia {
  String status;
  String message;
  RazorpayBean razorpay;
  PaypalBean paypal;
  StripeBean stripe;
  PaystackBean paystack;
  PayMongoBean paymongobean;
  PaymentStatusMode payMode;

  PaymentVia(
      {this.status,
        this.message,
        this.razorpay,
        this.paypal,
        this.stripe,
        this.paystack,
      this.paymongobean,
      this.payMode});

  PaymentVia.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    razorpay = json['razorpay'] != null
        ? new RazorpayBean.fromJson(json['razorpay'])
        : null;
    paypal =
    json['paypal'] != null ? new PaypalBean.fromJson(json['paypal']) : null;
    stripe =
    json['stripe'] != null ? new StripeBean.fromJson(json['stripe']) : null;
    paystack = json['paystack'] != null
        ? new PaystackBean.fromJson(json['paystack'])
        : null;
    paymongobean = json['paymongo'] != null
        ? new PayMongoBean.fromJson(json['paymongo'])
        : new PayMongoBean.fromJsond();
    payMode = new PaymentStatusMode.fromJson(json['payment_status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.razorpay != null) {
      data['razorpay'] = this.razorpay.toJson();
    }
    if (this.paypal != null) {
      data['paypal'] = this.paypal.toJson();
    }
    if (this.stripe != null) {
      data['stripe'] = this.stripe.toJson();
    }
    if (this.paystack != null) {
      data['paystack'] = this.paystack.toJson();
    }
    if (this.paystack != null) {
      data['paymongo'] = this.paymongobean.toJson();
    }
    if (this.payMode != null) {
      data['payment_status'] = this.payMode.toJson();
    }
    return data;
  }
}

class PayMongoBean {
  String razorpayStatus;
  String razorpaySecret;
  String razorpayKey;
  String paymentCurrency;

  PayMongoBean(
      {this.razorpayStatus,
        this.razorpaySecret,
        this.razorpayKey,
        this.paymentCurrency});

  PayMongoBean.fromJson(Map<String, dynamic> json) {
    razorpayStatus = json['paymongo_status']!=null?json['paymongo_status']:'No';
    razorpaySecret = json['razorpay_secret']!=null?json['razorpay_secret']:'No';
    razorpayKey = json['razorpay_key']!=null?json['razorpay_key']:'No';
    paymentCurrency = json['payment_currency']!=null?json['payment_currency']:'No';
  }

  PayMongoBean.fromJsond() {
    razorpayStatus = 'No';
    razorpaySecret = 'No';
    razorpayKey = 'No';
    paymentCurrency = 'No';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymongo_status'] = this.razorpayStatus;
    data['razorpay_secret'] = this.razorpaySecret;
    data['razorpay_key'] = this.razorpayKey;
    data['payment_currency'] = this.paymentCurrency;
    return data;
  }
}

class RazorpayBean {
  String razorpayStatus;
  String razorpaySecret;
  String razorpayKey;
  String paymentCurrency;

  RazorpayBean(
      {this.razorpayStatus,
        this.razorpaySecret,
        this.razorpayKey,
        this.paymentCurrency});

  RazorpayBean.fromJson(Map<String, dynamic> json) {
    razorpayStatus = json['razorpay_status'];
    razorpaySecret = json['razorpay_secret'];
    razorpayKey = json['razorpay_key'];
    paymentCurrency = json['payment_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['razorpay_status'] = this.razorpayStatus;
    data['razorpay_secret'] = this.razorpaySecret;
    data['razorpay_key'] = this.razorpayKey;
    data['payment_currency'] = this.paymentCurrency;
    return data;
  }
}

class PaypalBean {
  String paypalStatus;
  String paypalClientId;
  String paypalSecret;
  String paymentCurrency;

  PaypalBean(
      {this.paypalStatus,
        this.paypalClientId,
        this.paypalSecret,
        this.paymentCurrency});

  PaypalBean.fromJson(Map<String, dynamic> json) {
    paypalStatus = json['paypal_status'];
    paypalClientId = json['paypal_client_id'];
    paypalSecret = json['paypal_secret'];
    paymentCurrency = json['payment_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paypal_status'] = this.paypalStatus;
    data['paypal_client_id'] = this.paypalClientId;
    data['paypal_secret'] = this.paypalSecret;
    data['payment_currency'] = this.paymentCurrency;
    return data;
  }
}

class StripeBean {
  String stripeStatus;
  String stripeSecret;
  String stripePublishable;
  String stripeMerchantId;
  String paymentCurrency;

  StripeBean(
      {this.stripeStatus,
        this.stripeSecret,
        this.stripePublishable,
        this.stripeMerchantId,
        this.paymentCurrency});

  StripeBean.fromJson(Map<String, dynamic> json) {
    stripeStatus = json['stripe_status'];
    stripeSecret = json['stripe_secret'];
    stripePublishable = json['stripe_publishable'];
    stripeMerchantId = json['stripe_merchant_id'];
    paymentCurrency = json['payment_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripe_status'] = this.stripeStatus;
    data['stripe_secret'] = this.stripeSecret;
    data['stripe_publishable'] = this.stripePublishable;
    data['stripe_merchant_id'] = this.stripeMerchantId;
    data['payment_currency'] = this.paymentCurrency;
    return data;
  }
}

class PaystackBean {
  String paystackStatus;
  String paystackPublicKey;
  String paystackSecretKey;
  String paymentCurrency;

  PaystackBean(
      {this.paystackStatus,
        this.paystackPublicKey,
        this.paystackSecretKey,
        this.paymentCurrency});

  PaystackBean.fromJson(Map<String, dynamic> json) {
    paystackStatus = json['paystack_status'];
    paystackPublicKey = json['paystack_public_key'];
    paystackSecretKey = json['paystack_secret_key'];
    paymentCurrency = json['payment_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paystack_status'] = this.paystackStatus;
    data['paystack_public_key'] = this.paystackPublicKey;
    data['paystack_secret_key'] = this.paystackSecretKey;
    data['payment_currency'] = this.paymentCurrency;
    return data;
  }
}

class PaymentStatusMode {
  dynamic payId;
  dynamic paymentStatus;
  dynamic codStatus;

  PaymentStatusMode({this.payId, this.paymentStatus, this.codStatus});

  PaymentStatusMode.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    paymentStatus = json['payment_status'];
    codStatus = json['cod_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['payment_status'] = this.paymentStatus;
    data['cod_status'] = this.codStatus;
    return data;
  }
}