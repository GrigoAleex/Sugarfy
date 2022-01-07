import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sugarfy/modals/create_form.modal.dart';
import 'package:sugarfy/modals/log.modal.dart';
import 'sql_helper.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sugarfy',
      theme: ThemeData(
          backgroundColor: Colors.teal.shade900, fontFamily: "Roboto"),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _logs = [];

  void _refreshLogs() async {
    final data = await SQLHelper.index();
    setState(() {
      _logs = data;
    });
  }

  void _showForm() async {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      builder: (_) => CreateForm(refreshScreen: _refreshLogs),
    );
  }

  num consumedToday() {
    num sum = 0;
    for (var log in _logs) {
      if (DateTime.now().difference(DateTime.parse(log["createdAt"])).inDays < 1) {
        sum += log['grammage'];
      }
    }
    return sum;
  }

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 36),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Astăzi ai consumat\n', 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: consumedToday().toString() + "g", 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 57
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: const Text(
                    "Istoric activitate",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.tealAccent[400]),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _logs.length,
                    itemBuilder: (context, index) => Log(
                      id: _logs[index]['id'],
                      title: _logs[index]['grammage'].toString(),
                      timestamps: _logs[index]['createdAt'],
                      refreshScreen: _refreshLogs,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }
}
