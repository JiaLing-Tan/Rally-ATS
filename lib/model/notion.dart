import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rally/resources/utils.dart';
import 'package:http/http.dart' as http;

class Notion {
  Notion();

  static late List notionTitle;
  static late List<String> notionTag;
  static late List notionId;
  static late List notionDesc;
  static late List notionCover;
  static late List notionIcon;
  static late List notionPageLink;
  static late List notionUrlOptional;
  static late Set<String> uniqueNotionTag;
  static Map<String,Map<String,List>> notionCache = {};
  static List covers = [
    "https://i.pinimg.com/564x/a9/c4/9f/a9c49f8598e639140826fd61988c6d73.jpg",
    "https://i.pinimg.com/564x/79/2d/a4/792da4aac34f3527272a12587138384f.jpg",
    "https://i.pinimg.com/564x/18/33/f7/1833f77a4b23252f12e096c24d12f0b8.jpg",
    "https://i.pinimg.com/564x/42/84/38/428438e907623e762192ad1669f6e1c1.jpg",
    "https://i.pinimg.com/564x/7d/2c/15/7d2c15ace7612050607ea41b459d569f.jpg",
    "https://i.pinimg.com/564x/42/9c/46/429c46b291ea32caf8796eee4eb2c55e.jpg",
    "https://i.pinimg.com/736x/e6/94/f6/e694f6b4d5815b833765961ad20a5d6a.jpg",
    "https://i.pinimg.com/564x/97/92/c0/9792c0c00cfe9d38be080c74eeb14c46.jpg",
    "https://i.pinimg.com/564x/b5/22/37/b52237d81c664362924b268a43fa28dc.jpg",
    "https://i.pinimg.com/564x/4d/6d/5a/4d6d5a3d86f84655e9a5a3ea4e49e1e8.jpg",
    "https://i.pinimg.com/736x/a5/5a/71/a55a7146e023948d53a1ccacb1da95ce.jpg",
    "https://i.pinimg.com/564x/6f/35/f3/6f35f3694d741ea742c16d61533f1f2c.jpg",

  ];


  static Future getPageBlocks(childPageId) async {
    String urlGet =
        "$url?token=$token&funcName=getNotionBlocks&pageId=$childPageId";
    var response = await http
        .get(Uri.parse(urlGet))
        .then((value) => jsonDecode(value.body));
    return response;
  }

  static Future getDatabaseRows() async {
    String urlGet = "$url?token=$token&funcName=getDatabaseRows";
    var response = await http
        .get(Uri.parse(urlGet))
        .then((value) => jsonDecode(value.body))
        .then((value) => value['results']!);

    var notionObjects = await response;

    if (notionObjects != null) {
      notionTitle = await notionObjects?.map((result) {
        var titleProperty = result['properties']['Name']['title'][0];
        return titleProperty['text']['content'];
      }).toList();
      notionTag = List<String>.from(notionObjects?.map((result) {
        return result['properties']['Tags']['select']['name'].toString();
      }));
      notionId = await notionObjects?.map((result) {
        return result['id'];
      }).toList();
      notionDesc = await notionObjects?.map((result) {
        var descProperty = result['properties']['Description']['rich_text'][0];
        return descProperty['text']['content'];
      }).toList();
      notionCover = await notionObjects?.map((result) {
        return result['cover']['external']['url'] ??
            result['cover']['external']['file'];
      }).toList();
      notionIcon = await notionObjects?.map((result) {
        return result['icon']['emoji'];
      }).toList();
      notionPageLink = await notionObjects?.map((result) {
        return result['url'];
      }).toList();
      notionUrlOptional = await notionObjects?.map((result) {
        try {
          return result['properties']['URL']['url'];
        } catch (error) {
          return null;
        }
      }).toList();
      for (String _id in notionId) {
        notionCache[_id] = {};
      }
    } else {
      throw Exception('Notion Failed to load data');
    }
  }

  static Future createNewPost(emojiUnicode, optionalUrl, pageTitle, tag, description, paragraphContent, heading) async {
    String urlGet = "$url?token=$token"
        "&funcName=createDatabasePost"
        "&emoji_unicode=$emojiUnicode"
        "&optional_url=$optionalUrl"
        "&page_title=${Uri.encodeComponent(pageTitle)}"
        "&tag=${Uri.encodeComponent(tag)}"
        "&description=${Uri.encodeComponent(description)}"
        "&paragraph_content=${Uri.encodeComponent(paragraphContent)}"
        "&heading=${Uri.encodeComponent(heading)}"
        "&cover=${Uri.encodeComponent(getRandomCover())}";
    try {
      var response = await http.get(Uri.parse(urlGet));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Full response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  static String getRandomCover() {

    int randomIndex = Random().nextInt(covers.length);

    return covers[randomIndex];
  }

}
