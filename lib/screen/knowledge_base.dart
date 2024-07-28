import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:rally/model/notion.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/resources/utils.dart';
import 'package:rally/screen/create_knowledge_card.dart';
import 'package:rally/widget/knowledge_base_tab.dart';

class KnowledgeBase extends StatefulWidget {
  const KnowledgeBase({super.key});

  @override
  State<KnowledgeBase> createState() => _KnowledgeBaseState();
}

class _KnowledgeBaseState extends State<KnowledgeBase> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Notion.getDatabaseRows(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }else {
            Notion.uniqueNotionTag = Notion.notionTag.toSet();

            return Container(
                  padding: ThemeRally.widgetInnerPadding(right: 20),
                  color: ThemeRally.background,
                  child: DefaultTabController(
                    length: Notion.uniqueNotionTag.length,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        title: Text(
                          "Knowledge Base",
                          style: TextStyle(fontSize: 25),
                        ),
                        actions: [GestureDetector(
                          onTap: () {
                            setState(() {
                              // isLoading = true;
                            });
                          },
                          child: Container(
                            decoration: ThemeRally.widgetDeco(),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.refresh,
                              color: ThemeRally.newBlack,
                            ),
                          ),
                        ),],
                        bottom: TabBar(
                          isScrollable: true,
                          overlayColor: MaterialStateProperty.resolveWith<
                              Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                          indicatorWeight: 5,
                          labelColor: ThemeRally.newBlack,
                          indicatorColor: ThemeRally.newBlack,
                          tabs:
                              // Changed to Fix sequence
                          ['General','Document','Handbook','News','Legal Document'].map((cat) => Tab(text:cat)).toList()

                          // Notion.uniqueNotionTag
                          //     .map((cat) => Tab(text: cat))
                          //     .toList(),



                        ),
                      ),
                      body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: Notion.uniqueNotionTag.isEmpty
                            ? [] // Return an empty list if Notion.notionTag is empty
                            : ['General','Document','Handbook','News','Legal Document'].map((cat) =>
                            KnowledgeBaseTab(cat: cat)).toList(),
                      ),

                      floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (
                                  context) => const CreateKnowledgeCard()),
                        );
                      }, child: const Icon(Icons.add),),
                    ),
                  )
            );
          }
        }
    );
  }

  @override
// TODO: implement wantKeepAlive
  bool wantKeepAlive = true;
}
