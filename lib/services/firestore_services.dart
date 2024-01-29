import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  void addNotebasedUser(String title, String descData, int colorIndex) async {
    FirebaseFirestore.instance
        .collection('NoteApp')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .add({
      'title': title,
      'desc': descData,
      'colorIndex': colorIndex,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> updateData(
      String id, String title, String descData, int colorIndex) async {
    FirebaseFirestore.instance
        .collection('NoteApp')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .doc(id)
        .update({
      'title': title,
      'desc': descData,
      'colorIndex': colorIndex,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> deleteData(String id) async {
    await FirebaseFirestore.instance
        .collection("NoteApp")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .doc(id)
        .delete();
  }
}
