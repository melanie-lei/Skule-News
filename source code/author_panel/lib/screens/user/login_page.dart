// import 'package:flutter/material.dart';
// import 'package:skule_news_admin_panel/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final LoginController loginController = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double heightSize = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor.darken(),
//       body: Center(
//         child: Container(
//           width: Responsive.isMobile(context)
//               ? MediaQuery.of(context).size.width * 0.8
//               : MediaQuery.of(context).size.width * 0.35,
//           height: 500,
//           color: Theme.of(context).backgroundColor,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 AppConfig.projectName,
//                 style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.w900),
//               ),
//               Text(AppConfig.projectTagline,
//                   style: Theme.of(context).textTheme.titleSmall!),
//               const SizedBox(
//                 height: 50,
//               ),
//               Obx(() => InputField(
//                     controller: loginController.userName.value,
//                     hintText: LocalizationString.userName,
//                     icon: ThemeIcon.email,
//                     showBorder: true,
//                     cornerRadius: 5,
//                   )),
//               const SizedBox(
//                 height: 20,
//               ),
//               Obx(() => PasswordField(
//                     controller: loginController.password.value,
//                     hintText: LocalizationString.password,
//                     icon: ThemeIcon.lock,
//                     cornerRadius: 5,
//                     showBorder: true,
//                     onChanged: (text) {},
//                   )),
//               const SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   Text(
//                     LocalizationString.forgotPwd,
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ).ripple(() {
//                     showForgotPasswordPopup();
//                   }),
//                   const Spacer(),
//                   SizedBox(
//                       height: 50,
//                       width: 120,
//                       child: FilledButtonType1(
//                           text: LocalizationString.login,
//                           enabledTextStyle:
//                               Theme.of(context).textTheme.titleMedium,
//                           onPress: () {
//                             loginController.loginUser();
//                           }))
//                 ],
//               )
//             ],
//           ).hp(Responsive.isDesktop(context) ? 100 : 20),
//         ).shadow(context: context).p(Responsive.isDesktop(context) ? 100 : 20),
//       ),
//     );
//   }
//
//   showForgotPasswordPopup() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(
//               LocalizationString.resetPwd,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge!
//                   .copyWith(color: Theme.of(context).primaryColor),
//             ),
//             content: TextField(
//               onChanged: (value) {
//                 loginController.setEmail(value);
//               },
//               controller: loginController.email.value,
//               decoration: const InputDecoration(hintText: "admin@gmail.com"),
//             ),
//             actions: <Widget>[
//               SizedBox(
//                   height: 50,
//                   width: 120,
//                   child: FilledButtonType1(
//                       text: LocalizationString.cancel,
//                       onPress: () {
//                         Navigator.pop(context);
//                       })),
//               SizedBox(
//                   height: 50,
//                   width: 120,
//                   child: FilledButtonType1(
//                       text: LocalizationString.submit,
//                       onPress: () {
//                         loginController.resetPassword();
//                       }))
//             ],
//           );
//         });
//   }
// }
