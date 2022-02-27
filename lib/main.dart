// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        theme: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                navLargeTitleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 70,
                    color: CupertinoColors.activeOrange))),
        home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ]),
        tabBuilder: (context, index) {
          return CupertinoTabView(builder: (context) {
            if (index == 0) {
              return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    backgroundColor: CupertinoColors.activeOrange,
                    middle: (index == 0) ? Text("Home") : Text("Settings"),
                  ),
                  child: Center(
                    child: Text("Questa è la tab #$index"),
                  ));
            } else {
              return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    backgroundColor: CupertinoColors.activeOrange,
                    middle: (index == 0) ? Text("Home") : Text("Settings"),
                  ),
                  child: Center(
                    child: Text("Questa è la tab #$index"),
                  ));
            }
          });
        });
  }
}
