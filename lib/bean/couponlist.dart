
class CouponList {

  dynamic coupon_id;
  dynamic coupon_name;
  dynamic coupon_code;
  dynamic coupon_description;
  dynamic start_date;
  dynamic end_date;
  dynamic amount;
  dynamic type;
  dynamic uses_restriction;
  dynamic vendor_id;

  CouponList(
      this.coupon_id,
      this.coupon_name,
      this.coupon_code,
      this.coupon_description,
      this.start_date,
      this.end_date,
      this.amount,
      this.type,
      this.uses_restriction,
      this.vendor_id);

  factory CouponList.fromJson(dynamic json){
    return CouponList(json['coupon_id'], json['coupon_name'], json['coupon_code'], json['coupon_description'], json['start_date'], json['end_date'], json['amount'], json['type'], json['uses_restriction'], json['vendor_id']);
  }

  @override
  String toString() {
    return 'CouponList{coupon_id: $coupon_id, coupon_name: $coupon_name, coupon_code: $coupon_code, coupon_description: $coupon_description, start_date: $start_date, end_date: $end_date, amount: $amount, type: $type, uses_restriction: $uses_restriction, vendor_id: $vendor_id}';
  }
}