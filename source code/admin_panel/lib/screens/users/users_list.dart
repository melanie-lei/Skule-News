import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class UsersList extends StatefulWidget {
  final AccountStatusType statusType;

  const UsersList({Key? key, required this.statusType}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  TextEditingController search = TextEditingController();
  final UsersController userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    getAllUsers();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UsersList oldWidget) {
    // TODO: implement didUpdateWidget
    getAllUsers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(
              title: widget.statusType == AccountStatusType.active
                  ? LocalizationString.users
                  : LocalizationString.deactivatedUsers),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: usersWidget()),
        ],
      ).setPadding(left: 25, right: 25, top: 25),
    );
  }

  Widget usersWidget() {
    return Column(
      children: [
        InputField(
          controller: search,
          hintText: LocalizationString.searchUser,
          onChanged: (text) {
            userController.searchTextChanged(text);
            userController.getAllUsers();
          },
          cornerRadius: 10,
        ).shadow(context: context).setPadding(top: 25),
        Expanded(
          child: GetBuilder<UsersController>(
              init: userController,
              builder: (ctx) {
                return userController.users.isNotEmpty ? ListView.separated(
                  itemCount: userController.users.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return UserTile(
                        model: userController.users[index],
                        deleteHandler: () {
                          userController
                              .deleteUser(userController.users[index]);
                        });
                  },
                  separatorBuilder: (BuildContext ctx, int index) {
                    return Container(
                      height: 0.2,
                      color: Theme.of(context).dividerColor,
                      width: double.infinity,
                    ).vP8;
                  },
                ).vP25 : noDataFound(context);
              }),
        ),
      ],
    );
  }

  getAllUsers() {
    userController.setStatusType(widget.statusType);
    userController.getAllUsers();
  }
}
