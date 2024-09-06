import 'package:fb_noteapp/providers/colorprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/ksnackbar.dart';
import '../../../services/firestore_services.dart';
import '../../../themes/color_picker.dart';
import '../../../themes/mytheme.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({
    super.key,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final FirestoreService fireStoreService = FirestoreService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    Provider.of<ColorProvider>(context, listen: false).setindextoZero();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ColorProvider>(context, listen: true);

    return PopScope(
      canPop: true,
      // onPopInvoked:return true;,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor[themeData.selectedIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber[50],
          onPressed: () {
            if (titleController.text == '') {
              ScaffoldMessenger.of(context).showSnackBar(terrSnackbar);
            } else if (descController.text == '') {
              ScaffoldMessenger.of(context).showSnackBar(derrSnackbar);
            } else {
              String title = titleController.text;

              String description = descController.text;
              fireStoreService.addNotebasedUser(
                  title, description, themeData.selectedIndex);
              ScaffoldMessenger.of(context).showSnackBar(saveSuccessSnackbar);
              titleController.clear();
              descController.clear();
              Navigator.of(context).pop();
            }

            // fireStoreService.addNotebasedUser(
            //     titleController.text,descController.text, themeData.selectedIndex, );

            // Navigator.of(context).pop();
          },
          child: const Icon(Icons.save_alt_outlined),
        ),
        appBar: AppBar(
          title: const Text("Add Note"),
          backgroundColor: bgColor[themeData.selectedIndex],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  autocorrect: true,
                  decoration: const InputDecoration(hintText: "Title"),
                  controller: titleController,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  autocorrect: true,
                  maxLines: null,
                  decoration: const InputDecoration(
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
                      width: 150,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.grey[500],
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
