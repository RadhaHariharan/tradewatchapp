import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tradewatchapp/screens/stocks/controller/stocksController.dart';
import 'package:http/http.dart' as http;

class NewsController extends ChangeNotifier {
  bool isLoading = true;
  // Load all the news when the controller is initialized
  NewsController() {
    getAllNews();
  }

  late List<dynamic> news = [];

  // This function fetches the news from the API and assignes it to news variable
  Future<void> getAllNews() async {
    isLoading = true;
    notifyListeners();
    await http.get(Uri.parse("$url/news")).then((value) {
      final decodedData = jsonDecode(value.body);
      List<dynamic> data = decodedData['data'];
      news = data;
      isLoading = false;
      notifyListeners();
    });
  }
}
