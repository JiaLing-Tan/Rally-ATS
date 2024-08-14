import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/notion.dart';

class NotionPage extends StatelessWidget {
  final cat;
  final title;
  final childPageId;
  final description;
  final notion_cover;
  final notionIcon;
  final notionLink;
  final notionUrlOptional;

  const NotionPage(
      {super.key,
      this.cat,
      this.title,
      this.childPageId,
      this.description,
      this.notion_cover,
      this.notionIcon,
      this.notionLink,
      this.notionUrlOptional});

  @override
  Widget build(BuildContext context) {
    Uri notionLinkUri = Uri.parse(notionLink);

    print('notionUrlOptional:-$notionUrlOptional-');

    return SingleChildScrollView(
        child: SizedBox(
      width: 800,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Stack(children: [
              Container(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: Image.network(
                    notion_cover,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      print("TAPP OPEN NOTION");
                      if (await canLaunchUrl(notionLinkUri)) {
                        await launchUrl(notionLinkUri);
                      } else {
                        throw 'Could not launch $notionLink';
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              'Open Notion',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 20),
            // Icon and Title
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  // Icon
                  Text(
                    notionIcon,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: SizedBox(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table of Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notionUrlOptional == null
                      ? const Text("")
                      : TextButton(
                          onPressed: () async {
                            var _notionUrlOptional = addHttpPrefixIfNeeded(notionUrlOptional);
                            if (await canLaunchUrl(Uri.parse(_notionUrlOptional))) {
                              await launchUrl(Uri.parse(_notionUrlOptional));
                            } else {
                              throw 'Could not launch $_notionUrlOptional';
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: Text("> ${addHttpPrefixIfNeeded(notionUrlOptional)}"),
                          ),
                        ),
                  Notion.notionCache[childPageId]!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: Notion.notionCache[childPageId]!['content']!
                              .map((item) {
                            if (item['type'] == 'image') {
                              // Check if the item is a URL
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Image.network(item['content']),
                              ); // Return Image widget if it's a URL
                            } else if (item['type'] == 'bookmark') {
                              // Check if the item is a URL
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: TextButton(
                                  child: Text(item['content']),
                                  onPressed: () async {
                                    if (await canLaunchUrl(
                                        Uri.parse(item['content']))) {
                                      await launchUrl(
                                          Uri.parse(item['content']));
                                    } else {
                                      throw 'Could not launch ${item['content']}';
                                    }
                                  },
                                ),
                              ); // Return Image widget if it's a URL
                            } else if (item['type'] == 'text'){
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Text(
                                  item['content'] ?? "",
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            }
                            else{
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Text(
                                  item['content'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        )
                      : FutureBuilder(
                          future: Notion.getPageBlocks(childPageId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              Map jsonData = snapshot.data;
                              List contents = jsonData['content'];
                              List headingList = jsonData['heading_2'];
                              Notion.notionCache[childPageId] = {
                                'content': contents,
                                'headingList': headingList
                              };
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: contents.map((item) {
                                  if (item['type'].toString() == 'image') {
                                    // Check if the item is a URL
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: Image.network(item['content']),
                                    ); // Return Image widget if it's a URL
                                  } else if (item['type'] == 'bookmark') {
                                    // Check if the item is a URL
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: TextButton(
                                        child: Text(item['content']),
                                        onPressed: () async {
                                          if (await canLaunchUrl(
                                              Uri.parse(item['content']))) {
                                            await launchUrl(
                                                Uri.parse(item['content']));
                                          } else {
                                            throw 'Could not launch ${item['content']}';
                                          }
                                        },
                                      ),
                                    ); // Return Image widget if it's a URL
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20),
                                      child: Text(
                                        item['content'] ?? "",
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }
                                }).toList(),
                              );
                            }
                          }),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Additional content can be added here
          ],
        ),
      ),
    ));
  }

  String addHttpPrefixIfNeeded(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'http://$url'; // Assuming defaulting to http:// if no prefix is present
    } else {
      return url; // Already has http:// or https:// prefix
    }
  }
}
