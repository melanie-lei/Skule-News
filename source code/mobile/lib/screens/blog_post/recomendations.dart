import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({Key? key}) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final RecommendationController recommendationController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      recommendationController.closeSearch();
      recommendationController.loadHashtags(isTrending: true);
      // recommendationController.loadLocations();
      // recommendationController.loadProfiles();
      recommendationController.loadSources();
    });
  }

  @override
  void didUpdateWidget(covariant Recommendations oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(children: [
          Row(
            children: [
              Expanded(
                child: SearchBarType3(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    showSearchIocn: true,
                    iconColor: Theme.of(context).primaryColor,
                    onSearchStarted: () {},
                    onSearchChanged: (searchTerm) {
                      recommendationController.searchTextChanged(searchTerm);
                    },
                    onSearchCompleted: (searchTerm) {}),
              ),
              Obx(() => recommendationController.searchText.isEmpty
                  ? Container()
                  : Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          LocalizationString.cancel.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ).ripple(() {
                          recommendationController.searchTextChanged('');
                          recommendationController.closeSearch();
                        }),
                      ],
                    ))
            ],
          ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
          divider(height: 0.5, context: context),
          GetBuilder<RecommendationController>(
              init: recommendationController,
              builder: (ctx) {
                return recommendationController.searchText.isEmpty
                    ? Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                                delegate: SliverChildListDelegate([
                              GetBuilder<RecommendationController>(
                                  init: recommendationController,
                                  builder: (ctx) {
                                    return recommendationController
                                            .isLoadingSource.value
                                        ? const RecommendationShimmer()
                                        : RecommendedSourceSection(
                                            items: recommendationController
                                                .sources,
                                          );
                                  }).vP16.shadowWithoutRadius(context: context),
                              GetBuilder<RecommendationController>(
                                  init: recommendationController,
                                  builder: (ctx) {
                                    return recommendationController
                                            .isLoadingHashtags.value
                                        ? const RecommendationShimmer()
                                        : RecommendedHashtagSection(
                                            items: recommendationController
                                                .hashtags,
                                          );
                                  }).vP16.shadowWithoutRadius(context: context),
                              const SizedBox(
                                height: 10,
                              ),
                              // GetBuilder<RecommendationController>(
                              //     init: recommendationController,
                              //     builder: (ctx) {
                              //       return recommendationController
                              //               .isLoadingLocations.value
                              //           ? const RecommendationShimmer()
                              //           : RecommendedLocationSection(
                              //               items: recommendationController
                              //                   .locations,
                              //             );
                              //     }).vP16.shadowWithoutRadius(context: context),
                              // const SizedBox(
                              //   height: 10,
                              // )
                            ]))
                          ],
                        ),
                      )
                    : const Expanded(child: SearchAnything());
              })
        ]),
      ),
    );
  }
}
