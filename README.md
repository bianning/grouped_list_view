# grouped_list_view


## Getting Started

## 添加依赖

```yaml
dependencies:
    grouped_list_view:
        git:
          url: git@github.com:bianning/grouped_list_view.git
          ref: master
```

## 示例
```dart
import 'package:grouped_list_view/grouped_list_view.dart';
GroupedListView.builder(
    sectionBuilder: (context, section) {
    return Container(
      color: Colors.green,
      child: Text('section $section')
      );
    },
    sectionsCount: 2,
    itemCountInSection: (section) {
    return 10;
    },
    itemBuilder: (context, indexPath) {
    return Container(
      height: indexPath.section == 0 ? 50 : 100,
      child: Text('${indexPath.section}---${indexPath.index}'),
    );
    },
    showIndexTitle: true,//是否使用索引
    sectionIndexTitles: ['A', 'B']);//如果使用索引，则可以传入索引标题数组
}
```
