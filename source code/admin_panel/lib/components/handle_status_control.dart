import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

//ignore: must_be_immutable
class HandleAvailabilityStatus extends StatefulWidget {
  AvailabilityStatus status;
  final Function(AvailabilityStatus) statusHandler;

  HandleAvailabilityStatus(
      {Key? key, required this.status, required this.statusHandler})
      : super(key: key);

  @override
  _HandleAvailabilityStatusState createState() =>
      _HandleAvailabilityStatusState();
}

class _HandleAvailabilityStatusState extends State<HandleAvailabilityStatus> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          LocalizationString.activate,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          width: 10,
        ),
        widget.status == AvailabilityStatus.active
            ? ThemeIconWidget(
                ThemeIcon.checkMarkWithCircle,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              )
            : ThemeIconWidget(
                ThemeIcon.outlinedCircle,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ).ripple(() {
                widget.status = AvailabilityStatus.active;
                widget.statusHandler(AvailabilityStatus.active);
                setState(() {});
              }),
        const SizedBox(
          width: 50,
        ),
        Text(
          LocalizationString.deactivated,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          width: 10,
        ),
        widget.status == AvailabilityStatus.deactivated
            ? ThemeIconWidget(
                ThemeIcon.checkMarkWithCircle,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              )
            : ThemeIconWidget(
                ThemeIcon.outlinedCircle,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ).ripple(() {
                widget.status = AvailabilityStatus.deactivated;
                widget.statusHandler(AvailabilityStatus.deactivated);

                setState(() {});
              })
      ],
    );
  }
}
