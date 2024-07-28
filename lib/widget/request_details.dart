import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rally/model/provider/request_provider.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/widget/status_indicator.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({super.key});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  bool _isWrapped = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer(builder: (context, ref, _) {
      final request = ref.watch(requestProvider);

      return Container(
        constraints: _isWrapped
            ? BoxConstraints(minHeight: 250)
            : BoxConstraints(minHeight: 250, maxHeight: 400),
        padding: ThemeRally.widgetInnerPadding(right: 20),
        decoration: ThemeRally.widgetDeco(),
        width: size.width / 2,
        child: request.request.id == ""
            ? Center(
                child: Text("Select a request to get start"),
              )
            : Stack(alignment: Alignment.topCenter, children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SingleChildScrollView(
                    physics: _isWrapped
                        ? NeverScrollableScrollPhysics()
                        : AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Request Id: ${request.request.id}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  StatusIndicator(
                                    text: request.request.status,
                                    isBig: true,
                                  ),
                                  SizedBox(width: 15,),
                                  StatusIndicator(text: request.request.tag, isBig: true,),
                                ],
                              ),
                              Text(
                                "Requested by: ${request.request.employeeId}",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Add some spacing
                          Text(
                            style: TextStyle(fontSize: 20),
                            request.request.header,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            maxLines: _isWrapped ? 2 : null,
                            overflow: _isWrapped
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          SizedBox(height: 10,),
                          Text(
                            request.request.body,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            maxLines: _isWrapped ? 1 : null,
                            overflow: _isWrapped
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                          ),
                          _isWrapped
                              ? SizedBox()
                              : SizedBox(
                                  height: 10,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _isWrapped
                                      ? SizedBox()
                                      : Text(
                                          "Remark",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                  _isWrapped
                                      ? SizedBox()
                                      : Text(
                                          request.request.remark,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _isWrapped
                                      ? SizedBox()
                                      : Text(
                                          "Date Created",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.grey),
                                        ),
                                  _isWrapped
                                      ? SizedBox()
                                      : Text(
                                          DateFormat("d MMM y").format(
                                              request.request.timestamp),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.grey),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      _isWrapped ? Text("Expand to see more...") : SizedBox(),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _isWrapped = !_isWrapped;
                            });
                          },
                          child: Icon(_isWrapped
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded))
                    ],
                  ),
                )
              ]),
      );
    });
  }
}
