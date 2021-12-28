class CategoryList {
  dynamic category_id;
  dynamic cityadmin_id;
  dynamic category_name;
  dynamic category_image;
  dynamic home;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_id;

  CategoryList(
      this.category_id,
      this.cityadmin_id,
      this.category_name,
      this.category_image,
      this.home,
      this.created_at,
      this.updated_at,
      this.vendor_id);

  factory CategoryList.fromJson(dynamic json) {
    return CategoryList(
        json['category_id'],
        json['cityadmin_id'],
        json['category_name'],
        json['category_image'],
        json['home'],
        json['created_at'],
        json['updated_at'],
        json['vendor_id']);
  }

  @override
  String toString() {
    return 'CategoryList{category_id: $category_id, cityadmin_id: $cityadmin_id, category_name: $category_name, category_image: $category_image, home: $home, created_at: $created_at, updated_at: $updated_at, vendor_id: $vendor_id}';
  }
}
