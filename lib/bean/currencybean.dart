class CurrencyData {

  dynamic currency_id;
  dynamic currency;
  dynamic currency_sign;

  CurrencyData(this.currency_id, this.currency, this.currency_sign);

  factory CurrencyData.fromJson(dynamic json){
    return CurrencyData(json['currency_id'], json['currency'], json['currency_sign']);
  }

  @override
  String toString() {
    return '{currency_id: $currency_id, currency: $currency, currency_sign: $currency_sign}';
  }
}