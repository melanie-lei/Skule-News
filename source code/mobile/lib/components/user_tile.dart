import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class UserTile extends StatelessWidget {
  final UserModel profile;
  final VoidCallback onItemCallback;
  final VoidCallback followCallback;

  const UserTile(
      {Key? key,
        required this.profile,
        required this.onItemCallback,
        required this.followCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: profile.image ?? AppConfig.dummyProfilePictureUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 40,
              width: 40,
            ).circular,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ).bP4,
                  Text(
                    profile.bio ?? '',
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ).hP16,
            ),
            // const Spacer(),
            const SizedBox(
              height: 40,
              width: 50,
              child: ThemeIconWidget(ThemeIcon.nextArrow),
            ).borderWithRadius(value: 0.2, radius: 20,context: context)
          ],
        ).p16.ripple(() {
          onItemCallback();
        }),
        Container(
          height: 60,
          color: Theme.of(context).dividerColor.withOpacity(0.05),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '25',
                    style: Theme.of(context).textTheme.bodySmall,
                  ).bP4,
                  Text(
                    LocalizationString.posts,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ).hP16,
              const Spacer(),
              SizedBox(
                height: 35,
                width: 100,
                child: BorderButtonType1(
                  // icon: ThemeIcon.message,
                    text: LocalizationString.follow,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    onPress: () {
                      followCallback();
                    }),
              ).rP16
            ],
          ),
        ).tP8
      ],
    ).shadowWithBorder(
        borderWidth: 0.5,
        radius: 5,
        fillColor: Theme.of(context).backgroundColor,
        borderColor: Theme.of(context).primaryColorLight,context: context);
  }
}
