import 'package:flutter/material.dart';
import 'package:grouped_listview/grouped_listview.dart';

void main() {
  runApp(const MyApp());
}

List<dynamic> dummyData = [
  {'name': 'Tea', 'age': 19},
  {'name': 'Ana', 'age': 19},
  {'name': 'Holy', 'age': 14},
  {'name': 'Tom', 'age': 19},
  {'name': 'Cindy', 'age': 16},
  {'name': 'Aaron', 'age': 22},
  {'name': 'Peter', 'age': 11},
  {'name': 'Paul', 'age': 12},
  {'name': 'Zara', 'age': 16},
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GroupedListView Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'GroupedListView Example'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: dummyData.groupedBySorting(groupBy: (element) => (element['age']), compareBy: (
            element) => (element['name']), headerBuilder:  (element) =>
        (ListTile(title: Text(element['age'].toString()))), itemBuilder: (element) =>
        (Card(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(element['name']),
        ))), separatorBuilder: ()=>(const SizedBox.shrink())),
      ),
    );
  }
}
