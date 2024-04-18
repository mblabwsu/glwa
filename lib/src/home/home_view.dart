// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:microbial_source_tracking/src/configuration/config_view.dart';
import 'package:microbial_source_tracking/src/history/history_page.dart';
import 'package:microbial_source_tracking/src/home/home_list_view.dart';
import 'package:microbial_source_tracking/src/navbar/nav_bar.dart';
import 'package:microbial_source_tracking/src/navbar/nav_model.dart';
import 'package:microbial_source_tracking/src/settings/settings_view.dart';
import 'package:microbial_source_tracking/src/widgets/test_config.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeView> {
  //Navigation through global keys on the main pages
  final homeNavKey = GlobalKey<NavigatorState>();
  final configNavKey = GlobalKey<NavigatorState>();
  final historyNavKey = GlobalKey<NavigatorState>();
  final settingsNavKey = GlobalKey<NavigatorState>();

  int selectedPage = 0;

  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const HomeListView(),
        navBarKey: homeNavKey,
      ),
      NavModel(
        page: ConfigView(/*title: '',*/),
        navBarKey: configNavKey,
      ),
      NavModel(
        page: const HistoryPage(),
        navBarKey: historyNavKey,
      ),
      NavModel(
        page: const SettingsView(),
        navBarKey: settingsNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (items[selectedPage].navBarKey.currentState?.canPop() ?? false) {
          items[selectedPage].navBarKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedPage,
          children: items
              .map((page) => Navigator(
                    key: page.navBarKey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.page)
                      ];
                    },
                  ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 64,
          width: 64,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TestConfig()));
            },
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Colors.lightBlue),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.lightBlue,
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedPage,
          onTap: (index) {
            if (index == selectedPage) {
              items[index]
                  .navBarKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedPage = index;
              });
            }
          },
        ),
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab $tab'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Page(tab: tab),
                  ),
                );
              },
              child: const Text('Go to page'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final int tab;

  const Page({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Tab $tab'),
      ),
      body: Center(
        child: Text('Tab $tab'),
      ),
    );
  }
}
