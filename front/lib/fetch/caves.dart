import 'package:http/http.dart' as http;
import 'dart:convert';

class Cave {
  final String name;
  final int id;

  const Cave({
    required this.name,
    required this.id,
  });

  // factory Cave.fromJson(Map<String, dynamic> json) {
  //   return switch (json) {
  //     {
  //       'userId': int userId,
  //       'id': int id,
  //       'title': String title,
  //     } =>
  //       Album(
  //         userId: userId,
  //         id: id,
  //         title: title,
  //       ),
  //     _ => throw const FormatException('Failed to load album.'),
  //   };
  // }
}