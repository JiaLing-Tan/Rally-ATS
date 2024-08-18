import 'package:flutter/material.dart';

import '../model/candidate.dart';
import '../resources/theme.dart';
import 'package:http/http.dart' as http;

import '../resources/utils.dart';

class OfferLetter extends StatefulWidget {
  Candidate candidate;
  BuildContext context;
  OfferLetter({super.key, required this.candidate, required this.context});

  @override
  State<OfferLetter> createState() => _OfferLetterState();
}

class _OfferLetterState extends State<OfferLetter> {
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimeController.text = "9:30 AM";
    _endTimeController.text = "6:00 PM";
    _startDateController.text = "1 Sept 2024";
  }

  Future<http.Response> offerPosition(String id) async {
    setState(() {
      _isLoading = true;
    });
    showSnackBar("Sending Offer letter...", context);
    String? urlGet = "$url?token=$token&funcName=offerPosition&id=$id&startDate=${_startTimeController.text}&salary=${_salaryController.text}.";
    var response = await http.get(Uri.parse(urlGet));
    showSnackBar("Offer letter sent out successfully.", context);
    setState(() {
      _isLoading = false;
    });


    return response;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            width: 700,
            height: 500,
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            title: Text("Edit Offer Letter"),
            content: Container(
              padding: EdgeInsets.all(20),
              width: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Job Description"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        cursorColor: ThemeRally.newBlack,
                        controller: _supervisorController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Salary"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        cursorColor: ThemeRally.newBlack,
                        controller: _salaryController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Start Date"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        cursorColor: ThemeRally.newBlack,
                        controller: _startDateController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Start Time"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        cursorColor: ThemeRally.newBlack,
                        controller: _startTimeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("End Time"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        cursorColor: ThemeRally.newBlack,
                        controller: _endTimeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      offerPosition(widget.candidate.id);
                      Navigator.pop(widget.context);
                    },
                    child: Container(
                      decoration: ThemeRally.widgetDeco(
                          color: ThemeRally.newBlack),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
