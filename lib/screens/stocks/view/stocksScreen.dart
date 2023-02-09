import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tradewatchapp/common/extensions.dart';
import 'package:tradewatchapp/screens/stocks/controller/stocksController.dart';
import 'package:tradewatchapp/screens/stocks/view/stockDetailsScreen.dart';

// This widget will display all the stocks which come from BE
class StocksScreen extends StatelessWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockCtrlWatch = context.watch<StocksController>();
    return stockCtrlWatch.isStocksLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              stockCtrlWatch.getAllStocksData();
            },
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 1.0.wp, vertical: 0.10.hp),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last Reloaded",
                        style: TextStyle(
                          fontSize: 4.0.sp,
                        ),
                      ),
                      Center(
                        child: Text(
                          DateFormat("y MMM d, hh:mm:ss a").format(
                            DateTime.fromMillisecondsSinceEpoch(
                              stockCtrlWatch.lastReloadedTimeStamp,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 3.50.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.75.hp),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          secondary: Colors.white,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: stockCtrlWatch.stocks.length,
                        itemBuilder: (context, index) {
                          final currentStock = stockCtrlWatch.stocks[index];
                          return GestureDetector(
                            onTap: () {
                              stockCtrlWatch.selectStock(index);
                              Navigator.pushNamed(
                                context,
                                StockDetailsScreen.routeName,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 1.0.hp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentStock['longName'],
                                          style: TextStyle(
                                            fontSize: 4.50.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        currentStock['currencySymbol'] +
                                            " " +
                                            currentStock['regularMarketPrice']
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 4.0.sp,
                                          color: currentStock[
                                                      'regularMarketPrice'] >
                                                  currentStock[
                                                      'regularMarketPreviousClose']
                                              ? const Color(0xff50C878)
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.15.hp),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentStock['symbol'],
                                        ),
                                      ),
                                      Text(
                                        (currentStock['regularMarketPrice'] >
                                                    currentStock[
                                                        'regularMarketPreviousClose']
                                                ? "+ "
                                                : "- ") +
                                            currentStock['regularMarketChange']
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 3.50.sp,
                                          color: currentStock[
                                                      'regularMarketPrice'] >
                                                  currentStock[
                                                      'regularMarketPreviousClose']
                                              ? const Color(0xff50C878)
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
