import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rally/resources/theme.dart';
import 'package:lottie/lottie.dart';

import '../model/gemini.dart';
import '../model/notion.dart';

class CreateKnowledgeCard extends StatefulWidget {
  const CreateKnowledgeCard({super.key});

  @override
  State<CreateKnowledgeCard> createState() => _CreateKnowledgeCardState();
}

class _CreateKnowledgeCardState extends State<CreateKnowledgeCard> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  String _tagSelectedOption = Notion.uniqueNotionTag.first;
  String otherValue = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Notion.uniqueNotionTag.add('Other');

    return Container(
      decoration: BoxDecoration(color: ThemeRally.white),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: true,
              title: const Text(
                "Create new card",
                style: TextStyle(fontSize: 20),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title*",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width,
                      height: 50,
                      decoration: BoxDecoration(
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
                          controller: _titleController,
                          decoration: InputDecoration(
                            // enabledBorder: OutlineInputBorder(),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: titleGreen),
                            // ),
                            border: InputBorder.none,
                            hintText: "Write your title here.",
                            hintStyle:
                                TextStyle(color: Colors.grey[400], fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // First Column (30% of screen width)
                          Flexible(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Tag*",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 30),
                                    underline: Container(),
                                    borderRadius: BorderRadius.circular(0),
                                    value: _tagSelectedOption,
                                    alignment: AlignmentDirectional.centerStart,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _tagSelectedOption = newValue!;
                                      });
                                    },
                                    items: Notion.uniqueNotionTag
                                        .map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 90.0),
                                            child: Text(value,
                                                textAlign: TextAlign.left),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                
                          // Second Column (Remaining space)
                          Flexible(
                            flex: 8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Link (Optional)",
                                    style: TextStyle(fontSize: 15)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  // width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextField(
                                      cursorColor: ThemeRally.newBlack,
                                      controller: _linkController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Paste the link here.",
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    // SizedBox(
                    //   height: 15,
                    // ),
                
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Content*", style: TextStyle(fontSize: 15)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            hintText: "Write your content here.",
                            hintStyle:
                                TextStyle(color: Colors.grey[400], fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Description*", style: TextStyle(fontSize: 15)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _descriptionController,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Short Description of the Content",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed:
                                  isLoading ? null : _handleGeminiButtonPress,
                              child: isLoading
                                  ? SizedBox(
                                      // width: 195.0,
                                      child: Lottie.asset(
                                        'lib/assets/loading_animation.json',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Text('Let Gemini AI summarize for you!'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return ThemeRally.pastelPurple.withOpacity(0.5);
                              }
                              return null; // Use the component's default.
                            },
                          ),
                        ),
                        child: const Text('Send to Notion!'),
                        onPressed: () {
                          String title = _titleController.text;
                          String link = _linkController.text;
                          String content = _contentController.text;
                          String description = _descriptionController.text;
                          String? tag = _tagSelectedOption;
                
                          if (title.isEmpty ||
                              content.isEmpty ||
                              description.isEmpty ||
                              tag == null) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Warning"),
                                  content: const Text(
                                      "Please fill in all fields with *"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            print("Trying upload to notion");
                            if (link == '') {
                              link = ' ';
                            }
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return FutureBuilder(
                                  future: Notion.createNewPost(
                                    "📖",
                                    link,
                                    title,
                                    tag,
                                    description,
                                    content,
                                    "fake heading",
                                  ),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the result, show a loading indicator
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      // When the future completes (either with data or error)
                                      if (snapshot.hasError) {
                                        print("HAS ERROR");
                                        // Display an AlertDialog for error case
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Notion Unstable"),
                                                content: const Text(
                                                    "Failed to connect to Notion,"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("Done"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        });
                                      } else if (snapshot.data == 200) {
                                        // If data is 200, navigate back to previous page
                                        print("POP");
                                        Navigator.of(context).pop();
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Knowledge base updated"),
                                                content: const Text(
                                                    "The page has been created in Notion."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("Done"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        });
                                      }
                                      // Return a placeholder widget while waiting for future to complete
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                );
                              },
                            );
                          }
                
                          // Notion.createNewPost("😀", link, title, tag,
                          //         description, content, "fake heading")
                          //     .then((value) => value == 200
                          //         ? Navigator.pop(
                          //             context) //Back to previous page
                          //         : showDialog(
                          //             context: context,
                          //             builder: (BuildContext context) {
                          //               return AlertDialog(
                          //                 title: const Text("Notion Unstable"),
                          //                 content: const Text(
                          //                     "Page didn't created, Try again later."),
                          //                 actions: <Widget>[
                          //                   TextButton(
                          //                     child: const Text("OK"),
                          //                     onPressed: () {
                          //                       Navigator.of(context).pop();
                          //                     },
                          //                   ),
                          //                 ],
                          //               );
                          //             },
                          //           ));
                        })
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _handleGeminiButtonPress() {
    // Set loading state to true
    setState(() {
      isLoading = true;
    });

    // Simulate asynchronous operation (Replace with your actual logic)
    Gemini.callGemini(_contentController.text).then((_) {
      setState(() {
        _descriptionController.text = Gemini.geminiResponse.toString();
        isLoading = false; // Set loading state to false when done
      });
    });
  }
}
