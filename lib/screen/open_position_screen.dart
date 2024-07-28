import 'package:flutter/material.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/widget/filter.dart';

import '../widget/open_position_card.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);

class OpenPositionScreen extends StatelessWidget {
  late void Function() myMethod;



  @override
  Widget build(BuildContext context) {
    Object filterWidget() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Filter(context: context);
          });
    }

    return Container(
      padding: ThemeRally.widgetInnerPadding(right: 20),
      color: ThemeRally.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Open Position",
                style: TextStyle(fontSize: 25),
              ),
              Row(children: [GestureDetector(
                onTap: () {
                  myMethod();
                },
                child: Container(
                  decoration: ThemeRally.widgetDeco(),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.refresh,
                    color: ThemeRally.newBlack,
                  ),
                ),
              ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: filterWidget,
                  child: Container(
                    decoration: ThemeRally.widgetDeco(),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.filter_list_rounded,
                      color: ThemeRally.newBlack,
                    ),
                  ),
                ),],)
            ],
          ),
        ),
        body: OpenPositions(
          builder: (BuildContext context, void Function() methodFromChild) {
            myMethod = methodFromChild;
          },
        ),
      ),
    );
  }
}
