import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradewatchapp/common/extensions.dart';
import 'package:tradewatchapp/screens/bottomNavigation/controller/bottomNavigationController.dart';
import 'package:tradewatchapp/screens/bottomNavigation/widgets/bottomBar.dart';
import 'package:tradewatchapp/screens/news/view/newsScreen.dart';
import 'package:tradewatchapp/screens/stocks/view/stocksScreen.dart';

// This class is responsible for showing all the screens in the app controlled with pageController
class CustomBottomNavigationBar extends StatelessWidget {
  static const routeName = '/';
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavCtrlWatch = context.watch<BottomNavigationController>();
    final bottomNavCtrlRead = context.read<BottomNavigationController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "TradeWatch",
          style: TextStyle(
            color: Colors.black,
            fontSize: 5.50.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: bottomNavCtrlWatch.pageController,
          onPageChanged: (val) {
            bottomNavCtrlRead.changePage(val);
          },
          children: const [
            StocksScreen(),
            NewsScreen(),
            Center(
              child: Text("Search"),
            ),
            Center(
              child: Text("Chats"),
            ),
            Center(
              child: Text("Profile"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
