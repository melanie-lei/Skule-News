import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey(); // Create a key

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainScreenContainer mainScreenContainer = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: Responsive.isMobile(context)
          ? GetBuilder<MainScreenContainer>(
              init: mainScreenContainer,
              builder: (ctx) {
                return SideMenu(
                  selectionHandler: (menu) {
                    mainScreenContainer.selectMenu(menu);
                  },
                );
              })
          : null,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              leading: ThemeIconWidget(
                ThemeIcon.menuIcon,
                size: 25,
                color: Theme.of(context).iconTheme.color,
              ).setPadding(top: 20, left: 16, right: 16).ripple(() {
                scaffoldKey.currentState!.openDrawer();
              }),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            Responsive.isDesktop(context) || Responsive.isTablet(context)
                ? Expanded(
                    flex: Responsive.isMobile(context) ? 2 : 2,
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      child: GetBuilder<MainScreenContainer>(
                          init: mainScreenContainer,
                          builder: (ctx) {
                            return SideMenu(
                              selectionHandler: (menu) {
                                mainScreenContainer.selectMenu(menu);
                              },
                            );
                          }),
                    ).round(20).setPadding(top: 25, bottom: 25, left: 16))
                : Container(),
            Expanded(
                flex: Responsive.isDesktop(context) ? 8 : 4,
                child: GetBuilder<MainScreenContainer>(
                    init: mainScreenContainer,
                    builder: (ctx) {
                      return loadScreen(mainScreenContainer.menuType.value);
                    }))
          ],
        ),
      ),
    );
  }

  Widget loadScreen(MenuType menu) {
    switch (menu) {
      case MenuType.dashboard:
        // do something
        return const Dashboard();
      case MenuType.categories:
        // do something else
        return const CategoriesList(
          statusType: CategoryStatusType.active,
        );
      case MenuType.deactivatedCategories:
        // do something else
        return const CategoriesList(
          statusType: CategoryStatusType.deactivated,
        );
      case MenuType.addCategory:
        // do something else
        return const AddNewCategory();
      case MenuType.activeBlogs:
        // do something else
        return const BlogsList(statusType: BlogStatusType.active);
      case MenuType.featuredBlogs:
        // do something else
        return const BlogsList(statusType: BlogStatusType.featured);
      case MenuType.pendingApprovalBlogs:
        // do something else
        return const PendingApprovalsBlogs(
          statusType: BlogStatusType.pending,
        );
      case MenuType.rejectedBlogs:
        // do something else
        return const PendingApprovalsBlogs(statusType: BlogStatusType.rejected);
      case MenuType.deactivatedBlogs:
        // do something else
        return const BlogsList(statusType: BlogStatusType.deactivated);
      case MenuType.addBlog:
        // do something else
        return const AddBlog();
      case MenuType.changePassword:
        // do something else
        return const ChangePassword();
      case MenuType.updateProfile:
        // do something else
        return const UpdateProfile();
    }
  }
}
