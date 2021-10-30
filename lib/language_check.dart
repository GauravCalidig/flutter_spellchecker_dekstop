import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboardesk/main.dart';
import 'package:keyboardesk/rich_text_controller.dart';
import 'package:language_tool/language_tool.dart';
import 'package:new_keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:path_provider/path_provider.dart';

class LanguageCheck extends StatefulWidget {
  const LanguageCheck({Key? key}) : super(key: key);

  @override
  _LanguageCheckState createState() => _LanguageCheckState();
}

class _LanguageCheckState extends State<LanguageCheck> {
  bool loading = false;
  // final TextEditingController controller = TextEditingController();
  String resp = "";

  late RichTextController _controller = RichTextController(
    stringMap: {"gaurav": TextStyle(color: Colors.red)},
  );
  @override
  void initState() {
    super.initState();
    getTranslation();
  }

  getTranslation() async {
    Clipboard.getData('text/plain').then((data) async {
      if (data != null && data.text != null) {
        _controller.text = data.text ?? "";
        setState(() {
          loading = true;
        });
        try {
          var tool = LanguageTool();
          var result = await tool.check(data.text!);
          setState(() {
            resp = result.toString();
            loading = false;
            _controller = RichTextController(
                text: data.text,
                stringMap: {"Writing": const TextStyle(color: Colors.red)});
          });
        } catch (e) {
          Get.snackbar("Error", e.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          setState(() {
            resp = "";
            loading = false;
          });
        }
      }
    });
  }

  String directory = "";
  List<FileSystemEntity> file = [];

  getTaskbar() async {
    //%appdata%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
    directory = (await getTemporaryDirectory()).path;
    directory = (await getApplicationDocumentsDirectory()).path;
    directory = (await getApplicationSupportDirectory()).path;
    // directory = (await getExternalStorageDirectory())!.path;

    directory = directory.replaceAll("com.example\\keyboardesk", "");
    print(directory);
    // setState(() {
    //can check implict app shortcut in same folder as well
    //TODO pin app to taskbar programatically
    file = Directory(
            "$directory/Microsoft/Internet Explorer/Quick Launch/User Pinned/TaskBar")
        .listSync(); //use your folder name insted of resume.
    // });
    print(file);
    bool contains = false;
    file.forEach((element) {
      print(element);
      if (element.toString().toLowerCase().contains("flutter")) {
        contains = true;
      }
    });
    if (!contains) {
      Get.snackbar("Error", "Please pin the app to taskbar",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTaskbar();
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.to(() => MyHomePage()),
              icon: Icon(Icons.home)),
          title: Text('Language Check'),
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
          getTranslation();
        },
        helpLabel: "Go to Second Page",
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                maxLines: 10,
                controller: _controller,
                decoration: const InputDecoration(
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
//get selected text without ctrl c
//?https://stackoverflow.com/questions/21460943/how-to-get-selected-text-of-any-application-into-a-windows-form-application