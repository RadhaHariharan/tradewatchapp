import 'package:flutter/material.dart';

class BottomNavigationController extends ChangeNotifier {
  // These are the tabs that we are displaying in the bottom navigation bar
  final List<Map<String, dynamic>> _tabs = [
    {"title": "Stocks", "icon": Icons.price_check},
    {"title": "News", "icon": Icons.newspaper},
    {"title": "Search", "icon": Icons.search},
    {"title": "Chats", "icon": Icons.message_rounded},
    {"title": "Profile", "icon": Icons.person},
  ];
  String _currentTab = "Stocks";
  // This is used to track the current page
  final PageController _pageController = PageController(initialPage: 0);

  PageController get pageController => _pageController;
  String get currentTab => _currentTab;
  List<Map<String, dynamic>> get tabs => _tabs;

  // This function is used to change the _currentTab variable which is used to identify the current tab in which the user is and give the styling to the tab in bottom bar
  void changePage(int val) {
    _currentTab = _tabs[val]['title'];
    notifyListeners();
  }
}
