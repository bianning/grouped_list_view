import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouped_list_view/grouped_list_view.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:grouped_list_view/index_path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  GroupedListView? group;

  Map<String, List> data = {};

  @override
  void initState() {
    super.initState();

    getData().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget? child;
    if (data.isEmpty) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      child = GroupedListView.builder(
        sectionBuilder: (context, section) {
          final text = data.keys.elementAt(section);
          return Column(children: [

            Container(
              height: 46,
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(text),
            ),
            Divider(
              height: 1,
            )
          ]);
        },
        sectionsCount: data.keys.length,
        itemCountInSection: (section) {
          final key = data.keys.elementAt(section);
          return data[key]!.length;
        },
        itemBuilder: (context, indexPath) {
          final key = data.keys.elementAt(indexPath.section);
          final value = data[key]![indexPath.index!];
          return itemBuilder(value as Map<String, dynamic>);
        },
        showIndexTitle: true,
        sectionIndexTitles: data.keys.toList(),
        didSelectedSectionIndex: (section) {
          print('section $section');
        },
        didDeSelectedSectionIndex: () {
          print('didDeSelectedSectionIndex');
        },
      );

      // child = GroupedListView.builder(
      //     sectionBuilder: (context, section) {
      //       return Container(
      //         color: Colors.green,
      //         child: Text('section $section')
      //         );
      //     },
      //     sectionsCount: 2,
      //     itemCountInSection: (section) {
      //       return 10;
      //     },
      //     itemBuilder: (context, indexPath) {
      //       return Container(
      //         height: indexPath.section == 0 ? 50 : 100,
      //         child: Text('${indexPath.section}---${indexPath.index}'),
      //       );
      //     },
      //     showIndexTitle: true,
      //     sectionIndexTitles: ['A', 'B']);
    }
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: SafeArea(child: Container(color: Colors.white, child: child)),
        ));
  }

  itemBuilder(Map<String, dynamic> item) {
    var enName = item['nameEn'];
    var tel = item['code'];
    return Container(
      child: ListTile(
        title: Text(enName,
            style: TextStyle(
                color: Color(0xFF1D1D1A), fontWeight: FontWeight.w600)),
        trailing: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text('+$tel',
              style: TextStyle(
                  color: Color(0xFF8C8C8C), fontWeight: FontWeight.w300)),
        ),
        // onTap: () {
        //   context.pop(result: item);
        // },
      ),
    );
  }

  Future<Map<String, List>> getData() {
    Map<String, List> data = {};
    return rootBundle.loadString('region_code.json').then((value) {
      List jsonValue = json.decode(value);
      List<Map<String, dynamic>> regions = [];
      jsonValue.forEach((element) {
        regions.add(element);
      });

      regions.forEach((element) {
        String acronym = element['nameEn'];
        if (data[acronym.substring(0, 1)] != null) {
          data[acronym.substring(0, 1)]!.add(element);
        } else {
          data[acronym.substring(0, 1)] = [];
          data[acronym.substring(0, 1)]!.add(element);
        }
      });

      return data;
    });
  }
}
