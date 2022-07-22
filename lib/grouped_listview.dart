import 'package:flutter/cupertino.dart';

//this method sorts the given list in place
extension GroupedList<E, G, T> on List<E> {
  List<Widget> groupedBySorting({
    required G Function(E element) groupBy,
    required T Function(E element) compareBy,
    required Widget Function(E element) headerBuilder,
    required Widget Function(E element) itemBuilder,
    required Widget Function() separatorBuilder,
  }) {
    //widget list to be returned
    List<Widget> sortedWidgetList = [];

    //helper functions
    bool _areElementsFromSameGroup(E element1, E element2) =>
        groupBy(element1) == groupBy(element2);
    bool _isSeparator(int index) => index.isEven;

    //sort list
    if (isNotEmpty) {
      sort(
        (E a, E b) {
          int comparisonResult;
          comparisonResult =
              (groupBy(a) as Comparable).compareTo(groupBy(b) as Comparable);
          if (comparisonResult == 0) {
            comparisonResult = (compareBy(a) as Comparable)
                .compareTo(compareBy(b) as Comparable);
          }
          return comparisonResult;
        },
      );
    }

    //create grouped widget list to be returned
    for (int index = 0; index < length * 2; index++) {
      int itemIndex = index ~/ 2;
      int helperIndex = 0;
      int consecutiveElementIndex = itemIndex - 1;
      if (index == helperIndex) {
        sortedWidgetList.add(headerBuilder(this[itemIndex]));
      } else if (_isSeparator(index)) {
        //check if two consecutive elements are from the same group
        if (_areElementsFromSameGroup(
            this[itemIndex], this[consecutiveElementIndex])) {
          //if yes insert separator else insert header
          sortedWidgetList.add(separatorBuilder());
        } else {
          sortedWidgetList.add(headerBuilder(this[itemIndex]));
        }
      }
      //if index is not separator insert initial list item
      else {
        sortedWidgetList.add(itemBuilder(this[itemIndex]));
      }
    }
    return sortedWidgetList;
  }
}
