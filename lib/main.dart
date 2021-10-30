import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboardesk/copy_paste.dart';
import 'package:keyboardesk/drag_drop.dart';
import 'package:keyboardesk/language_check.dart';
import 'package:new_keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:process_run/shell.dart';

void main() {
  runApp(const MyApp());
  //runShell();
}

runShell() async {
  var shell = Shell();

  var resp = await shell.run('''

cd

# Display some text
powershell "\$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Start Menu\Programs\Startup\CWarp_DoH.lnk');\$s.TargetPath='E:\Program\CloudflareWARP\warp-cli.exe';\$s.Arguments='connect';\$s.IconLocation='E:\Program\CloudflareWARP\Cloudflare WARP.exe';\$s.WorkingDirectory='E:\Program\CloudflareWARP';\$s.WindowStyle=7;\$s.Save()"

# Display dart version
dart --version

# Display pub version
pub --version

''');
  log(resp[0].stdout);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Desktop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LanguageCheck());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyP},
        onKeysPressed: () {
          setState(() {
            _counter++;
          });
        },
        helpLabel: "Go to Second Page",
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Get.to(() => CopyPaste());
                  },
                  child: Text("Copy Paste")),
              TextButton(
                  onPressed: () {
                    Get.to(() => LanguageCheck());
                  },
                  child: Text("Language Check")),
              const ExmapleDragTarget(),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
