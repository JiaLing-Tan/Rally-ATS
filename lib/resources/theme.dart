import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class ThemeRally {
  static Color vibrantBlue = Color(0xff4c4299);
  static Color newBlack = Color(0xff2b2b2b);
  static Color lightBlue = Color(0xffd3e9fe);
  static Color lightPurple = Color(0xffd3d9ef);
  static Color pastelPurple = Color(0xffd0c3f1);
  static Color black = Colors.black54;
  static Color background = Colors.grey.withOpacity(0.03);
  static Color normalBlack = Colors.black;
  static Color white = Colors.white;

  static BoxDecoration widgetDeco(
      {Color color = Colors.white, bool isFloating = false}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: Colors.grey.withOpacity(0.30)),
      boxShadow: [
        isFloating
            ? BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              )
            : BoxShadow(
                color: Colors.grey.withOpacity(0.10),
                spreadRadius: 2,
                blurRadius: 1,
                offset: Offset(0, 3), // changes position of shadow
              ),
      ],
    );
  }

  static EdgeInsetsGeometry widgetOuterPadding() {
    return EdgeInsets.symmetric(vertical: 7, horizontal: 7);
  }

  static EdgeInsetsGeometry widgetInnerPadding({
    double top = 20,
    double bottom = 20,
    double left = 20,
    double right = 0,
  }) {
    return EdgeInsets.only(top: top, bottom: bottom, left: left, right: right);
  }

// static LayoutGrid widgetLayoutGrid(){
//   return LayoutGrid(
//     // set some flexible track sizes based on the crossAxisCount
//     columnSizes: crossAxisCount == 2 ? [1.fr, 1.fr] : [1.fr],
//     // set all the row sizes to auto (self-sizing height)
//     rowSizes: crossAxisCount == 2
//         ? const [auto, auto]
//         : const [auto, auto, auto, auto],
//     rowGap: 40, // equivalent to mainAxisSpacing
//     columnGap: 24, // equivalent to crossAxisSpacing
//     // note: there's no childAspectRatio
//     children: [
//       // render all the cards with *automatic child placement*
//       for (var i = 0; i < items.length; i++)
//         ItemCard(data: items[i]),
//     ],
//   );
// }
}
