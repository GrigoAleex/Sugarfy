import 'package:flutter/material.dart';
import 'package:sugarfy/sql_helper.dart';


class Log extends StatelessWidget {
  final int id;
  final String title, timestamps;
  final Function refreshScreen;

  const Log({
    Key? key,
    required this.id,
    required this.title,
    required this.timestamps,
    required this.refreshScreen,
  }) : super(key: key);

  void _destroy() async {
    await SQLHelper.destroy(id);
    refreshScreen();
    
    const ScaffoldMessenger(
      child: SnackBar(
        content: Text("Istoric șters cu succes!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: ListTile(
        title: Text("$title grame | $id id"),
        subtitle: Text(timestamps),
        trailing: IconButton(
            icon: const Icon(Icons.delete), onPressed: () => _destroy()),
      ),
    );
  }
}
