import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final SubscriptionPackageController packageController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageController.initiate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: FractionalOffset.topRight,
                startAngle: 1,
                endAngle: 4,
                colors: <Color>[
                  Theme.of(context).primaryColor.withOpacity(0.7),
                  Theme.of(context).backgroundColor.withOpacity(0.7),
                ],
                stops: const <double>[0.0, 0.5],
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationString.restore,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ).ripple(() {
                    packageController.restorePurchase();
                  }),
                  const ThemeIconWidget(
                    ThemeIcon.closeCircle,
                    size: 25,
                    color: Colors.white,
                  ).ripple(() {
                    Get.back();
                  })
                ],
              ).hP16,
              const Spacer(),
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const ThemeIconWidget(
                    ThemeIcon.diamond,
                    size: 200,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(LocalizationString.premiumAccess.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(LocalizationString.accessToAllBlogs,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<SubscriptionPackageController>(
                      init: packageController,
                      builder: (ctx) {
                        return packageController.package.value != null
                            ? PackageTile(
                                package: packageController.package.value!)
                            : Container();
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LocalizationString.termsOfUse,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700)),
                      Text(' ${LocalizationString.and.toLowerCase()} ',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(LocalizationString.privacyPolicy,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ).hP16,
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
