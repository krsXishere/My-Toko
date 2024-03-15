import 'package:toko_umkm/databases/user_table.dart';
import 'package:toko_umkm/models/user_model.dart';

class UserService {
  Future<List<UserModel>> getAllUser() async {
    List<Map<String, dynamic>> user = await UserTable.readAll();
    final users = user.map((e) {
      return UserModel(
        id: e['id'],
        email: e['email'],
        password: e['password'],
      );
    }).toList();

    return users;
  }

  Future<void> createUser(String email, String password) async {
    await UserTable.create(email, password);
  }

  Future<void> editUser(int id, String email, String password) async {
    await UserTable.update(id, email, password);
  }

  Future<void> deleteUser(List id) async {
    await UserTable.delete(id);
  }

  Future<List<UserModel>> searchUser(String search) async {
    List<Map<String, dynamic>> user = await UserTable.search(search);
    final users = user.map((e) {
      return UserModel(
        id: e['id'],
        email: e['email'],
        password: e['password'],
      );
    }).toList();

    return users;
  }
}
