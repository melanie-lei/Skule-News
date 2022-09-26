import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return const PostTileShimmer().hP16;
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}

class PostTileShimmer extends StatelessWidget {
  const PostTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.grey,
                      ).circular.addShimmer(context),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adam',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600)).addShimmer(context),
                          Text(
                              '200k ${LocalizationString.followers.toLowerCase()}',
                              style: Theme.of(context).textTheme.bodySmall).addShimmer(context),
                        ],
                      ).lP8,
                      const Spacer(),
                    ],
                  ).bP16,
                  Text(
                      'Lorem ipsum dolor sit amet. Est sequi possimus hic amet nihil in laborum nihil',
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600)).addShimmer(context),
                ],
              )),

              const SizedBox(
                width: 10,
              ),

              Container(
                color: Colors.grey,
                width: 100,
                height: 80,
              ).round(5).addShimmer(context),
              // divider(context: context).vP16,
            ],
          ),
          divider(context: context).vP16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ThemeIconWidget(
                ThemeIcon.clock,
                size: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Text('5 days ago',
                  maxLines: 2, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              ThemeIconWidget(
                ThemeIcon.bookMark,
                color: Theme.of(context).errorColor,
              )
            ],
          ).addShimmer(context),
        ],
      ),
    ).hP16;
  }
}

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
                  height: 30,
                  width: 30,
                  child: ThemeIconWidget(ThemeIcon.account))
              .addShimmer(context),
          const SizedBox(width: 5),
          Expanded(
              child: Text(
            'Adam',
            style: Theme.of(context).textTheme.bodyLarge,
          ).addShimmer(context)),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 280,
        width: double.infinity,
        child: Container(
          color: Colors.grey,
        ),
      ).addShimmer(context).round(20),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ThemeIconWidget(
            ThemeIcon.message,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(
            width: 5,
          ),
          Text('10k', style: Theme.of(context).textTheme.bodyMedium)
        ]),
        const SizedBox(
          width: 10,
        ),
        const ThemeIconWidget(ThemeIcon.favFilled, color: Colors.white),
        const SizedBox(
          width: 5,
        ),
        const Text('205k'),
      ]).vP16.addShimmer(context),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
              'Lorem ipsum dolor sit amet. Et ipsa libero est dolor facilis qui distinctio neque. Sed dolorum accusamus qui tempora doloremque et suscipit quidem et voluptate'),
          SizedBox(
            height: 10,
          ),
          Text('10 min ago'),
        ],
      ).addShimmer(context)
    ]);
  }
}

class RecommendationShimmer extends StatelessWidget {
  const RecommendationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingType6(
                title: LocalizationString.recommendedHashtags,
                subTitle: LocalizationString.recommendedHashtagsForYou,
                context: context),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return card();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  }),
            ),
          ],
        )).hP16;
  }

  Widget card() {
    return SizedBox(
      height: double.infinity,
      width: 125,
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          const Text(
            'Adam',
          ).vP4,
          SizedBox(
            height: 30,
            width: 90,
            child: BorderButtonType1(
              cornerRadius: 5,
              text: LocalizationString.follow,
              onPress: () {
                //followCallBack(LocalizationString.follow,index);
              },
            ),
          ).tP4
        ],
      ).vP8,
    );
  }
}

class ShimmerUsers extends StatelessWidget {
  const ShimmerUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  color: Colors.black54,
                ).round(10).addShimmer(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Adam',
                    ).bP4,
                    const Text(
                      'Canada',
                    )
                  ],
                ).lP16.addShimmer(context),
              ],
            ),
            SizedBox(
              height: 35,
              width: 110,
              child: BorderButtonType1(
                  text: LocalizationString.follow, onPress: () {}),
            ).addShimmer(context)
          ],
        );
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: 20,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.grey,
        ).round(5);
      },
    );
  }
}
