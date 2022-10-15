class UserModel {
  String id;
  String fullName;
  String phone;
  String type;

  UserModel({required this.id, required this.fullName, required this.phone, required this.type});

  static UserModel fromJSON(Map<String, dynamic> data) =>
      UserModel(id: data['id'], fullName: data['fullName'], phone: data['phone'], type: data['type']);
}
