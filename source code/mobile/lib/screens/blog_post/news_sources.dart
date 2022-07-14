import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class NewsSources extends StatefulWidget {
  const NewsSources({Key? key}) : super(key: key);

  @override
  _NewsSourcesState createState() => _NewsSourcesState();
}

class _NewsSourcesState extends State<NewsSources> {
  List<UserModel> profiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: BackNavigationBar(
          title: LocalizationString.newsSources,
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
