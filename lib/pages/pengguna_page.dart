import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_umkm/common/theme.dart';
import 'package:toko_umkm/providers/user_provider.dart';
import 'package:toko_umkm/widgets/custom_icon_button_widget.dart';
import 'package:toko_umkm/widgets/custom_textformfield_widget.dart';

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List selectedUser = [];
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(
        context,
        listen: false,
      ).getAllUser();
    });

    return StatefulBuilder(builder: (context, customSetState) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: isSearch
              ? TextFormField(
                  style: primaryTextStyle,
                  cursorColor: primaryPurple,
                  cursorHeight: 20,
                  cursorWidth: 3,
                  controller: searchController,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) {
                    customSetState(() {
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).searchUser(value);
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: white,
                    border: InputBorder.none,
                    hintText: "Cari",
                    hintStyle: primaryTextStyle.copyWith(
                      color: unClickColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: unClickColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(
                        color: unClickColor,
                      ),
                    ),
                  ),
                )
              : Text(
                  "Pengguna",
                  style: primaryTextStyle.copyWith(
                    color: white,
                    fontWeight: bold,
                  ),
                ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: selectedUser.isEmpty
                  ? Row(
                      children: [
                        CustomIconButtonWidget(
                          onTap: () {
                            customSetState(() {
                              if (isSearch == false) {
                                // customSetState(() {
                                isSearch = !isSearch;
                                // });
                              } else {
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).getAllUser();

                                searchController.clear();

                                // customSetState(() {
                                isSearch = !isSearch;
                                // });
                              }
                            });
                          },
                          color: white,
                          icon: isSearch
                              ? Icons.cancel_rounded
                              : Icons.search_rounded,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomIconButtonWidget(
                          onTap: () {
                            Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).getAllUser();
                          },
                          color: white,
                          icon: Icons.refresh_rounded,
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Visibility(
                          visible: selectedUser.length <= 1,
                          child: Consumer<UserProvider>(
                            builder: (context, value, child) {
                              final users = value.users;

                              return CustomIconButtonWidget(
                                onTap: () {
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).searchUser(selectedUser[0].toString());
                                  emailController.text =
                                      users[0].email.toString();
                                  passwordController.text =
                                      users[0].password.toString();
                                  showModalEditUser(selectedUser[0]);
                                },
                                color: white,
                                icon: Icons.edit_rounded,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomIconButtonWidget(
                          onTap: () {
                            alertDialogDeleteUser();
                          },
                          color: white,
                          icon: Icons.delete_rounded,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomIconButtonWidget(
                          onTap: () {
                            customSetState(() {
                              selectedUser.clear();
                            });

                            Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).getAllUser();
                          },
                          color: white,
                          icon: Icons.refresh_rounded,
                        )
                      ],
                    ),
            ),
          ],
        ),
        body: Consumer<UserProvider>(
          builder: (context, value, child) {
            final users = value.users;

            return ListView.builder(
              itemCount: users.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final user = users[index];

                return CheckboxListTile(
                  activeColor: primaryPurple,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  title: Text(
                    user.email.toString(),
                    style: primaryTextStyle,
                  ),
                  subtitle: Text(
                    user.password.toString(),
                    style: primaryTextStyle,
                  ),
                  selected: user.isSelected,
                  value: user.isSelected,
                  onChanged: (value) {
                    customSetState(() {
                      user.isSelected = value!;

                      if (selectedUser.contains(user.id)) {
                        selectedUser.remove(user.id);
                      } else {
                        selectedUser.add(user.id);
                      }

                      // print(selectedUser.toString());
                    });
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secodaryPurple,
          onPressed: () {
            showModalAddUser();
          },
          child: Icon(
            Icons.add_rounded,
            color: white,
          ),
        ),
      );
    });
  }

  alertDialogDeleteUser() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builder) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            "Hapus Pengguna?",
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Batal",
                style: primaryTextStyle.copyWith(
                  color: white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
              onPressed: () {
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).deleteUser(selectedUser);

                Future.delayed(const Duration(seconds: 3)).then((value) {
                  selectedUser.clear();

                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).getAllUser();
                });

                // print("Berhasil");

                Navigator.of(context).pop();
              },
              child: Text(
                "Hapus",
                style: primaryTextStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showModalAddUser() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (builder) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: emailController,
                  hintText: "Masukkan email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Masukkan password",
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                    ),
                    onPressed: () {
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).createUser(
                        emailController.text,
                        passwordController.text,
                      );

                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).getAllUser();

                      emailController.text = "";
                      passwordController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Tambah",
                      style: primaryTextStyle.copyWith(
                        color: white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showModalEditUser(int id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (builder) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: emailController,
                  hintText: "Masukkan email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Masukkan password",
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                    ),
                    onPressed: () {
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).editUser(
                        id,
                        emailController.text,
                        passwordController.text,
                      );

                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).getAllUser();

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Edit",
                      style: primaryTextStyle.copyWith(
                        color: white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
