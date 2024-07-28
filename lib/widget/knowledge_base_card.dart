import 'package:flutter/material.dart';
import '../resources/theme.dart';
import 'notion_page.dart';

class KnowledgeBaseCard extends StatelessWidget {
  final cat;
  final title;
  final child_page_id;
  final description;
  final notion_cover;
  final notionIcon;
  final notionLink;
  final notionUrlOptional;

  const KnowledgeBaseCard({super.key, this.cat, this.title, this.child_page_id, this.description, this.notion_cover, this.notionIcon, this.notionLink, this.notionUrlOptional});

  @override
  Widget build(BuildContext context) {
    print("description $description");
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close dialog when tapped outside
                  },
                  child:
                  NotionPage(cat: cat,title: title, childPageId: child_page_id,description: description,notion_cover: notion_cover, notionIcon:notionIcon, notionLink:notionLink, notionUrlOptional:notionUrlOptional??" ")
                ),
              );
            },
          );
        },
        child: Container(
          decoration: ThemeRally.widgetDeco(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7), topLeft: Radius.circular(7)),
                child: Image.network(
                  notion_cover ?? "https://www.notion.so/images/page-cover/rijksmuseum_jansz_1637.jpg",
                  fit: BoxFit.cover,
                  height: MediaQuery.sizeOf(context).height / 5.5,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              Padding(
                padding:
                    ThemeRally.widgetInnerPadding(top: 14.5, right: 20, bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      // "${cat} $title",
                      style: TextStyle(fontSize: 16.5),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(description,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
