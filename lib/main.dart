import 'package:flutter/material.dart';
import 'package:flutter_application_meal/neis_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  dynamic mealList = Text("검색하세요");

  void showCal() async {
    var dt = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2023, 03, 02),
        lastDate: DateTime(2023, 12, 30));
    String fromDate = dt.toString().split(' ')[0].replaceAll('-', '');
    String toDate = dt.toString().split(' ')[3].replaceAll('-', '');
    var neisApi = NeisApi();
    var meals = await neisApi.getMeal(fromDate: fromDate, toDate: toDate);
    setState(() {
      mealList = ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(meals[index]['MLSV_YMD']),
              subtitle: Text(meals[index]['DDISH_NM']
                  .toString()
                  .replaceAll('<br/>', '\n')),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: meals.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text("20230101"), Expanded(child: mealList)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCal,
        child: Icon(Icons.calendar_month),
      ),
    );
  }
}
