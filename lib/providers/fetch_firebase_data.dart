import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../modules/donors.dart';
import '../private_data.dart';

class FetchFirebaseData with ChangeNotifier {
  static const List<String> _bloodGroups = [
    "A +",
    "A -",
    "B +",
    "B -",
    "AB +",
    "AB -",
    "O +",
    "O -",
  ];

  final List<Map<String, dynamic>> _donorByBloodGrp = [];

  List<Donor>? _donors;

  List<Donor>? get donors => _donors;

  Future<List<Map<String, dynamic>>?> getBloodGroups() async {
    final data = await http.get(Uri.parse('$firebaseUrl/users/donors.json'));
    final jsonData = json.decode(data.body) as Map<String, dynamic>;

    final jsonValues = jsonData.values.toList();
    _donorByBloodGrp.clear();
    for (var bloodGrp in _bloodGroups) {
      final value = jsonValues
          .where((element) => element["blood_type"] == bloodGrp)
          .toList();
      final mapData = {
        "title": bloodGrp,
        "donors": value.length.toString(),
        "quantity": (value.length * 0.350).toStringAsFixed(2),
        "data": value,
      };
      _donorByBloodGrp.add(mapData);
    }
    return _donorByBloodGrp;
  }
}
