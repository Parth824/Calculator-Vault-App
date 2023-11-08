import 'dart:convert';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../../colors.dart';
import '../../../../../main.dart';

class UpdateNotesPage extends StatefulWidget {
  const UpdateNotesPage({super.key, required this.index});

  final int index;

  @override
  State<UpdateNotesPage> createState() => _UpdateNotesPageState();
}

class _UpdateNotesPageState extends State<UpdateNotesPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final List<String> note = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  loadNotes() async {
    note.addAll(prefs.getStringList('Note') ?? []);
    Map data = jsonDecode(note[widget.index]);
    titleController.text = data['title'];
    descriptionController.text = data['description'];
    setState(() {});
  }

  saveNotes() async {
    await prefs.setStringList('Note', note);
  }

  addNote() {
    Map data = {
      "title": titleController.text,
      "date":
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "description": descriptionController.text
    };
    String jsonDocument = json.encode(data);
    print(jsonDocument);
    note[widget.index] = jsonDocument;
    setState(() {});
    saveNotes();
  }

  deleteNote(int index) {
    setState(() {
      note.removeAt(index);
    });
    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstColor,
      appBar: AppBar(
        backgroundColor: secondColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  descriptionController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter Title & Notes");
              } else {
                addNote();
                setState(() {});
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.done),
          ),
        ],
        title: Text(
          "Add Notes",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.18,
              ),
              TextFormField(
                controller: titleController,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: getProportionateScreenHeight(18),
                    fontFamily: "Gilroy"),
                onSaved: (newValue) {},
                validator: (value) {},
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight * 0.02),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight * 0.02),
                  ),
                  hintText: "Enter Title",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: getProportionateScreenHeight(18),
                    fontFamily: "Gilroy",
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              TextFormField(
                controller: descriptionController,
                maxLines: 8,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: getProportionateScreenHeight(18),
                    fontFamily: "Gilroy"),
                onSaved: (newValue) {},
                validator: (value) {},
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight * 0.02),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight * 0.02),
                  ),
                  hintText: "Type Your Secret Notes...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: getProportionateScreenHeight(18),
                    fontFamily: "Gilroy",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
