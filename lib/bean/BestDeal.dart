class BestDeal {

  dynamic vendor_id;
  dynamic vendor_name;
  dynamic logo;
  dynamic percentage;

  BestDeal(
      this.vendor_id,
      this.vendor_name,
      this.logo,
      this.percentage);

  factory BestDeal.fromJson(dynamic json){
    return BestDeal(json['vendor_id'], json['vendor_name'], json['logo'], json['percentage']);
  }

  @override
  String toString() {
    return 'BestDeal{vendor_id: $vendor_id, vendor_name: $vendor_name, logo: $logo, percentage: $percentage}';
  }
}