import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationHelper {
  static String cfmKey =
      'key=AAAAbfo6JLA:APA91bGivM2NROvYJqEFQoDgmhCHRjUcP3LgaEyTXMMxLIEzqDjaoQX_j2pIPk0X8oy00QB64mQ6R-kOzD_lnZ3bVkX8QXw3wsDNMfGBF4x_3mBjp1ILWFllbf8hI_nWBwfJBEEHvZfL';

  static void pushNotification(String token, BlogPostModel model) async {
    try {
//Send  Message
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': cfmKey,
              },
              body: jsonEncode(
                <String, dynamic>{
                  'notification': <String, dynamic>{
                    'body':
                        "A new article, \"${model.title}\", has been posted by ${model.authorName}",
                    'title': "New Article!",
                    'alert': true,
                    'sound': 'default'
                  },
                  'android': {'priority': 'high'},
                  'priority': 10,
                  'to': token,
                  'apns': {
                    'headers': {"apns-priority": '10'}
                  },
                  'webpush': {
                    'headers': {'Urgency': "high"}
                  },
                },
              ));
      print("status: ${response.statusCode} | Message Sent Successfully!");
    } catch (e) {
      print("error push notification $e");
    }
  }

  static void pushAlert(String title, String message) async {
    try {
//Send  Message
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': cfmKey,
              },
              body: jsonEncode(
                <String, dynamic>{
                  'notification': <String, dynamic>{
                    'body': message,
                    'title': title,
                    'alert': true,
                    'sound': 'default'
                  },
                  'android': {'priority': 'high'},
                  'priority': 10,
                  'to': "/topics/all",
                  'apns': {
                    'headers': {"apns-priority": '10'}
                  },
                  'webpush': {
                    'headers': {'Urgency': "high"}
                  },
                },
              ));
      print("status: ${response.statusCode} | Message Sent Successfully!");
    } catch (e) {
      print("error push notification $e");
    }
  }
}
