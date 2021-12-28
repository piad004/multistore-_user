class SubCategoryList {

  dynamic subcat_id;
  dynamic category_id;
  dynamic subcat_name;
  dynamic subcat_image;
  dynamic created_at;
  dynamic updated_at;



  SubCategoryList(this.subcat_id, this.category_id, this.subcat_name,
      this.subcat_image, this.created_at, this.updated_at);

  factory SubCategoryList.fromJson(dynamic json) {
    return SubCategoryList(
        json['subcat_id'], json['category_id'], json['subcat_name'],
        json['subcat_image'], json['created_at'], json['updated_at']);
  }

  @override
  String toString() {
    return 'SubCategoryList{subcat_id: $subcat_id, category_id: $category_id, subcat_name: $subcat_name, subcat_image: $subcat_image, created_at: $created_at, updated_at: $updated_at}';
  }

}