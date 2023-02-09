import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tradewatchapp/screens/bottomNavigation/controller/bottomNavigationController.dart';
import 'package:tradewatchapp/screens/bottomNavigation/view/customNavigationBottomBar.dart';
import 'package:tradewatchapp/screens/news/controller/newsController.dart';
import 'package:tradewatchapp/screens/stocks/controller/stocksController.dart';
import 'package:tradewatchapp/screens/stocks/view/stockDetailsScreen.dart';

// Seeting the orientation of the app to portrait and not able to change to landscape
// Added delayed because I have used on extension which aligns the text and width and height based on screen so to get screen size added that small delay
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

// Used 3 providers for the app one is for bottom navigation bar, stocks and news
// used routing here to specify the route name and navigate to it inital is / which is bottom navigation screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavigationController(),
        ),
        ChangeNotifierProvider(
          create: (_) => StocksController(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsController(),
        ),
      ],
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          CustomBottomNavigationBar.routeName: (context) =>
              const CustomBottomNavigationBar(),
          StockDetailsScreen.routeName: (context) => const StockDetailsScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'TradeWatch',
      ),
    );
  }
}
