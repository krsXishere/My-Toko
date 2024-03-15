class UserModel {
  int? id;
  String? email, password;
  bool isSelected;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    this.isSelected = false,
  });
}
