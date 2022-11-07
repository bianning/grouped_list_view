import 'package:flutter/material.dart';

class IndexedTitleView extends StatefulWidget {
  List<String> sectionIndexTitles;
  Color titleColor = Colors.black;
  Color primaryColor = Color(0xff31bebc);
  Function(int?) selected;
  IndexedTitleView(this.sectionIndexTitles, this.titleColor, this.primaryColor, this.selected);
  @override
  _State createState() => _State();
}

class _State extends State<IndexedTitleView> {
  int? _actLetter;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 60,
      child: Center(
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
            child: Column(
              children: _letterList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _letterList() {
    List<Widget> titles = [];
    for (int i = 0; i < widget.sectionIndexTitles.length; i++) {
      final title = widget.sectionIndexTitles[i];
      titles.add(Container(
        padding: EdgeInsets.only(right: 10),
        width: 60,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: i == _actLetter ? widget.primaryColor : widget.titleColor,
              fontSize: i == _actLetter ? 14 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
    }
    return titles;
  }

  void _onVerticalDragUpdate(details) {
    if (context.size == null) return;
    final height  = context.size!.height;
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
