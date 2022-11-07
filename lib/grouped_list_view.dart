library grouped_list_view;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_list_view/indexed_title_view.dart';
import 'package:grouped_list_view/scrollable_positioned_list.dart';
import 'package:grouped_list_view/index_path.dart';
import 'list_item.dart';

typedef GroupedItemBuilder = Widget Function(
    BuildContext context, IndexPath index);
typedef GroupedSectionBuilder = Widget Function(
    BuildContext context, int section);

enum ListItemType { section, item }

extension ItemTypeExtension on ListItemType {
  bool get isItem => this == ListItemType.item;

  bool get isSection => this == ListItemType.section;
}

// ignore: must_be_immutable
class GroupedListView extends StatelessWidget {
  final ItemScrollController itemScrollController = ItemScrollController();

  final int sectionsCount;
  final int Function(int section) itemCountInSection;
  final GroupedSectionBuilder sectionBuilder;

  late List<ListItem> _indexToIndexPathList;
  late List<int> _sectionIndex;
  late bool showIndexTitle;
  List<String>? sectionIndexTitles;

  GroupedItemBuilder itemBuilder;

  Color? titleColor = Colors.black;
  Color? primaryColor;
  final ScrollPhysics? physics;

  Function(int section)? didSelectedSectionIndex;
  Function? didDeSelectedSectionIndex;

  GroupedListView.builder(
      {required this.sectionBuilder,
      required this.sectionsCount,
      required this.itemCountInSection,
      required this.itemBuilder,
      this.showIndexTitle = false,
      this.sectionIndexTitles,
      this.primaryColor,
      this.titleColor, this.physics,
      this.didSelectedSectionIndex,
      this.didDeSelectedSectionIndex}) {
    _indexToIndexPathList = [];
  }

  @override
  Widget build(BuildContext context) {
    _calculateIndexPath();
    final list = ScrollablePositionedList.builder(
        itemCount: _indexToIndexPathList.length,
        itemScrollController: itemScrollController,
        physics: physics,
        itemBuilder: (BuildContext context, int index) {
          return _itemBuilder(context, index);
        });

    if (!showIndexTitle || sectionIndexTitles == null) return list;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        list,
        Positioned(
            right: 0,
            child: IndexedTitleView(
                sectionIndexTitles ?? [],
                titleColor ?? Colors.black,
                primaryColor ?? Theme.of(context).primaryColor, (selectedIndex) {
              if (selectedIndex != null) {
                final index = _sectionIndex[selectedIndex];
                jumpTo(index);
                didSelectedSectionIndex?.call(selectedIndex);
              } else {
                didDeSelectedSectionIndex?.call();
              }
            })),
      ],
    );
  }

  void _calculateIndexPath() {
    _indexToIndexPathList = [];
    _sectionIndex = [];
    ListItem listItem;

    for (int section = 0; section < sectionsCount; section++) {
      //Add section
      listItem = ListItem(
        indexPath: IndexPath(section: section),
        type: ListItemType.section,
      );

      _sectionIndex.add(_indexToIndexPathList.length);
      _indexToIndexPathList.add(listItem);
      
      final int rows = itemCountInSection(section);
      for (int index = 0; index < rows; index++) {
        //Add item
        listItem = ListItem(
          indexPath: IndexPath(section: section, index: index),
          type: ListItemType.item,
        );
        _indexToIndexPathList.add(listItem);
      }
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final ListItem listItem = _indexToIndexPathList[index];
    final IndexPath indexPath = listItem.indexPath;
    if (listItem.type.isSection) {
      return sectionBuilder(context, indexPath.section);
    }
    return itemBuilder(context, indexPath);
  }

  jumpTo(int index) {
    itemScrollController.jumpTo(index: index);
  }
}
