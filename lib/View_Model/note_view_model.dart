import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/note_model.dart';

class NoteViewModel with ChangeNotifier {
  bool isDark = true;
  set setIsDark(bool newValue) {
    isDark = newValue;
    notifyListeners();
  }

  bool isLoading = true;

  List<NoteModel> noteList = [];

  void getNotes() async {
    print(userId);
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    fireStore
        .collection('$userId-notes')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      noteList.clear();
      for (var element in event.docs) {
        NoteModel note = NoteModel.fromJson(element.data());
        noteList.add(note);
      }
      isLoading = false;
      notifyListeners();
    });
  }

  String? userId;
  set setUserId(String? newValue) {
    userId = newValue;
    notifyListeners();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    noteList.clear();
    notifyListeners();
  }
}
