class User {
  String? userId;
  String? uuid;
  String? email;
  String? occuType;
  String? status;
  String? province;

  String? pin;
  String? tel;
  int? age;
  int? family;
  int? points;

  User({
    this.userId,
    this.uuid,
    this.email,
    this.pin,
    this.tel,
    this.occuType,
    this.status,
    this.age,
    this.family,
    this.points,
    this.province,
  });

  List<Object?> get props => [
        userId,
        uuid,
        email,
        pin,
        tel,
        occuType,
        status,
        age,
        family,
        points,
        province,
      ];

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'],
        uuid: json['uuid'],
        email: json['email'],
        pin: json['pin'],
        tel: json['tel'],
        occuType: json['occu_type'],
        status: json['status'],
        age: json['age'],
        family: json['family'],
        points: json['points'],
        province: json['province'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'uuid': uuid,
        'email': email,
        'pin': pin,
        'tel': tel,
        'occu_type': occuType,
        'status': status,
        'age': age,
        'family': family,
        'points': points,
        'province': province,
      };
}
