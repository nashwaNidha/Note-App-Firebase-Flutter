import 'package:fb_noteapp/themes/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/colorprovider.dart';
import '../services/firestore_services.dart';
import '../themes/color_picker.dart';

class EditNotes extends StatefulWidget {
  final String docId;
  final String currentNote;
  final int currentcolor;
  const EditNotes(
      {super.key,
      required this.docId,
      required this.currentNote,
      required this.currentcolor});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final FirestoreService fireStoreService = FirestoreService();
  TextEditingController noteController = TextEditingController();
  @override
  void initState() {
    Provider.of<ColorProvider>(context, listen: false).setindextoZero();
    iskk();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    noteController.dispose();
  }

  void iskk() {
    Provider.of<ColorProvider>(context, listen: false)
        .iskkk(widget.currentcolor);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ColorProvider>(context, listen: true);

    noteController.text = widget.currentNote;

    var newColor;
    newColor = themeData.isSelected
        ? bgColor[themeData.selectedIndex]
        : bgColor[widget.currentcolor];

    return WillPopScope(
      onWillPop: () async {
        await fireStoreService.updateData(
            widget.docId, noteController.text, themeData.selectedIndex);
        themeData.isSelectedFalse();
        return true;
      },
      child: Scaffold(
        backgroundColor: newColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await fireStoreService.updateData(
                widget.docId, noteController.text, themeData.selectedIndex);
            themeData.isSelectedFalse();

            Navigator.of(context).pop();
          },
        ),
        appBar: AppBar(title: const Text("edit Note")),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
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
                      width: 60,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Center(child: const Text("Color"))))
            ],
          ),
        ),
      ),
    );
  }
}
