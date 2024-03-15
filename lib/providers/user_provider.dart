import 'package:flutter/material.dart';
import 'package:toko_umkm/models/user_model.dart';
import 'package:toko_umkm/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final _userService = UserService();
  List<UserModel> _users = [];
  List<UserModel> get users => _users;
  bool isLoading = false;

  void checkLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getAllUser() async {
    checkLoading(true);
    final data = await _userService.getAllUser();
     _users = data;
    checkLoading(false);
  }

  Future<void> createUser(String email, String password) async {
    checkLoading(true);
    await _userService.createUser(email, password);
    checkLoading(false);
  }

  Future<void> editUser(int id, String email, String password) async {
    checkLoading(true);
    await _userService.editUser(id, email, password);
    checkLoading(false);
  }

  Future<void> deleteUser(List id) async {
    checkLoading(true);
    await _userService.deleteUser(id);
    checkLoading(false);
  }

  Future<void> searchUser(String search) async {
    checkLoading(true);
    final data = await _userService.searchUser(search);
    _users = data;
    checkLoading(false);
  }
}
