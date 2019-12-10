import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/user_notification.dart';
import 'package:http/http.dart' as http;

import '../services/global.dart';

class UserNotificationService {
  Future<UserNotification> save(Map<String, dynamic> params) async {
    final response =
        await http.post(Uri.encodeFull(URL_USER_NOTIFICATION), body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToUserNotification(responseBody);
    } else {
      throw Exception(
          'Failed to save a UserNotification. Error: ${response.toString()}');
    }
  }

  Future<List<UserNotification>> fetchUserNotifications() async {
    final response = await http.Client().get(URL_USER_NOTIFICATION);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final userNotificationList = await users.map<UserNotification>((json) {
          return UserNotification.fromJson(json);
        }).toList();
        return userNotificationList;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load UserNotifications from the internet');
    }
  }

  Future<List<UserNotification>> fetchUserNotificationByUserEmail(String email) async {
    final response = await http.Client().get('$URL_USER_NOTIFICATION_BY_EMAIL$email');
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final users = mapResponse["data"].cast<Map<String, dynamic>>();
        final userNotificationList = await users.map<UserNotification>((json) {
          return UserNotification.fromJson(json);
        }).toList();
        return userNotificationList;
      } else {
        return [];
      }
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception('Failed to load UserNotifications from the internet');
    }
  }

  Future<UserNotification> update(Map<String, dynamic> params) async {
    final response =
        await http.Client().put('$URL_USER_NOTIFICATION/${params["id"]}', body: params);
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToUserNotification(responseBody);
    } else {
      throw Exception(
          'Failed to update a UserNotification. Error: ${response.toString()}');
    }
  }

  Future<bool> delete(int id) async {
    final response = await http.Client().delete('$URL_USER_NOTIFICATION/$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      if (responseBody["result"] == "ok") {
        return true;
      }
    } else {
      throw Exception(
          'Failed to delete a UserNotification. Error: ${response.toString()}');
    }
  }

  UserNotification convertResponseToUserNotification(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }
    return UserNotification(
      id: json["data"]["id"],
      title: json["data"]["title"],
      message: json["data"]["message"],
      useremail: json["data"]["useremail"],
      created_at: DateTime.parse(json["data"]["created_at"]),
    );
  }
}