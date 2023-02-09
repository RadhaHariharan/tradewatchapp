import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tradewatchapp/common/extensions.dart';
import 'package:tradewatchapp/screens/stocks/controller/stocksController.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// This widget is responsible for showing details of the selected stock
class StockDetailsScreen extends StatelessWidget {
  static const routeName = '/stockDetails';
  const StockDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stockCtrlWatch = context.watch<StocksController>();
    final selectedStock = stockCtrlWatch.selectedStock;
    var minValue = 0.0;
    var maxValue = 0.0;
    List<Map<String, dynamic>> chartData = [];
    if (stockCtrlWatch.loadedStockChart) {
      minValue = stockCtrlWatch.minValue;
      maxValue = stockCtrlWatch.maxValue;
      chartData = stockCtrlWatch.chartData;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          selectedStock!['longName'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 5.50.sp,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1.0.wp, vertical: 0.10.hp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedStock['longName'],
                style: TextStyle(
                  fontSize: 4.50.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                selectedStock['currencySymbol'] +
                    " " +
                    selectedStock['regularMarketPrice'].toString(),
                style: TextStyle(
                  fontSize: 3.50.sp,
                ),
              ),
              SizedBox(height: 1.0.hp),
              Expanded(
                child: stockCtrlWatch.loadedStockChart
                    ? Container(
                        child: SfCartesianChart(
                          series: <CandleSeries>[
                            CandleSeries<Map<String, dynamic>, DateTime>(
                              dataSource: chartData,
                              xValueMapper: (Map<String, dynamic> data, _) =>
                                  DateTime.parse(data["date"]),
                              lowValueMapper: (Map<String, dynamic> data, _) =>
                                  data["low"],
                              highValueMapper: (Map<String, dynamic> data, _) =>
                                  data["high"],
                              openValueMapper: (Map<String, dynamic> data, _) =>
                                  data["open"],
                              closeValueMapper:
                                  (Map<String, dynamic> data, _) =>
                                      data["close"],
                            ),
                          ],
                          primaryXAxis: DateTimeAxis(
                            minimum: stockCtrlWatch.selectedDuration == "D"
                                ? DateTime.now()
                                    .subtract(const Duration(days: 1))
                                : stockCtrlWatch.selectedDuration == "M"
                                    ? DateTime.now()
                                        .subtract(const Duration(days: 28))
                                    : DateTime.now()
                                        .subtract(const Duration(days: 7)),
                            maximum: DateTime.now(),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: minValue - 10,
                            maximum: maxValue + 10,
                            interval: 1,
                            numberFormat: NumberFormat.simpleCurrency(
                              decimalDigits: 0,
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              SizedBox(height: 1.0.hp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      stockCtrlWatch.changeSelectedDuration("W");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.0.wp,
                        vertical: 0.24.hp,
                      ),
                      decoration: BoxDecoration(
                        color: stockCtrlWatch.selectedDuration == "W"
                            ? Colors.green
                            : null,
                        borderRadius: BorderRadius.circular(1.0.wp),
                        border: Border.all(
                          color: Colors.green,
                          width: 0.10.wp,
                        ),
                      ),
                      child: Text(
                        "1W",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: stockCtrlWatch.selectedDuration == "W"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      stockCtrlWatch.changeSelectedDuration("M");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.0.wp,
                        vertical: 0.24.hp,
                      ),
                      decoration: BoxDecoration(
                        color: stockCtrlWatch.selectedDuration == "M"
                            ? Colors.green
                            : null,
                        borderRadius: BorderRadius.circular(1.0.wp),
                        border: Border.all(
                          color: Colors.green,
                          width: 0.10.wp,
                        ),
                      ),
                      child: Text(
                        "1M",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: stockCtrlWatch.selectedDuration == "M"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.0.hp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's volume",
                        style: TextStyle(
                          fontSize: 4.0.sp,
                        ),
                      ),
                      Text(
                        selectedStock['regularMarketVolume'].toString(),
                        style: TextStyle(
                          fontSize: 4.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 12.0.wp,
                    height: 2.0.hp,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(1.0.wp),
                    ),
                    child: Center(
                      child: Text(
                        "Trade",
                        style: TextStyle(
                          fontSize: 5.0.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
