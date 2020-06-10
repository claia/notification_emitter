// To parse this JSON data, do
//
//     final faculties = facultiesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Faculties> facultiesFromJson(String str) =>
    List<Faculties>.from(json.decode(str).map((x) => Faculties.fromMap(x)));

String facultiesToJson(List<Faculties> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Faculties {
  final int id;
  final String name;

  Faculties({
    @required this.id,
    @required this.name,
  });

  factory Faculties.fromMap(Map<String, dynamic> json) => Faculties(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
