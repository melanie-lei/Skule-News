import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/theme/theme.dart';
import 'package:music_streaming_mobile/theme/text_styles.dart';
import 'package:music_streaming_mobile/theme/extention.dart';

class SocalIcon extends StatelessWidget {
  final String? icon;
  final String? text;
  final VoidCallback? onPress;
  final double? height;
  final Color? borderColor;
  final Color? backgroundColor;

  const SocalIcon({
    Key? key,

    this.text,
    this.borderColor,
    this.backgroundColor,
    required this.icon,
    required this.onPress,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: borderColor != null
            ? Border.all(width: 1, color: borderColor!)
            : null,
        borderRadius: const BorderRadius.all (
             Radius.circular(5) //
            ),
        color: backgroundColor
      ),
      height: height ?? 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon!,
              color: Theme.of(context).primaryColorDark,
              height: 18,
            ),
            text != null
                ? Text(
                    text!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ).vP8.lP8
                : Container(
                    width: 0,
                  )
          ],
        ),
      ),
    ).ripple(onPress!);
  }
}
