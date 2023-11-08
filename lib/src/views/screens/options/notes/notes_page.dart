import 'dart:convert';

import 'package:calculator_vault_app/src/views/screens/options/notes/add_notes.dart';
import 'package:calculator_vault_app/src/views/screens/options/notes/update_notes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../colors.dart';
import '../../../../../main.dart';
import '../../../../../size_config.dart';
import '../../../../models/notes_model.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Notes> NoteList = [];
  List<String> NoteList1 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    NoteList1 = prefs.getStringList("Note") ?? [];
    if (NoteList1.isNotEmpty) {
      NoteList = NoteList1.map((e) => Notes.json(jsonDecode(e))).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final String title = sharedPreferences.getString('title') ?? '';
    // final String description = sharedPreferences.getString('description') ?? '';
    return Scaffold(
      backgroundColor: firstColor,
      appBar: AppBar(
        backgroundColor: secondColor,
        centerTitle: true,
        title: Text(
          "Notes",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: fourthColor,
        onPressed: () async {
          await Get.to(
            () => AddNotesPage(),
            duration: Duration(milliseconds: 500),
            transition: Transition.fade,
            curve: Curves.easeInOut,
          );
          loadData();
        },
        child: Icon(
          Icons.add,
          color: firstColor,
          size: getProportionateScreenHeight(25),
        ),
      ),
      body: ListView.builder(
        itemCount: NoteList1.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return (NoteList1.isEmpty)
              ? Center(
                  child: Text("Add Notes Here"),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenHeight(10),
                    right: getProportionateScreenHeight(10),
                    top: getProportionateScreenHeight(10),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await Get.to(() => UpdateNotesPage(index: index));
                      loadData();
                    },
                    child: Container(
                      height: SizeConfig.screenHeight * 0.09,
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.only(
                          left: getProportionateScreenHeight(15)),
                      decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                NoteList[index].title,
                                style: TextStyle(
                                  fontFamily: "Gilroy",
                                  fontSize: getProportionateScreenHeight(18),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                NoteList[index].date,
                                style: TextStyle(
                                  fontFamily: "Gilroy",
                                  fontSize: getProportionateScreenHeight(14),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () async {
                              print(index);
                              NoteList1.removeWhere(
                                  (element) => element == NoteList1[index]);

                              await prefs.setStringList("Note", NoteList1);
                              loadData();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
