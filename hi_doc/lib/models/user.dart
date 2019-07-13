import 'package:flutter/material.dart';

class User {
  final String firstName;
  final String lastName;
  final String otherName;
  final int age;
  final String image;
  final String id;
  final String userId;
  final String token;
  final String profession;
  final String experience;
  final String shortDescription;
  final String address;
  final String email;
  final bool isFavoriteHp;
  final bool isFavoriteClient;
  final bool isHealthProfessional;
  // final List<String> healthProfessionalsId;

  User({
    @required this.firstName,
    @required this.lastName,
    @required this.age,
    this.image,
    this.token,
    this.otherName,
    @required this.id,
    @required this.userId,
    this.profession,
    this.address,
    @required this.email,
    this.shortDescription,
    this.experience,
    this.isFavoriteHp = false,
    this.isFavoriteClient = false,
    @required this.isHealthProfessional,
    // this.healthProfessionalsId,
  });
}
