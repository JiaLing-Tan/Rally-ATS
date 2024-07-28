import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rally/model/candidate.dart';
import 'package:rally/model/provider/roleProvider.dart';
import 'package:rally/model/provider/ratingProvider.dart';
import 'package:rally/resources/theme.dart';
import 'package:rally/resources/utils.dart';
import 'package:riverpod/riverpod.dart';

import '../model/provider/filterProvider.dart';

class Filter extends StatefulWidget {
  final BuildContext context;
  const Filter({super.key, required this.context});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final role = ref.watch(roleProvider);
        final rating = ref.watch(ratingProvider);
        final filter = ref.watch(filterProvider);
        return AlertDialog(

          title: Text("Filter & Sorting"),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sort",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: sortingList
                          .map((sortTerm) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                    label: Text(sortTerm),
                                    onSelected: (selected) {}),
                              ))
                          .toList(),
                    ),
                    Divider(),
                    Text(
                      "Filter",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Role"),
                    Wrap(
                      children: role.role
                          .map((role) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                    selected: rating.rolesFilter.indexOf(role) >= 0,
                                    label: Text(role),
                                    onSelected: (selected) {
                                      setState(() {
                                        selected
                                            ? rating.addRoles(role)
                                            : rating.removeRoles(role);
                                      });
                                    }),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Date"),
                    Wrap(
                      children: dayMap.keys
                          .map((day) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                    label: Text(day),
                                    onSelected: (selected) {}),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Status"),
                    Wrap(
                      children: status
                          .map((status) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                    label: Text(status),
                                    onSelected: (selected) {}),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Rating"),
                    RangeSlider(
                        activeColor: ThemeRally.newBlack,
                        //MaterialStateProperty.all(ThemeRally.vibrantBlue),

                        divisions: 100,
                        max: 100,
                        values: rating.currentRating,
                        labels: RangeLabels(
                            rating.currentRating.start.round().toString(),
                            rating.currentRating.end.round().toString()),
                        onChanged: (range) {
                          rating.updateRating(range);
                        }),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              rating.clear();
                              filter.clearFilter();
                            },
                            child: Container(
                              decoration: ThemeRally.widgetDeco(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text("Reset"),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              filter.getFilter(rating.rolesFilter);
                              Navigator.pop(widget.context);
                            },
                            child: Container(
                              decoration: ThemeRally.widgetDeco(
                                  color: ThemeRally.newBlack),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
