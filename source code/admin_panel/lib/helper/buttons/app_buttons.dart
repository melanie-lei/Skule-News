import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

//ignore: must_be_immutable
class FilledButtonType1 extends StatelessWidget {
  final String? text;
  final double? height;
  final double? width;
  final double? cornerRadius;
  bool? isEnabled;
  final Widget? leading;
  final Widget? trailing;
  final Color? enabledBackgroundColor;
  final Color? disabledBackgroundColor;

  final TextStyle? enabledTextStyle;
  final TextStyle? disabledTextStyle;

  final VoidCallback? onPress;

  FilledButtonType1({
    Key? key,
    required this.text,
    required this.onPress,
    this.height,
    this.width,
    this.cornerRadius,
    this.leading,
    this.trailing,
    this.enabledBackgroundColor,
    this.disabledBackgroundColor,
    this.enabledTextStyle,
    this.disabledTextStyle,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 50,
      color: isEnabled == true
          ? enabledBackgroundColor ?? Theme.of(context).primaryColor
          : disabledBackgroundColor ?? Theme.of(context).primaryColorDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading != null ? leading!.hP8 : Container(),
          Center(
            child: Text(
              text!,
              style: isEnabled == true
                  ? enabledTextStyle ?? AppTheme.configTheme.textTheme.bodyLarge
                  : disabledTextStyle ?? Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          trailing != null ? trailing!.hP4 : Container()
        ],
      ),
    ).round(cornerRadius ?? 5).ripple(() {
      isEnabled == true ? onPress!() : null;
    });
  }
}

class BorderButtonType1 extends StatelessWidget {
  final String? text;
  final VoidCallback? onPress;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? height;
  final double? cornerRadius;
  final TextStyle? textStyle;

  const BorderButtonType1(
      {Key? key,
      required this.text,
      required this.onPress,
      this.height,
      this.cornerRadius,
      this.borderColor,
      this.backgroundColor,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 50,
      color: backgroundColor,
      child: Center(
        child: Text(
          text!,
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
        ).hP16,
      ),
    )
        .borderWithRadius(
            value: 1,
            radius: cornerRadius ?? 5,
            color: borderColor ?? Theme.of(context).dividerColor,
            context: context)
        .ripple(onPress!);
  }
}
