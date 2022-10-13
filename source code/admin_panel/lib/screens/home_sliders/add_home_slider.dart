// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:skule_news_admin_panel/helper/common_import.dart';
//
// class AddNewBanner extends StatefulWidget {
//   final BannerModel? banner;
//
//   const AddNewBanner({Key? key, this.banner}) : super(key: key);
//
//   @override
//   _AddNewBannerState createState() => _AddNewBannerState();
// }
//
// class _AddNewBannerState extends State<AddNewBanner> {
//   TextEditingController name = TextEditingController();
//   TextEditingController bannerCover = TextEditingController();
//
//   Uint8List? fileBytes;
//   String? selectedFilePath;
//
//   int sliderType = 1;
//   FirebaseManager manager = FirebaseManager();
//   AvailabilityStatus availabilityStatus = AvailabilityStatus.active;
//
//   WallpaperModel? selectedSong;
//   RingtoneModel? selectedRingtone;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     if (widget.banner != null) {
//       bannerCover.text = widget.banner?.image ?? '';
//       name.text = widget.banner?.name ?? '';
//       availabilityStatus = widget.banner?.status == 0
//           ? AvailabilityStatus.deactivated
//           : AvailabilityStatus.active;
//
//       sliderType = widget.banner?.type ?? 1;
//     }
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.singleton.primaryBackgroundColor,
//       appBar: widget.banner != null
//           ? BackNavigationBar(title: LocalizationString.back)
//           : null,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TitleBar(title: LocalizationString.addHomeSlider),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             LocalizationString.selectSliderType,
//             style: TextStyles.body.lightColor,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           sliderTypeWidget().vP8,
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             LocalizationString.sliderImage,
//             style: TextStyles.body.lightColor,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: InputField(
//                   controller: bannerCover,
//                   showBorder: true,
//                   cornerRadius: 5,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               SizedBox(
//                 height: 50,
//                 width: 120,
//                 child: FilledButtonType1(
//                     text: LocalizationString.choose,
//                     onPress: () {
//                       pickFile();
//                     }),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           homeSliderActionView(),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(LocalizationString.sliderName,
//               style: TextStyles.body.lightColor),
//           const SizedBox(
//             height: 10,
//           ),
//           InputField(
//             controller: name,
//             showBorder: true,
//             cornerRadius: 5,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           HandleAvailabilityStatus(
//               status: availabilityStatus,
//               statusHandler: (status) {
//                 availabilityStatus = status;
//                 setState(() {});
//               }).vP8,
//           const SizedBox(
//             height: 40,
//           ),
//           Center(
//             child: SizedBox(
//                 width: 150,
//                 height: 50,
//                 child: FilledButtonType1(
//                     text: LocalizationString.submit,
//                     onPress: () {
//                       submitNewBanner();
//                     })),
//           )
//         ],
//       ).p25,
//     );
//   }
//
//   pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'jpeg'],
//     );
//
//     if (result != null) {
//       PlatformFile pFile = result.files.first;
//
//       fileBytes = pFile.bytes!;
//       bannerCover.text = pFile.name;
//
//       setState(() {});
//     } else {
//       // User canceled the picker
//     }
//   }
//
//   Widget sliderTypeWidget() {
//     return Row(
//       children: [
//         Text(
//           LocalizationString.wallpaper,
//           style: TextStyles.body.lightColor,
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         sliderType == 1
//             ? ThemeIconWidget(
//                 ThemeIcon.checkMarkWithCircle,
//                 color: AppTheme.singleton.lightColor,
//                 size: 20,
//               )
//             : ThemeIconWidget(
//                 ThemeIcon.outlinedCircle,
//                 color: AppTheme.singleton.lightColor,
//                 size: 20,
//               ).ripple(() {
//                 sliderType = 1;
//                 selectedRingtone = null;
//                 setState(() {});
//               }),
//         const SizedBox(
//           width: 50,
//         ),
//         Text(
//           LocalizationString.ringtone,
//           style: TextStyles.body.lightColor,
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         sliderType == 2
//             ? ThemeIconWidget(
//                 ThemeIcon.checkMarkWithCircle,
//                 color: AppTheme.singleton.lightColor,
//                 size: 20,
//               )
//             : ThemeIconWidget(
//                 ThemeIcon.outlinedCircle,
//                 color: AppTheme.singleton.lightColor,
//                 size: 20,
//               ).ripple(() {
//                 sliderType = 2;
//                 selectedSong = null;
//                 setState(() {});
//               }),
//         const SizedBox(
//           width: 50,
//         ),
//       ],
//     );
//   }
//
//   Widget homeSliderActionView() {
//     return sliderType == 1
//         ? SizedBox(
//             height: 80,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(LocalizationString.selectWallpaper,
//                     style: TextStyles.body.lightColor),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: DropdownFiled(
//                       isDisabled: true,
//                       text: selectedSong?.name ?? '',
//                       showBorder: true,
//                       cornerRadius: 5,
//                       onPress: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => SelectWallpaper(
//                             allowMultiSelect: false,
//                             selectedSongs:
//                                 selectedSong == null ? [] : [selectedSong!],
//                             addedCallback: (songs) {
//                               selectedSong = songs.first;
//                               setState(() {});
//                             },
//                           ),
//                         );
//                       }),
//                 ),
//               ],
//             ))
//         : SizedBox(
//             height: 80,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(LocalizationString.selectRingtone,
//                     style: TextStyles.body.lightColor),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: DropdownFiled(
//                       isDisabled: true,
//                       text: selectedRingtone?.name ?? '',
//                       showBorder: true,
//                       cornerRadius: 5,
//                       onPress: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => SelectRingtone(
//                             callback: (playlist) {
//                               selectedRingtone = playlist;
//                               setState(() {});
//                             },
//                           ),
//                         );
//                       }),
//                 ),
//               ],
//             ),
//           );
//   }
//
//   submitNewBanner() async {
//     if (fileBytes == null && widget.banner?.image == null) {
//       showMessage(LocalizationString.pleaseUploadImage, true);
//       return;
//     } else if (name.text.isEmpty) {
//       showMessage(LocalizationString.pleaseEnterSliderName, true);
//       return;
//     } else if (selectedSong == null && sliderType == 1) {
//       showMessage(LocalizationString.pleaseSelectWallpaper, true);
//       return;
//     } else if (selectedRingtone == null && sliderType == 2) {
//       showMessage(LocalizationString.pleaseSelectRingtone, true);
//       return;
//     }
//     EasyLoading.show(status: LocalizationString.loading);
//
//     var bannerId = widget.banner?.id ?? getRandString(25);
//     var coverPath = widget.banner?.image ?? '';
//
//     if (fileBytes != null) {
//       coverPath = await uploadImage(bannerId);
//     } else {
//       coverPath = widget.banner?.image ?? '';
//     }
//
//     manager
//         .insertNewHomeSlider(
//             slider: widget.banner,
//             id: bannerId,
//             itemId: sliderType == 1 ? selectedSong!.id : selectedRingtone!.id,
//             type: sliderType,
//             name: name.text,
//             image: coverPath,
//             status: availabilityStatus)
//         .then((response) {
//       EasyLoading.dismiss();
//       if (response.status == true) {
//         name.text = '';
//         fileBytes = null;
//         bannerCover.text = '';
//         setState(() {});
//
//         showMessage(
//             widget.banner == null
//                 ? LocalizationString.sliderAdded
//                 : LocalizationString.sliderUpdated,
//             true);
//       } else {
//         showMessage(response.message ?? '', true);
//       }
//     });
//   }
//
//   Future<String> uploadImage(String sliderId) async {
//     String coverPath = '';
//     await manager
//         .uploadHomeSliderImage(
//             uniqueId: sliderId, bytes: fileBytes!, fileName: bannerCover.text)
//         .then((imagePath) {
//       coverPath = imagePath;
//     });
//
//     return coverPath;
//   }
//
//   showMessage(String message, bool isError) {
//     GFToast.showToast(message, context,
//         toastPosition: GFToastPosition.BOTTOM,
//         textStyle: TextStyles.body,
//         backgroundColor:
//             isError == true ? AppTheme().redColor : AppTheme().lightGreen,
//         trailing: Icon(
//             isError == true ? Icons.error : Icons.check_circle_outline,
//             color: AppTheme().lightColor));
//   }
// }
