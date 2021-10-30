import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:keyboardesk/api_call.dart';
import 'package:new_keyboard_shortcuts/keyboard_shortcuts.dart';

class CopyPaste extends StatefulWidget {
  const CopyPaste({Key? key}) : super(key: key);

  @override
  _CopyPasteState createState() => _CopyPasteState();
}

class _CopyPasteState extends State<CopyPaste> {
  bool loading = false;
  final TextEditingController controller = TextEditingController();
  @override
  List resp = [];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Copy Paste'),
          bottom: loading
              ? PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: LinearProgressIndicator(
                    color: Colors.deepOrange,
                  ))
              : null),
      body: KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyV},
        onKeysPressed: () {
          Clipboard.getData('text/plain').then((data) async {
            if (data != null && data.text != null) {
              controller.text = data.text ?? "";
              setState(() {
                loading = true;
              });
              try {
                await Translate().getTranslation(data.text!).then((value) {
                  print(value);
                  setState(() {
                    resp = value;
                    loading = false;
                  });
                });
              } catch (e) {
                Get.snackbar("Error", e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                setState(() {
                  resp = [];
                  loading = false;
                });
              }
            }
          });
        },
        helpLabel: "Go to Second Page",
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter text',
                  border: OutlineInputBorder(),
                ),
              ),
              Text(resp.toString())
            ],
          ),
        ),
      ),
    );
  }
}
