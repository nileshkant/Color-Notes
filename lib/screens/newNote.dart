import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/utils/sqlite_helper.dart';
import 'package:notes/models/note.dart';

class NewNote extends StatefulWidget {
  final Note noteObj;
  NewNote(this.noteObj);
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  var myController = TextEditingController();
  var titleController = TextEditingController();
  final sqlLiteHelper = SqlLiteHelper();
  String selectedColor = '373a40';
  Future<bool> navigatePrev;

  final backgroundColors = [
    '373a40',
    'dd2c00',
    '00bcd4',
    '070d59',
    'fddb3a',
    '9d65c9',
    'e11d74',
    '411f1f',
    '2b580c',
    '42dee1'
  ];

  @override
  void initState() {
    if (widget.noteObj != null) {
      setState(() {
        myController = TextEditingController(text: widget.noteObj.noteBody);
        titleController = TextEditingController(
            text: widget.noteObj.title != null ? widget.noteObj.title : "");
        selectedColor = widget.noteObj.background;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void _selectedColor(String color) {
    setState(() {
      selectedColor = color;
    });
  }

  Future _saveNote(String action) async {
    if (widget.noteObj == null) {
      final Note note = Note(
        title: titleController.text,
        noteBody: myController.text,
        createdDate: new DateTime.now().millisecondsSinceEpoch,
        updatedDate: new DateTime.now().millisecondsSinceEpoch,
        background: selectedColor,
      );
      await sqlLiteHelper.open();
      await sqlLiteHelper.insert(note);
    } else {
      final Note note = Note(
        id: widget.noteObj.id,
        title: titleController.text,
        noteBody: myController.text,
        createdDate: widget.noteObj.createdDate,
        updatedDate: new DateTime.now().millisecondsSinceEpoch,
        background: selectedColor,
      );
      await sqlLiteHelper.open();
      await sqlLiteHelper.update(note);
    }

    if (action == 'save') {
      setState(() {
        navigatePrev = _navigateToList(null);
      });
    }
  }

  Future<bool> _navigateToList(String action) async {
    if (action == "hardwareBack" && myController.text.trim() != "") {
      await _saveNote(null);
    }
    Navigator.pop(context, 'saved');
    return Future<bool>.value(true);
  }

  Future _deleteNote() async {
    Note note = widget.noteObj;
    await sqlLiteHelper.open();
    await sqlLiteHelper.delete(note);
    Navigator.of(context).pop();
  }

  AlertDialog alert() {
    return AlertDialog(
      title: Text("Delete Note"),
      content: Text("Do you really want to delete?"),
      actions: [
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: () async {
            await _deleteNote();
            Navigator.pop(context, 'saved');
          },
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => navigatePrev = _navigateToList("hardwareBack"),
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Color(int.parse(
              'FF$selectedColor',
              radix: 16,
            )).withOpacity(0.5),
            title: Text(
              widget.noteObj?.id != null ? 'Edit Note' : 'New Note',
              style: Theme.of(context).textTheme.headline1,
            ),
            actions: [
              if (widget.noteObj?.id != null)
                IconButton(
                  icon: Icon(Icons.delete_outlined),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => alert(),
                  ),
                ),
            ],
          ),
          body: Container(
            decoration: new BoxDecoration(
                color: Color(
              int.parse(
                'FF$selectedColor',
                radix: 16,
              ),
            ).withOpacity(0.2)),
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: TextField(
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: TextField(
                        controller: myController,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Note',
                        ),
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: ListView.builder(
                      itemCount: backgroundColors.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              _selectedColor(backgroundColors[index]);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(int.parse(
                                    'FF${backgroundColors[index]}',
                                    radix: 16,
                                  )).withOpacity(
                                      selectedColor == backgroundColors[index]
                                          ? 1
                                          : 0),
                                ),
                                shape: BoxShape.circle,
                                color: Color(int.parse(
                                  'FF${backgroundColors[index]}',
                                  radix: 16,
                                )).withOpacity(0.4),
                              ),
                              child: Center(child: Text('')),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _saveNote('save');
            },
            tooltip: 'Save Note',
            label: Text('Save'),
          )),
    );
  }
}
