import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/note_model.dart';

class NewNoteViewModel with ChangeNotifier {
  int currentColorId = 1;

  set setCurrentColorId(int newValue) {
    currentColorId = newValue;
    notifyListeners();
  }

  bool isSaved = false;

  Future<void> addNote(
      {required String userId,
      required String title,
      required String content,
      required int colorId,
      required BuildContext context}) async {
    if (title.isEmpty && content.isEmpty) {
      return;
    }
    isSaved = true;
    String randomId = FirebaseFirestore.instance.collection('coll').doc().id;
    NoteModel note = NoteModel(
      id: randomId,
      title: title,
      content: content,
      date: DateTime.now().toIso8601String(),
      colorId: colorId,
    );
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    await fireStore
        .collection('$userId-notes')
        .doc(randomId)
        .set(note.toJson());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Note added'),
      duration: Duration(seconds: 1),
    ));
  }

  Future<void> updateNote(
      {required String userId,
      required String title,
      required String content,
      required int colorId,
      required NoteModel oldNote,
      required BuildContext context}) async {
    if (title.isEmpty && content.isEmpty) {
      return;
    }
    isSaved = true;
    oldNote.title = title;
    oldNote.content = content;
    oldNote.colorId = colorId;
    oldNote.date = DateTime.now().toIso8601String();
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    await fireStore
        .collection('$userId-notes')
        .doc(oldNote.id)
        .update(oldNote.toJson());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Note updated'),
      duration: Duration(seconds: 1),
    ));
  }

  Future<void> deleteNote(
      {required String userId,
      required String noteId,
      required BuildContext context}) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    await fireStore.collection('$userId-notes').doc(noteId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Note deleted'),
      duration: Duration(seconds: 1),
    ));
    Navigator.pop(context);
  }
}
