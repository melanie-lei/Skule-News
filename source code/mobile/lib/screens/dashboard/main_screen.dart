import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

//ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late MenuType menuType;
  late String? id;
  late String? extraData;

  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex, //New
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).iconTheme.color,
              ),
              activeIcon:
                  Icon(Icons.home, color: Theme.of(context).primaryColor),
              label: '',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium,
                  color: Theme.of(context).iconTheme.color),
              activeIcon: Icon(Icons.workspace_premium,
                  color: Theme.of(context).primaryColor),
              label: '',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              activeIcon:
                  Icon(Icons.search, color: Theme.of(context).primaryColor),
              label: '',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category,
                  color: Theme.of(context).iconTheme.color),
              activeIcon:
                  Icon(Icons.category, color: Theme.of(context).primaryColor),
              label: '',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: Theme.of(context).iconTheme.color),
              activeIcon: Icon(Icons.account_circle,
                  color: Theme.of(context).primaryColor),
              label: '',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          ],
          onTap: _onItemTapped, //New
        ),
        body: loadView());
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget loadView() {
    if (selectedIndex == 0) {
      return const DashboardScreen();
    } else if (selectedIndex == 1) {
      return const FeaturedPosts();
    } else if (selectedIndex == 2) {
      return const Recommendations();
    } else if (selectedIndex == 3) {
      return const Categories();
    } else if (selectedIndex == 4) {
      return const MyAccount();
    }
    return const DashboardScreen();
  }
}
