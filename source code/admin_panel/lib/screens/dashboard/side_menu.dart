import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
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
                                Text(
                                  AppConfig.projectName,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              LocalizationString.logout,
                              style: Theme.of(context).textTheme.titleMedium,
                            ).ripple(() {
                              getIt<UserProfileManager>().logout();
                              Get.offAll(() => const LoginScreen());
                            })
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
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.add,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.addCategory,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.addCategory,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.addCategory);
                      sideMenuContainer.selectMenu(MenuType.addCategory);
                    }),
                  ], title: LocalizationString.categories),
                  DrawerListItemGroup(items: [
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.account,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.activeUsers,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.users,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.users);
                      sideMenuContainer.selectMenu(MenuType.users);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.account,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.deactivatedUsers,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.deactivatedUsers,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.deactivatedUsers);
                      sideMenuContainer.selectMenu(MenuType.deactivatedUsers);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.author,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.activeAuthors,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.authors,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.authors);
                      sideMenuContainer.selectMenu(MenuType.authors);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(ThemeIcon.author,
                          color: Theme.of(context).iconTheme.color, size: 20),
                      title: LocalizationString.deactivatedAuthors,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.deactivatedAuthors,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.deactivatedAuthors);
                      sideMenuContainer.selectMenu(MenuType.deactivatedAuthors);
                    }),
                  ], title: LocalizationString.users),
                  // DrawerListItemGroup(items: [
                  //   DrawerListItem(
                  //     icon: ThemeIconWidget(
                  //       ThemeIcon.packages,
                  //       color: Theme.of(context).iconTheme.color,
                  //       size: 20,
                  //     ),
                  //     title: LocalizationString.packages,
                  //     isSelected: sideMenuContainer.selectedMenu.value ==
                  //         MenuType.packages,
                  //   ).ripple(() {
                  //     scaffoldKey.currentState!.openEndDrawer();
                  //     selectionHandler(MenuType.packages);
                  //     sideMenuContainer.selectMenu(MenuType.packages);
                  //   }),
                  //   DrawerListItem(
                  //     icon: ThemeIconWidget(
                  //       ThemeIcon.add,
                  //       color: Theme.of(context).iconTheme.color,
                  //       size: 20,
                  //     ),
                  //     title: LocalizationString.addPackage,
                  //     isSelected: sideMenuContainer.selectedMenu.value ==
                  //         MenuType.addPackage,
                  //   ).ripple(() {
                  //     scaffoldKey.currentState!.openEndDrawer();
                  //     selectionHandler(MenuType.addPackage);
                  //     sideMenuContainer.selectMenu(MenuType.addPackage);
                  //   }),
                  // ], title: LocalizationString.packages),
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
                        ThemeIcon.setting,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.settings,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.settings,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.settings);
                      sideMenuContainer.selectMenu(MenuType.settings);
                    }),
                  ], title: LocalizationString.settings),
                  DrawerListItemGroup(items: [
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.report,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.reportedBlogs,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.reportAbusedBlogs,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.reportAbusedBlogs);
                      sideMenuContainer.selectMenu(MenuType.reportAbusedBlogs);
                    }),
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.report,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.reportedAuthors,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.reportAbusedAuthors,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.reportAbusedAuthors);
                      sideMenuContainer.selectMenu(MenuType.reportAbusedAuthors);
                    }),
                  ], title: LocalizationString.report),
                  DrawerListItemGroup(items: [
                    DrawerListItem(
                      icon: ThemeIconWidget(
                        ThemeIcon.helpHand,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                      title: LocalizationString.supportRequest,
                      isSelected: sideMenuContainer.selectedMenu.value ==
                          MenuType.supportRequests,
                    ).ripple(() {
                      scaffoldKey.currentState!.openEndDrawer();
                      selectionHandler(MenuType.supportRequests);
                      sideMenuContainer.selectMenu(MenuType.supportRequests);
                    }),
                  ], title: LocalizationString.supportRequest),
                ],
              ),
            );
          }),
    );
  }
}
