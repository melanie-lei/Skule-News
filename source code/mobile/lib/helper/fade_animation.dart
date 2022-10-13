import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/pub_imports.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(Key? key, this.delay, this.child) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(AniProps.opacity, 0.0.tweenTo(1.0),
              duration: Duration(milliseconds: 500))
          .thenTween(AniProps.translateY, (-30.0).tweenTo(0.0),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    /*
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);*/

    return PlayAnimationBuilder<Movie>(
        delay: Duration(milliseconds: (500 * delay).round()),
        duration: tween.duration,
        tween: tween,
        child: child,
        builder: (context, value, child) {
          return Opacity(
            opacity: value.get(AniProps.opacity),
            child: Transform.translate(
                offset: Offset(0, value.get(AniProps.translateY)),
                child: child),
          );
        });
  }
}
