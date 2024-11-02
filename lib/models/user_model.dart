class UserModel {
  String userName;
  String userId;
  String email;
  static String collectionName = "users";

  UserModel(
      {required this.userName, required this.userId, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json["userName"],
      userId: json["userId"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": this.userName,
      "userId": this.userId,
      "email": this.email,
    };
  }
}
