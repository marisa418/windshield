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

  bool? isVerify;

  User({
    this.userId,
    this.uuid,
    this.email,
    this.occuType,
    this.status,
    this.province,
    this.pin,
    this.tel,
    this.age,
    this.family,
    this.points,
    this.isVerify,
  });

  List<Object?> get props => [
        userId,
        uuid,
        email,
        occuType,
        status,
        province,
        pin,
        tel,
        age,
        family,
        points,
        isVerify,
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
        isVerify: json['is_verify'],
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
        'is_verify': isVerify,
      };
}
