import 'package:flutter/material.dart';

class NoteModel with ChangeNotifier {
  String notesValue = 'Hello';

  void doSomething() {
    notesValue = 'Goodbye';
    notifyListeners();
  }
}
