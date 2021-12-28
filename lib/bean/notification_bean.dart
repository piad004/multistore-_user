
class Notificationd{

  dynamic noti_id;
  dynamic user_id;
  dynamic noti_title;
  dynamic noti_message;
  dynamic read_by_user;
  dynamic created_at;
  dynamic image;

  Notificationd(this.noti_id, this.user_id, this.noti_title, this.noti_message,
      this.read_by_user, this.created_at, this.image);

  factory Notificationd.fromJson(dynamic json){
    return Notificationd(json['noti_id'], json['user_id'], json['noti_title'], json['noti_message'], json['read_by_user'], json['created_at'], json['image']);
  }

  @override
  String toString() {
    return 'Notificationd{noti_id: $noti_id, user_id: $user_id, noti_title: $noti_title, noti_message: $noti_message, read_by_user: $read_by_user, created_at: $created_at, image: $image}';
  }
}
