// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:async';

class NPC {
  final String name;
  final String avatar;
  final String class_avatar;
  final String class_name;
  final String class_category;
  final String expansion;
  final String id;

  int rating = 10;

  NPC(
      {required this.name,
      required this.avatar,
      required this.class_avatar,
      required this.class_name,
      required this.class_category,
      required this.expansion,
      required this.id});

  factory NPC.fromJson(Map<String, dynamic> json) {
    return NPC(
        name: json['name'] as String,
        avatar: json['avatar'] as String,
        class_avatar: json['class_avatar'] as String,
        class_name: json['class_name'] as String,
        class_category: json['class_category'] as String,
        expansion: json['expansion'] as String,
        id: json['id'] as String);
  }
}
