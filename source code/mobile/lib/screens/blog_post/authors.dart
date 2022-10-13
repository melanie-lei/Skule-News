import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Authors extends StatefulWidget {
  const Authors({Key? key}) : super(key: key);

  @override
  _AuthorsState createState() => _AuthorsState();
}

class _AuthorsState extends State<Authors> {
  List<UserModel> profiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: BackNavigationBar(
          title: LocalizationString.authors,
          centerTitle: true,
          backTapHandler: (){
            Get.back();
          },
        ),
        body: ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (BuildContext context, int index) {
            return UserTile(
              profile: profiles[index],
              onItemCallback: () {
                // NavigationService.instance.navigateToRoute(
                //     MaterialPageRoute(builder: (ctx) => const OthersProfileScreen()));
              },
              followCallback: () {},
            );
          },
        ));
  }
}
