import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? gender;
  final String? dob;
  final int? age;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.gender,
    this.dob,
    this.age,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int? age;

    // Handle age calculation safely
    if (json['bornDate'] != null && json['bornDate'].toString().isNotEmpty) {
      try {
        final dob = DateTime.parse(json['bornDate']);
        age = DateTime.now().difference(dob).inDays ~/ 365;
      } catch (e) {
        debugPrint('Date parsing error: $e');
      }
    }

    return User(
      id: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phoneNumber']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['bornDate']?.toString(),
      age: age,
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'email': email,
      'phoneNumber': phone,
      'gender': gender,
      'bornDate': dob,
      'age': age,
      'token': token,
    };
  }
}
