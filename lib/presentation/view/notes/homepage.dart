import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_noteapp/presentation/view/notes/add_notes.dart';
import 'package:fb_noteapp/themes/mytheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_services.dart';
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
    return Stack(children: [
      Image.asset("assets/bg1.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover),
      Scaffold(
        // extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: const Text("Your Notes"),
            automaticallyImplyLeading: false,
            actions: [
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
          backgroundColor: Colors.amber[50],
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
                          QueryDocumentSnapshot data =
                              snapshot.data!.docs[index];

                          var docID = snapshot.data!.docs[index].id;

                          if (kDebugMode) {
                            print(data);
                          }
                          int selColorIndex = data["colorIndex"];
                          String notes = data['title'];
                          String desc = data['desc'];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNotes(
                                  docId: docID,
                                  currentNote: data['title'],
                                  currentcolor: selColorIndex,
                                  currentDesc: data['desc'],
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Dismissible(
                                key: ValueKey(docID),
                                background: Container(
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 202, 23, 11),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 40,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        backgroundColor: Colors.white,
                                        content: const Text(
                                            "Are you sure to delete this item?"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE")),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                direction: DismissDirection.endToStart,
                                onDismissed: (DismissDirection direction) {
                                  fireStoreService.deleteData(docID);
                                },
                                child: GridTile(
                                  //  isThreeLine: true,
                                  header: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(notes),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30.0),
                                          child: Text(
                                            desc,
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  footer: const SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        // IconButton(
                                        //     icon: const Icon(Icons.edit_note),
                                        //     onPressed: () {
                                        //       Navigator.of(context)
                                        //           .push(MaterialPageRoute(
                                        //         builder: (context) => EditNotes(
                                        //           docId: docID,
                                        //           currentNote: data['title'],
                                        //           currentcolor: selColorIndex,
                                        //           currentDesc: data['desc'],
                                        //         ),
                                        //       ));
                                        //     }),
                                        // IconButton(
                                        //     icon: const Icon(Icons.delete),
                                        //     onPressed: () {
                                        //       fireStoreService
                                        //           .deleteData(docID);
                                        //     }),
                                      ],
                                    ),
                                  ),
                                  //background  color
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: bgColor[selColorIndex],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot data =
                              snapshot.data!.docs[index];

                          var docID = snapshot.data!.docs[index].id;

                          if (kDebugMode) {
                            print(data);
                          }
                          int selColorIndex = data["colorIndex"];
                          String notes = data['title'];
                          String desc = data['desc'];

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNotes(
                                  currentNote: notes,
                                  currentcolor: selColorIndex,
                                  docId: docID,
                                  currentDesc: desc,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Dismissible(
                                key: ValueKey(docID),
                                background: Container(
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 202, 23, 11),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 40,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        backgroundColor: Colors.white,
                                        content: const Text(
                                            "Are you sure to delete this item?"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE")),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                direction: DismissDirection.endToStart,
                                onDismissed: (DismissDirection direction) {
                                  fireStoreService.deleteData(docID);
                                },
                                child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: bgColor[selColorIndex],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            data['title'],
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            data['desc'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.end,
                                          //   // crossAxisAlignment:
                                          //   // CrossAxisAlignment.center,
                                          //   children: [
                                          //     // InkWell(
                                          //     //   onTap: () {
                                          //     //     Navigator.of(context)
                                          //     //         .push(MaterialPageRoute(
                                          //     //       builder: (context) =>
                                          //     //           EditNotes(
                                          //     //         currentNote: data['title'],
                                          //     //         currentcolor: selColorIndex,
                                          //     //         docId: docID,
                                          //     //         currentDesc: 'desc',
                                          //     //       ),
                                          //     //     ));
                                          //     //   },
                                          //     //   child: Icon(Icons
                                          //     //       .drive_file_rename_outline_outlined),
                                          //     // ),
                                          //     InkWell(
                                          //         onTap: () {
                                          //           // final newID = id;
                                          //           fireStoreService
                                          //               .deleteData(docID);
                                          //         },
                                          //         child: Icon(Icons.delete)),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    )),
                              ),

                              // child: ListTile(
                              //   // isThreeLine: true,
                              //   title: Text(notes),
                              //   //background  color
                              //   tileColor: bgColor[selColorIndex],
                              //   trailing: SizedBox(
                              //     width: 100,
                              //     child: Row(
                              //       children: [
                              //         IconButton(
                              //             icon: const Icon(Icons.edit_note),
                              //             onPressed: () {
                              //               Navigator.of(context)
                              //                   .push(MaterialPageRoute(
                              //                 builder: (context) => EditNotes(
                              //                     docId: docID,
                              //                     currentNote: data['title'],
                              //                     currentcolor: selColorIndex),
                              //               ));
                              //             }),
                              //         IconButton(
                              //             icon: const Icon(Icons.delete),
                              //             onPressed: () {
                              //               fireStoreService.deleteData(docID);
                              //             }),
                              //       ],
                              //     ),
                              //   ),
                              // ),
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
      ),
    ]);
  }
}
