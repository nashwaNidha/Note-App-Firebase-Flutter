import 'package:fb_noteapp/themes/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/colorprovider.dart';
import '../services/firestore_services.dart';
import '../themes/color_picker.dart';

class EditNotes extends StatefulWidget {
  final String docId;
  final String currentNote;
  final String currentDesc;

  final int currentcolor;
  const EditNotes(
      {super.key,
      required this.docId,
      required this.currentNote,
      required this.currentcolor,
      required this.currentDesc});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final FirestoreService fireStoreService = FirestoreService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    Provider.of<ColorProvider>(context, listen: false).setindextoZero();
    iskk();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
  }

  void iskk() {
    Provider.of<ColorProvider>(context, listen: false)
        .iskkk(widget.currentcolor);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ColorProvider>(context, listen: true);

    titleController.text = widget.currentNote;
    descController.text = widget.currentDesc;
    var newColor;
    newColor = themeData.isSelected
        ? bgColor[themeData.selectedIndex]
        : bgColor[widget.currentcolor];

    return Scaffold(
      backgroundColor: newColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await fireStoreService.updateData(
              widget.docId, titleController.text, themeData.selectedIndex);
          themeData.isSelectedFalse();
          titleController.clear();

          Navigator.of(context).pop();
        },
      ),
      appBar: AppBar(title: const Text("Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          // children: [
          //   const Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       "Title",
          //       style: TextStyle(fontSize: 40),
          //     ),
          //   ),
          //   SizedBox(
          //     height: 100,
          //     width: MediaQuery.of(context).size.width * 0.8,
          //     child: TextField(
          //       autocorrect: true,
          //       controller: titleController,
          //     ),
          //   ),
          children: [
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                autocorrect: true,
                decoration: InputDecoration(hintText: "Title"),
                controller: titleController,
              ),
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                autocorrect: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                ),
                controller: descController,
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

            // InkWell(
            //     onTap: () {
            //       showModalBottomSheet<void>(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return ColorPicker(themeData: themeData);
            //           });
            //     },
            //     child: Container(
            //         width: 60,
            //         decoration: BoxDecoration(color: Colors.grey[200]),
            //         child: Center(child: const Text("Color"))))
          ],
        ),
      ),
    );
  }
}
