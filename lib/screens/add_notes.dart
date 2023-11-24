import 'package:fb_noteapp/providers/colorprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firestore_services.dart';
import '../themes/color_picker.dart';
import '../themes/mytheme.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({
    super.key,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final FirestoreService fireStoreService = FirestoreService();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    Provider.of<ColorProvider>(context, listen: false).setindextoZero();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ColorProvider>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        fireStoreService.addNotebasedUser(
            noteController.text, themeData.selectedIndex);
        themeData.setindextoZero();
        return true;
      },
      child: Scaffold(
        backgroundColor: bgColor[themeData.selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            fireStoreService.addNotebasedUser(
                noteController.text, themeData.selectedIndex);

            Navigator.of(context).pop();
          },
          child: const Icon(Icons.save_outlined),
        ),
        appBar: AppBar(title: const Text("Add Note")),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  autocorrect: true,
                  controller: noteController,
                ),
              ),
              InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return ColorPicker(themeData: themeData);
                        });
                  },
                  child: Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text("Color"),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
