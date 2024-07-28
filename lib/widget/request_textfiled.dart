import 'package:flutter/material.dart';

import '../resources/theme.dart';

class RequestTextfield extends StatefulWidget {
  const RequestTextfield({super.key});

  @override
  State<RequestTextfield> createState() => _RequestTextfieldState();
}

class _RequestTextfieldState extends State<RequestTextfield> {
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Container(
          decoration: ThemeRally.widgetDeco(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 157,
                  child: TextField(
                    maxLines: 1000,
                    cursorColor: ThemeRally.newBlack,
                    controller: _contentController,
                    decoration: InputDecoration(
                      // enabledBorder: OutlineInputBorder(),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: titleGreen),
                      // ),
                      border: InputBorder.none,
                      hintText: "Write your reply here.",
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                  color: ThemeRally.newBlack.withOpacity(0.3),
                ),
                SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: ThemeRally.widgetDeco(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          "Reject",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: ThemeRally.widgetDeco(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          "Approve",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
