import 'package:calculator_vault_app/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../colors.dart';


class ImageInGrid extends StatefulWidget {
  final Function(bool) onSelect;
  final Uint8List bytes;
  const ImageInGrid({super.key, required this.onSelect, required this.bytes});

  @override
  State<ImageInGrid> createState() => _ImageInGridState();
}

class _ImageInGridState extends State<ImageInGrid> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => selected = !selected);
        widget.onSelect(selected);
      },
      child: Container(
        padding: selected ? const EdgeInsets.all(4) : null,
        decoration: BoxDecoration(
          border: selected ? Border.all(color: fourthColor, width: 2) : null,
          image: DecorationImage(
            image: MemoryImage(widget.bytes),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(7),),
        ),
        child: selected
            ? const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.check_circle, color: fourthColor),
              )
            : null,
      ),
    );
  }
}
