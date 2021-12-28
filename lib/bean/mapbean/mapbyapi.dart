class MapByApi {
  dynamic status;
  dynamic message;
  dynamic mapstatus;
  dynamic key;

  MapByApi({this.status, this.message, this.mapstatus, this.key});

  MapByApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    mapstatus = json['Staus'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['Staus'] = this.mapstatus;
    data['key'] = this.key;
    return data;
  }
}