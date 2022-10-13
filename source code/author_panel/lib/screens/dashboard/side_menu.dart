import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
  final Function(MenuType) selectionHandler;

  const SideMenu({Key? key, required this.selectionHandler}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late Function(MenuType) selectionHandler;
  final SideMenuContainer sideMenuContainer = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    selectionHandler = widget.selectionHandler;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor.darken(),
      child: GetBuilder<SideMenuContainer>(
          init: sideMenuContainer,
          builder: (ctx) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Responsive.isDesktop(context) || Responsive.isMobile(context)
                      ? DrawerHeader(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: ThemeIconWidget(
                                    ThemeIcon.bookMark,
                                    size: 40,
                                    color: Theme.of(context).primaryColorLight,
                                  ).p(12),
                                  color: Theme.of(context).primaryColor,
                                ).circular,
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppConfig.projectName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      getIt<UserProfileManager>().user!.name,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      getIt<UserProfileManager>().user!.email,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              LocalizationString.logout,
                              style: Theme.of(context).textTheme.titleSmall,
                            ).ripple(() {
                              getIt<UserProfileManager>().logout();
                              Get.offAll(() => const AskForLogin());
                            }),
                          ],
                        ))
                      : Container(),
                  DrawerListItem(
                    icon: ThemeIconWidget(ThemeIcon.home,
                        color: Theme.of(context).iconTheme.color, size: 20),
                    title: LocalizationString.dashboard,
                    isSelected: sideMenuContainer.selectedMenu.value ==
                        MenuType.dashboard,
                  ).ripple(() {
                    selectionHandler(MenuType.dashboard);
                    sideMenuContainer.selectMenu(MenuType.dashboard);
                  }),
                  DrawerListItemGroup(items: [
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.book,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.blogs,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.activeBlogs,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.activeBlogs);
                      sideMenuContainer.selectMenu(MenuType.activeBlogs);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.featured,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.featuredBlogs,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.featuredBlogs,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.featuredBlogs);
                      sideMenuContainer.selectMenu(MenuType.featuredBlogs);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.pending,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.pendingApproval,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.pendingApprovalBlogs,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.pendingApprovalBlogs);
                      sideMenuContainer
                          .selectMenu(MenuType.pendingApprovalBlogs);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.pending,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.rejected,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.rejectedBlogs,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.rejectedBlogs);
                      sideMenuContainer.selectMenu(MenuType.rejectedBlogs);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.deactivatedBlog,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.deActivatedBlogs,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.deactivatedBlogs,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.deactivatedBlogs);
                      sideMenuContainer.selectMenu(MenuType.deactivatedBlogs);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.add,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.addBlog,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.addBlog,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.addBlog);
                      sideMenuContainer.selectMenu(MenuType.addBlog);
                    }),
                  ], title: LocalizationString.blogs),
                  DrawerListItemGroup(items: [
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.categories,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.category,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.categories,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.categories);
                      sideMenuContainer.selectMenu(MenuType.categories);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.categories,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.deActivatedCategory,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.deactivatedCategories,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.deactivatedCategories);
                      sideMenuContainer
                          .selectMenu(MenuType.deactivatedCategories);
                    }),
                    // DrawerListItem(
                    //   icon: ThemeIconWidget(ThemeIcon.add,
                    //       color: Theme.of(context).iconTheme.color, size: 20),
                    //   title: LocalizationString.addCategory,
                    //   isSelected: sideMenuContainer.selectedMenu.value ==
                    //       MenuType.addCategory,
                    // ).ripple(() {
                    //   scaffoldKey.currentState!.openEndDrawer();
                    //   selectionHandler(MenuType.addCategory);
                    //   sideMenuContainer.selectMenu(MenuType.addCategory);
                    // }),
                  ], title: LocalizationString.categories),
                  DrawerListItemGroup(items: [
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.lock,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.changePwd,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.changePassword,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.changePassword);
                      sideMenuContainer.selectMenu(MenuType.changePassword);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.author,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.updateProfile,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.updateProfile,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.updateProfile);
                      sideMenuContainer.selectMenu(MenuType.updateProfile);
                    })
                  ], title: LocalizationString.settings),
                ],
              ),
            );
          }),
    );
  }
}
