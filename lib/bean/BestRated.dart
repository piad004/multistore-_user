class BestRated {

  dynamic vendor_id;
  dynamic vendor_name;
  dynamic logo;
  dynamic rating;

  BestRated(
      this.vendor_id,
      this.vendor_name,
      this.logo,
      this.rating);

  factory BestRated.fromJson(dynamic json){
    return BestRated(json['vendor_id'], json['vendor_name'], json['logo'], json['rating']);
  }

  @override
  String toString() {
    return 'BestRated{vendor_id: $vendor_id, vendor_name: $vendor_name, logo: $logo, rating: $rating}';
  }
}