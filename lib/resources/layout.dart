import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rally/model/notion.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/resources/utils.dart';
import 'package:rally/screen/knowledge_base.dart';
import 'package:rally/screen/open_position_screen.dart';
import 'package:rally/screen/request_screen.dart';
import 'package:rally/screen/candidate_screen.dart';
import 'package:rally/screen/schedule.dart';

import '../screen/dashboard.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  SideMenuDisplayMode displayMode = SideMenuDisplayMode.open;
  SideMenuDisplayMode displayModeSub = SideMenuDisplayMode.open;

  @override
  void initState() {
    // Connect SideMenuController and PageController together
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });

    super.initState();
  }

  void updateDisplayMode() {
    setState(() {
      if (displayMode == SideMenuDisplayMode.open) {
        displayMode = SideMenuDisplayMode.compact;
      } else {
        displayMode = SideMenuDisplayMode.open;
      }
    });

    if (displayModeSub == SideMenuDisplayMode.open) {
      setState(() {
        displayModeSub = SideMenuDisplayMode.compact;
      });
    } else {
      Future.delayed(Duration(milliseconds: 280), () {
        setState(() {
          displayModeSub = SideMenuDisplayMode.open;
        });
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    List<SideMenuItem> items = [
      SideMenuItem(
        title: 'Dashboard',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.home_rounded),
      ),
      SideMenuItem(
        title: 'Candidates',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.people_alt_rounded),
      ),
      SideMenuItem(
        title: 'Open Position',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.work_rounded),
      ),
      SideMenuItem(
        title: 'Request',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.question_answer_rounded),
      ),
      SideMenuItem(
        title: 'Schedule',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.date_range_rounded),
      ),
      SideMenuItem(
        title: 'Support',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.newspaper_rounded),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SideMenu(
          // Page controller to manage a PageView
          controller: sideMenu,
          // Will shows on top of all items, it can be a logo or a Title text
          title: Padding(
            padding: const EdgeInsets.only(left: 5, top: 12),
            child: Column(
              children: [
                displayModeSub == SideMenuDisplayMode.open
                    ? Padding(
                        padding: const EdgeInsets.only(top: 27, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 15),
                              child: Container(child: Image.asset('lib/assets/RALLY_full.png', fit: BoxFit.fitWidth,), width: 130, height: 30,)
                            ),
                            GestureDetector(
                                onTap: updateDisplayMode,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey,
                                  size: 15,
                                ))
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Image.asset('lib/assets/RALLY.png', width: 50),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: GestureDetector(
                                onTap: updateDisplayMode,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 15,
                                )),
                          )
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 10),
                  child: Divider(),
                )
              ],
            ),
          ),
          // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
          footer: GestureDetector(
            onTap: () {
              showBackDialog(
                  "Are you sure you want to leave the app?", context);
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 25, left: 30),
              child: Row(
                children: [
                  Tooltip(
                    message: "Exit App",
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Notify when display mode changed
          style: SideMenuStyle(
            displayMode: displayMode,
            decoration: BoxDecoration(),
            openSideMenuWidth: 210,
            compactSideMenuWidth: 80,
            hoverColor: Colors.grey[100],
            selectedColor: ThemeRally.newBlack,
            selectedIconColor: ThemeRally.white,
            unselectedIconColor: ThemeRally.black,
            backgroundColor: ThemeRally.white,
            selectedTitleTextStyle: TextStyle(color: ThemeRally.white),
            unselectedTitleTextStyle: TextStyle(color: ThemeRally.black),
            iconSize: 20,
            itemBorderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            showTooltip: true,

            itemHeight: 50.0,
            itemInnerSpacing: 8.0,
            itemOuterPadding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            toggleColor: ThemeRally.black,

            // Additional properties for expandable items
            // selectedTitleTextStyleExpandable: TextStyle(color: Colors.white), // Adjust the style as needed
            // unselectedTitleTextStyleExpandable: TextStyle(color: Colors.black54), // Adjust the style as needed
            // selectedIconColorExpandable: Colors.white, // Adjust the color as needed
            // unselectedIconColorExpandable: Colors.black54, // Adjust the color as needed
            // arrowCollapse: Colors.blueGrey, // Adjust the color as needed
            // arrowOpen: Colors.lightBlueAccent, // Adjust the color as needed
            // iconSizeExpandable: 24.0, // Adjust the size as needed
          ),
          // List of SideMenuItem to show them on SideMenu
          items: items,
        ),
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              Dashboard(),
              CandidateScreen(),
              OpenPositionScreen(),
              RequestScreen(),
              Schedule(),
              KnowledgeBase()
            ],
          ),
        ),
      ],
    );
  }
}
