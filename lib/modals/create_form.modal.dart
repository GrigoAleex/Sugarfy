import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sugarfy/sql_helper.dart';

class CreateForm extends StatefulWidget {
  final Function refreshScreen;
  const CreateForm({Key? key, required this.refreshScreen}) : super(key: key);

  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final TextEditingController _grammageController = TextEditingController();

  Future<void> _store() async {
    await SQLHelper.store(int.parse(_grammageController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      height: 360,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text("Cât zahăr ai consumat?", textAlign: TextAlign.left),
            ),
            TextField(
              controller: _grammageController,
              decoration: const InputDecoration(hintText: 'Gramaj'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await _store();
                _grammageController.text = '';
                Navigator.of(context).pop();
                widget.refreshScreen();
              },
              child: const Text('Create New'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).backgroundColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
