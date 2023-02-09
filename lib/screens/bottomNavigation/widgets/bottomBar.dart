import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradewatchapp/common/extensions.dart';
import 'package:tradewatchapp/screens/bottomNavigation/controller/bottomNavigationController.dart';

// This widget builds all the screen icons that are visible in the bottom bar
class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavCtrlRead = context.read<BottomNavigationController>();
    final bottomNavCtrlWatch = context.watch<BottomNavigationController>();
    return SizedBox(
      height: 3.0.hp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: bottomNavCtrlRead.tabs
            .map((element) => Padding(
                  padding: EdgeInsets.all(0.25.hp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        element['icon'],
                        color: bottomNavCtrlWatch.currentTab == element['title']
                            ? const Color(0xff50C878)
                            : null,
                      ),
                      SizedBox(height: 0.25.hp),
                      Text(
                        element['title'],
                        style: TextStyle(
                          fontSize: 4.0.sp,
                          color:
                              bottomNavCtrlWatch.currentTab == element['title']
                                  ? const Color(0xff50C878)
                                  : null,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
