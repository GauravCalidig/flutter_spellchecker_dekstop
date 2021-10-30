import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:mime/mime.dart';

class ExmapleDragTarget extends StatefulWidget {
  const ExmapleDragTarget({Key? key}) : super(key: key);

  @override
  _ExmapleDragTargetState createState() => _ExmapleDragTargetState();
}

class _ExmapleDragTargetState extends State<ExmapleDragTarget> {
  final List<Uri> _list = [];

  bool _dragging = false;
  String data = "";
  readFile() async {
    for (var item in _list) {
      var path = _list[0].toFilePath();
      final mimeType = lookupMimeType(path);
      print(mimeType);
      if (mimeType == "text/plain" || mimeType == "application/msword") {
        final File file = File(path);
        var text = await file.readAsString();
        var tool = LanguageTool();
        var result = await tool.check(text);

        setState(() {
          data = result.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropTarget(
          onDragDone: (detail) {
            setState(() {
              _list.addAll(detail.urls);
              readFile();
            });
          },
          onDragEntered: (detail) {
            setState(() {
              _dragging = true;
            });
          },
          onDragExited: (detail) {
            setState(() {
              _dragging = false;
            });
          },
          child: Container(
            height: 200,
            width: 200,
            color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
            child: _list.isEmpty
                ? const Center(child: Text("Drop here"))
                : Text(_list.join("\n")),
          ),
        ),
        Text(data)
      ],
    );
  }
}
