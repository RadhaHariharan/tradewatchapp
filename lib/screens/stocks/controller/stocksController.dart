import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// udpate the IP with the IP of the system running the index.js in server folder
String url = "http://192.168.1.13:3000";

class StocksController extends ChangeNotifier {
  final List<dynamic> _stocks = [];
  late Timer timerCall;
  bool isStocksLoading = true;
  late int lastReloadedTimeStamp = DateTime.now().millisecondsSinceEpoch;

  List<dynamic> get stocks => _stocks;

  StocksController() {
    getAllStocksData();
  }

  Map<String, dynamic>? selectedStock;

  // This funtion is responsible for getting stocks data from the API
  // There is also an timer which will update the stock price in every 15 seconds
  getAllStocksData() async {
    isStocksLoading = true;
    notifyListeners();
    _stocks.clear();
    await http.get(Uri.parse("$url/stockPrice")).then((value) {
      final decodedData = jsonDecode(value.body);
      Map<String, dynamic> data = decodedData['data'];
      data.forEach((key, value) {
        _stocks.add(value['price']);
      });
      lastReloadedTimeStamp = DateTime.now().millisecondsSinceEpoch;
      isStocksLoading = false;
    });
    notifyListeners();
    timerCall = Timer.periodic(const Duration(seconds: 15), (Timer time) async {
      await http.get(Uri.parse("$url/stockPrice")).then((value) {
        _stocks.clear();
        final decodedData = jsonDecode(value.body);
        Map<String, dynamic> data = decodedData['data'];
        data.forEach((key, value) {
          _stocks.add(value['price']);
        });
        lastReloadedTimeStamp = DateTime.now().millisecondsSinceEpoch;
        for (var element in _stocks) {
          if (selectedStock != null) {
            if (element['symbol'] == selectedStock!["symbol"]) {
              selectedStock = element;
            }
          }
        }
        isStocksLoading = false;
      });
      notifyListeners();
    });
  }

  // This function will cancel the timer on refresh page to get new data
  void cancelTimer() {
    if (timerCall.isActive) {
      timerCall.cancel();
    }
  }

  // This function is trigerred when we click on a stock to go into the details page
  void selectStock(int index) {
    selectedStock = _stocks[index];
    getChartData();
    notifyListeners();
  }

  String selectedDuration = "W";

  // This function is used to get the chart data for duration like W - week, M - month
  void changeSelectedDuration(String val) {
    selectedDuration = val;
    notifyListeners();
    getChartData();
  }

  late List<Map<String, dynamic>> chartData = [];
  late double minValue;
  late double maxValue;
  bool loadedStockChart = false;

  // This function will get the details for the selected stock to show the chart in the UI
  getChartData() async {
    loadedStockChart = false;
    notifyListeners();
    String stockSymbol = selectedStock!["symbol"];
    String startDate = "";
    String endDate = '';
    if (selectedDuration == "M") {
      DateTime monthReduce = DateTime.now().subtract(const Duration(days: 28));
      startDate =
          "${monthReduce.year}-${monthReduce.month < 10 ? '0${monthReduce.month}' : monthReduce.month.toString()}-${monthReduce.day < 10 ? '0${monthReduce.day}' : monthReduce.day.toString()}";
      endDate =
          "${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month.toString()}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day.toString()}";
    }
    if (selectedDuration == "W") {
      DateTime weekReduce = DateTime.now().subtract(const Duration(days: 7));
      startDate =
          "${weekReduce.year}-${weekReduce.month < 10 ? '0${weekReduce.month}' : weekReduce.month.toString()}-${weekReduce.day < 10 ? '0${weekReduce.day}' : weekReduce.day.toString()}";
      endDate =
          "${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month.toString()}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day.toString()}";
    }

    log("$url/stocks/?startDate=$startDate&endDate=$endDate&stock=$stockSymbol");
    await http
        .get(Uri.parse(
            "$url/stocks/?startDate=$startDate&endDate=$endDate&stock=$stockSymbol"))
        .then((value) {
      final decodedData = jsonDecode(value.body);
      chartData.clear();
      decodedData['data'].forEach((data) {
        chartData.add(data);
      });
      maxValue = decodedData['maxValue'].toDouble();
      minValue = decodedData['minValue'].toDouble();
      loadedStockChart = true;
      notifyListeners();
    });
  }
}
