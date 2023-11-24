import 'package:flutter/material.dart';

import '../providers/colorprovider.dart';
import 'mytheme.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.themeData,
  });

  final ColorProvider themeData;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 12, crossAxisSpacing: 8, crossAxisCount: 4),
          itemCount: bgColor.length,
          itemBuilder: (context, index) {
            bool isSelected = index == widget.themeData.selectedIndex;
            return InkWell(
              onTap: () {
                setState(() {
                  final selIndex = index;
                  widget.themeData.setIndex(selIndex);
                });
                // themeData.selectedBorder(selIndex);
                // Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2),
                    borderRadius: BorderRadius.circular(100),
                    color: bgColor[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
