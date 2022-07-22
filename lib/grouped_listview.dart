import 'package:flutter/cupertino.dart';

extension GroupedList<E, G, T> on List<E> {
  List<Widget> groupedBySorting({
    required G Function(E element) groupBy,
    required T Function(E element) compareBy,
    required Widget Function(E element) headerBuilder,
    required Widget Function(E element) itemBuilder,
    required Widget Function() separatorBuilder,
  }) {
    List<Widget> sortedWidgetList = [];
    bool _areElementsFromSameGroup(E element1, E element2) =>
        groupBy(element1) == groupBy(element2);
    bool _isSeparator(int index) => index.isEven;
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
          //if yes return separator else return header
          sortedWidgetList.add(separatorBuilder());
        } else {
          sortedWidgetList.add(headerBuilder(this[itemIndex]));
        }
      }
      //if index is not separator return actual item
      else {
        sortedWidgetList.add(itemBuilder(this[itemIndex]));
      }
    }
    return sortedWidgetList;
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class GroupedListView<elementType, groupPropertyType, itemPropertyType>
    extends StatefulWidget {
  //the list to be divided in groups
  final List<elementType> elements;

  //function to return the property to group the elements by
  final groupPropertyType Function(elementType element) groupBy;

  //function to extract item comparing property
  final itemPropertyType Function(elementType element)? compareBy;

  //custom item builder to use in the listview builder
  final Widget Function(elementType element) itemBuilder;

  //custom header builder to use in the listview builder
  final Widget Function(elementType element) headerBuilder;

  //custom separator builder to use in the listview builder
  final Widget Function()? separatorBuilder;

  //function to compare items of same group for stable sorting
  final int Function(elementType element1, elementType element2)?
  itemCompare;

  //default to true
  final bool sort;

  //adding all the properties of the listview
  final Axis? scrollDirection;

  final bool? reverse;

  final ScrollController? controller;

  final bool? primary;

  final ScrollPhysics? physics;

  final bool shrinkWrap;

  final EdgeInsetsGeometry? padding;

  final double? itemExtent;

  final Widget? prototypeItem;

  final int? Function(Key)? findChildIndexCallback;

  final bool addAutomaticKeepAlives;

  final bool addRepaintBoundaries;

  final bool addSemanticIndexes;

  final double? cacheExtent;

  final int? semanticChildCount;

  final DragStartBehavior dragStartBehavior;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  final String? restorationId;

  final Clip clipBehavior;

  const GroupedListView({
    Key? key,
    required this.elements,
    required this.groupBy,
    required this.itemBuilder,
    required this.headerBuilder,
    this.separatorBuilder,
    this.itemCompare,
    this.sort = true,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.findChildIndexCallback,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.compareBy,
    this.addAutomaticKeepAlives = true,
  }) : super(key: key);

  @override
  State<GroupedListView<elementType, groupPropertyType, itemPropertyType>>
  createState() =>
      _GroupedListViewState<elementType,
          groupPropertyType,
          itemPropertyType>();
}

class _GroupedListViewState<elementType, groupPropertyType, itemPropertyType>
    extends State<
        GroupedListView<elementType, groupPropertyType, itemPropertyType>> {
  List<elementType> sortedElements = [];

  @override
  Widget build(BuildContext context) {
    //sort the list by property groupBy/compareBy if sort == true
    sortedElements = _sortList();

    //custom item builder
    Widget customItemBuilder(BuildContext context, int index) {
      int itemIndex = index ~/ 2;
      int helperIndex = (widget.reverse!) ? sortedElements.length * 2 - 1 : 0;
      int consecutiveElementIndex =
      (widget.reverse!) ? itemIndex + 1 : itemIndex - 1;

      //return a header (either on beginning or end)
      if (index == helperIndex) {
        return _buildHeaderHelper(sortedElements[itemIndex]);
      } else if (_isSeparator(index)) {
        //check if two consecutive elements are from the same group
        if (_areElementsFromSameGroup(sortedElements[itemIndex],
            sortedElements[consecutiveElementIndex])) {
          //if yes return separator else return header
          if (widget.separatorBuilder != null) {
            return _buildSeparatorHelper();
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return _buildHeaderHelper(sortedElements[itemIndex]);
        }
      }
      //if index is not separator return actual item
      else {
        return _buildItemHelper(sortedElements[itemIndex]);
      }
    }

    return ListView.builder(
      itemCount: widget.elements.length * 2,
      itemBuilder: customItemBuilder,
      scrollDirection: widget.scrollDirection!,
      reverse: widget.reverse!,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemExtent: widget.itemExtent,
      prototypeItem: widget.prototypeItem,
      findChildIndexCallback: widget.findChildIndexCallback,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
    );
  }

  // function to sort the list by given property
  List<elementType> _sortList() {
    List<elementType> sortedElements = widget.elements;

    if (widget.elements.isNotEmpty && widget.sort) {
      widget.elements.sort(
            (elementType a, elementType b) {
          int comparisonResult;
          comparisonResult = (widget.groupBy(a) as Comparable)
              .compareTo(widget.groupBy(b) as Comparable);

          //if the two elements are from the same group
          if (comparisonResult == 0) {
            if (widget.itemCompare != null) {
              comparisonResult = widget.itemCompare!(a, b);
            } else if (widget.compareBy != null) {
              comparisonResult = (widget.compareBy!(a) as Comparable)
                  .compareTo(widget.compareBy!(b) as Comparable);
            }
          }
          return comparisonResult;
        },
      );
    }
    return sortedElements;
  }

  //helper functions

  //check if list item is separator or element
  _isSeparator(int index) => (widget.reverse!) ? index.isOdd : index.isEven;

  Widget _buildHeaderHelper(elementType element) =>
      widget.headerBuilder(element);

  Widget _buildItemHelper(elementType element) => widget.itemBuilder(element);

  Widget _buildSeparatorHelper() => widget.separatorBuilder!();

  bool _areElementsFromSameGroup(elementType element1, elementType element2) =>
      widget.groupBy(element1) == widget.groupBy(element2);
}*/
