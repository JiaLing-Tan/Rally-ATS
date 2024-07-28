import 'package:flutter/material.dart';
import 'package:rally/model/notion.dart';
import 'package:rally/widget/knowledge_base_card.dart';

class KnowledgeBaseTab extends StatefulWidget {
  final cat;
  var notionTags = [];
  var notionTitles = [];
  var notionIds = [];
  var notionDescs = [];
  var notionCovers = [];
  var notionIcon = [];
  var notionLink = [];
  var notionUrlOptional = [];

  KnowledgeBaseTab({super.key, required this.cat});

  @override
  State<KnowledgeBaseTab> createState() => _KnowledgeBaseTabState();

  // final _url =
  //     'https://script.google.com/macros/s/AKfycbwD8uNB62ih6_GAs9R5xTCo5xpYeJK0tY_Xmm67Iv5DqdTivrQy62IFrO2SZ-crTEvf/exec';
  //
  // Future getDatabaseRows(String id) async {
  //   String? urlGet = "$_url?token=$token&funcName=getDatabaseRows&id=$id";
  //   var response = await http.get(Uri.parse(urlGet));
  //   return response;
  // }

  Future<void> getNumberOfTag() async {
    notionTags = [];
    notionTitles = [];
    notionIds = [];
    notionDescs = [];
    notionCovers = [];
    notionIcon = [];
    notionLink = [];
    notionUrlOptional = [];

    for (int index = 0; index < Notion.notionTag.length; index++) {
      if (cat != Notion.notionTag?[index]) {
        continue;
      }
      notionTags.add(Notion.notionTag?[index]);
      notionTitles.add(Notion.notionTitle?[index]);
      notionIds.add(Notion.notionId?[index]);
      notionDescs.add(Notion.notionDesc?[index]);
      notionCovers.add(Notion.notionCover?[index]);
      notionIcon.add(Notion.notionIcon?[index]);
      notionLink.add(Notion.notionPageLink?[index]);
      notionUrlOptional.add(Notion.notionUrlOptional?[index]);
    }
  }
}

class _KnowledgeBaseTabState extends State<KnowledgeBaseTab> {
  late Future futureResponse; // Declare Future variable

  @override
  void initState() {}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.getNumberOfTag(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 0.92,
                    children: List.generate(
                      widget.notionTags.length,
                      (index) => KnowledgeBaseCard(
                        cat: widget.notionTags[index],
                        title: widget.notionTitles[index],
                        child_page_id: widget.notionIds[index],
                        description: widget.notionDescs[index],
                        notion_cover: widget.notionCovers[index],
                        notionIcon: widget.notionIcon[index],
                        notionLink:widget.notionLink[index],
                        notionUrlOptional:widget.notionUrlOptional[index],
                      ),
                    ))); // Display fetched data
          }
        });
  }
}
