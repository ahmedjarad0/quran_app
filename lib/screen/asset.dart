import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/ayah.dart';

class Asset {
  Future<List<List<Ayah>>> fetchData() async {
    List<List<Ayah>>? pageAyah = [];

    String result = await rootBundle.loadString('assets/hafs_smart_v8.json');
    if (result.isNotEmpty) {
      List<dynamic> ayahs = jsonDecode(result);
      for (int i = 1; i <= 604; i++) {
        List<Ayah> temp = [];
        ayahs.forEach((element) {
          if (element['page'] == i) {
            temp.add(Ayah.fromJson(element));
          }
        });
        pageAyah.add(temp);
      }
      return pageAyah;
    }
    return Future.error('Something error ,try again');
  }
}
