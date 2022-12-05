import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class AuthorsList extends StatefulWidget {
  final AccountStatusType statusType;

  const AuthorsList({Key? key, required this.statusType}) : super(key: key);

  @override
  _AuthorsListState createState() => _AuthorsListState();
}

class _AuthorsListState extends State<AuthorsList> {
  TextEditingController search = TextEditingController();
  final AuthorController authorController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  /// Loads all the authors' information.
  loadData() {
    authorController.setStatusType(widget.statusType);
    authorController.getAllUsers();
  }

  @override
  void didUpdateWidget(covariant AuthorsList oldWidget) {
    // TODO: implement didUpdateWidget
    loadData();
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
                  ? LocalizationString.authors
                  : LocalizationString.deactivatedAuthors),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: usersWidget()),
        ],
      ).setPadding(left: 25, right: 25, top: 25),
    );
  }

  /// Displays a list of all the active authors.
  /// 
  Widget usersWidget() {
    return Column(
      children: [
        InputField(
          controller: search,
          hintText: LocalizationString.searchAuthor,
          onChanged: (text) {
            authorController.searchTextChanged(text);
            authorController.getAllUsers();
          },
          cornerRadius: 10,
        ).shadow(context: context).setPadding(top: 25),
        Expanded(
          child: GetBuilder<AuthorController>(
              init: authorController,
              builder: (ctx) {
                return authorController.authors.isNotEmpty ? ListView.separated(
                  itemCount: authorController.authors.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      color: Theme.of(context).backgroundColor.darken(0.1),
                      child: AuthorTile(
                        model: authorController.authors[index],
                        deleteHandler: () {
                          authorController
                              .deleteUser(authorController.authors[index]);
                        },
                        reactivateHandler: () {
                          authorController
                              .reactivateUser(authorController.authors[index]);
                        },
                        convertHandler: () {
                          authorController
                              .convertUser(authorController.authors[index]);
                        },
                      ),
                    ).round(10);
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
}
