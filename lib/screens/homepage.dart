import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_noteapp/screens/add_notes.dart';
import 'package:fb_noteapp/themes/mytheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/firestore_services.dart';
import 'edit_notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService fireStoreService = FirestoreService();
  bool isGridView = true;
  void changeGrid() {
    isGridView = !isGridView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes"), actions: [
        IconButton(
            onPressed: () {
              setState(() {
                changeGrid();
              });
            },
            icon: !isGridView
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list)),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout)),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddNotePage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("NoteApp")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("notes")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return isGridView
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot data = snapshot.data!.docs[index];

                        var docID = snapshot.data!.docs[index].id;

                        if (kDebugMode) {
                          print(data);
                        }
                        int selColorIndex = data["colorIndex"];
                        String notes = data['title'];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GridTile(
                            // isThreeLine: true,
                            header: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(notes),
                            ),

                            footer: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit_note),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => EditNotes(
                                              docId: docID,
                                              currentNote: data['title'],
                                              currentcolor: selColorIndex),
                                        ));
                                      }),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        fireStoreService.deleteData(docID);
                                      }),
                                ],
                              ),
                            ),
                            //background  color
                            child: Container(
                              decoration: BoxDecoration(
                                  color: bgColor[selColorIndex],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot data = snapshot.data!.docs[index];

                        var docID = snapshot.data!.docs[index].id;

                        if (kDebugMode) {
                          print(data);
                        }
                        int selColorIndex = data["colorIndex"];
                        String notes = data['title'];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListTile(
                            // isThreeLine: true,
                            title: Text(notes),
                            //background  color
                            tileColor: bgColor[selColorIndex],
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit_note),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => EditNotes(
                                              docId: docID,
                                              currentNote: data['title'],
                                              currentcolor: selColorIndex),
                                        ));
                                      }),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        fireStoreService.deleteData(docID);
                                      }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return const Center(
                child: Text("No Notes"),
              );
            }
          }),
    );
  }
}
