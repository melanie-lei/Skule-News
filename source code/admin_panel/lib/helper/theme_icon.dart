import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class ThemeIconWidget extends StatelessWidget {
  final ThemeIcon icon;
  final double? size;
  final Color? color;

  const ThemeIconWidget(this.icon, {Key? key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getIcon(context);
  }

  Widget getIcon(BuildContext context) {
    switch (icon) {
      case ThemeIcon.smsFailed:
        return Icon(
          Icons.sms_failed,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.home:
        return Icon(
          Icons.home_max_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.home1:
        return Icon(
          Icons.home_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.cart:
        return Icon(
          Icons.shopping_cart_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.setting:
        return Icon(
          Icons.settings_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.search:
        return Icon(
          Icons.search,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.downArrow:
        return Icon(
          Icons.keyboard_arrow_down,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.upArrow:
        return Icon(
          Icons.keyboard_arrow_up,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.star:
        return Icon(
          Icons.star_border,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.checkMark:
        return Icon(
          Icons.check,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.edit:
        return Icon(
          Icons.edit_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.filterIcon:
        return Icon(
          Icons.filter_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.sort:
        return Icon(
          Icons.sort,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.logout:
        return Icon(
          Icons.logout_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.review:
        return Icon(
          Icons.library_books_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.circle:
        return Icon(
          Icons.circle,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.outlinedCircle:
        return Icon(
          Icons.circle_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.fav:
        return Icon(
          Icons.favorite_border_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.favFilled:
        return Icon(
          Icons.favorite,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.close:
        return Icon(
          Icons.close,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.checkMarkWithCircle:
        return Icon(
          Icons.check_circle_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.security:
        return Icon(
          Icons.security,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.bike:
        return Icon(
          Icons.delivery_dining_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.clock:
        return Icon(
          Icons.timer,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.offer:
        return Icon(
          Icons.local_offer_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.orders:
        return Icon(
          Icons.list_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.account:
        return Icon(
          Icons.person_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.privacyPolicy:
        return Icon(
          Icons.policy_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.info:
        return Icon(
          Icons.info,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.terms:
        return Icon(
          Icons.verified_user_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.add:
        return Icon(
          Icons.add,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.addCircle:
        return Icon(
          Icons.add_circle,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.selectedRadio:
        return Icon(
          Icons.radio_button_checked,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.unSelectedRadio:
        return Icon(
          Icons.radio_button_off_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.more:
        return Icon(
          Icons.more_horiz,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.wallet:
        return Icon(
          Icons.account_balance_wallet,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.dashboard:
        return Icon(
          Icons.dashboard,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.nextArrow:
        return Icon(
          Icons.arrow_forward_ios_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.backArrow:
        return Icon(
          Icons.arrow_back_ios,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.menuIcon:
        return Icon(
          Icons.menu,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.password:
        return Icon(
          Icons.password_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.email:
        return Icon(
          Icons.email_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.reveal:
        return Icon(
          Icons.visibility_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.hide:
        return Icon(
          Icons.visibility_off_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.mobile:
        return Icon(
          Icons.phone_enabled_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.name:
        return Icon(
          Icons.person_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.notification:
        return Icon(
          Icons.notifications_none,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.discount:
        return Icon(
          Icons.local_offer_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.share:
        return Icon(
          Icons.share_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.addressType:
        return Icon(
          Icons.location_city_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.plus:
        return Icon(
          Icons.add,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.minus:
        return Icon(
          Icons.remove,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.addressPin:
        return Icon(
          Icons.location_on_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.avatar:
        return Icon(
          Icons.person_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.card:
        return Icon(
          Icons.credit_card,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.thumbsUp:
        return Icon(
          Icons.thumb_up_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.mic:
        return Icon(
          Icons.mic_none_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.book:
        return Icon(
          Icons.library_books_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.helpHand:
        return Icon(
          Icons.live_help_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.about:
        return Icon(
          Icons.info_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.play:
        return Icon(
          Icons.play_circle_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.music:
        return Icon(
          Icons.library_music,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.deletedMusic:
        return Icon(
          Icons.desktop_access_disabled,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.addMusic:
        return Icon(
          Icons.music_note_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.playlists:
        return Icon(
          Icons.featured_play_list_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.addPlaylists:
        return Icon(
          Icons.playlist_add_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.userPlaylists:
        return Icon(
          Icons.playlist_add_check_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.deletedPlaylists:
        return Icon(
          Icons.grid_off,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.delete:
        return Icon(
          Icons.delete_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.message:
        return Icon(
          Icons.message_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.closeCircle:
        return Icon(
          Icons.highlight_remove_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.bathTub:
        return Icon(
          Icons.bathtub_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.bed:
        return Icon(
          Icons.bed_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.area:
        return Icon(
          Icons.calculate_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.send:
        return Icon(
          Icons.send,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.bookMark:
        return Icon(
          Icons.bookmark_border_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.buildings:
        return Icon(
          Icons.home_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.map:
        return Icon(
          Icons.map_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.news:
        return Icon(
          Icons.list_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.whatsapp:
        return Icon(
          Icons.message_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.report:
        return Icon(
          Icons.report_problem_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.explore:
        return Icon(
          Icons.explore_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.block:
        return Icon(
          Icons.block,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.categories:
        return Icon(
          Icons.category_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.moreVertical:
        return Icon(
          Icons.more_vert_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.camera:
        return Icon(
          Icons.camera_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.video:
        return Icon(
          Icons.video_call_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.speaker:
        return Icon(
          Icons.volume_down_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.startChat:
        return Icon(
          Icons.add_circle_outline_sharp,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.calendar:
        return Icon(
          Icons.calendar_today_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.userGroup:
        return Icon(
          Icons.supervisor_account_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.deletedUserGroup:
        return Icon(
          Icons.person_remove_alt_1_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.verified:
        return Icon(
          Icons.verified,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.headset:
        return Icon(
          Icons.headset_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.addUser:
        return Icon(
          Icons.person_add_alt_1_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.filledCheckMark:
        return Icon(
          Icons.check_circle,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.unfilledCheckmark:
        return Icon(
          Icons.circle_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.folder:
        return Icon(
          Icons.folder_open,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.lock:
        return Icon(
          Icons.lock,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.public:
        return Icon(
          Icons.public,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.album:
        return Icon(
          Icons.queue_music_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.deactivatedBlog:
        return Icon(
          Icons.folder_off_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.addAlbum:
        return Icon(
          Icons.add,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.language:
        return Icon(
          Icons.language_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.featured:
        return Icon(
          Icons.bookmark,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.author:
        return Icon(
          Icons.account_box_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.packages:
        return Icon(
          Icons.backpack_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.noData:
        return Icon(
          Icons.no_backpack,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.pending:
        return Icon(
          Icons.pending_actions,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
    }
  }
}
