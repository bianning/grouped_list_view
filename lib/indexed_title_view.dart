import 'package:flutter/material.dart';

class IndexedTitleView extends StatefulWidget {
  List<String> sectionIndexTitles;

  // Color titleColor = Colors.black;
  // Color primaryColor;
  Function(int?) selected;

  TextStyle? selectedStyle;
  TextStyle? defaultStyle = const TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );


  IndexedTitleView(this.sectionIndexTitles, this.defaultStyle,
      this.selectedStyle, this.selected);

  @override
  _State createState() => _State();
}

class _State extends State<IndexedTitleView> {
  int? _actLetter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapUp: (_) {
          _onVerticalDragEnd();
        },
        onVerticalDragEnd: (details) {
          _onVerticalDragEnd(details: details);
        },
        onVerticalDragDown: _onVerticalDragUpdate,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 10, right: 3),
          child: Column(
            children: _letterList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _letterList() {
    List<Widget> titles = [];
    for (int i = 0; i < widget.sectionIndexTitles.length; i++) {
      final title = widget.sectionIndexTitles[i];
      titles.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: i == _actLetter ? (widget.selectedStyle ?? widget.defaultStyle) : widget.defaultStyle
        ),
      ));
    }
    return titles;
  }

  void _onVerticalDragUpdate(details) {
    if (context.size == null) return;
    final height = context.size!.height;
    var eachHeight = height / widget.sectionIndexTitles.length;
    if (details.localPosition.dy <= 0) {
      _actLetter = 0;
    } else if (details.localPosition.dy >= height) {
      _actLetter = widget.sectionIndexTitles.length - 1;
    } else {
      _actLetter = details.localPosition.dy ~/ eachHeight;
    }
    setState(() {});

    widget.selected(_actLetter);
  }

  void _onVerticalDragEnd({details}) {
    setState(() {
      _actLetter = null;
      widget.selected(_actLetter);
    });
  }
}
