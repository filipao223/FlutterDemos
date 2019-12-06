

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/database/DBHandler.dart';

import '../classes/Note.dart';
import '../constants.dart';

class AddNoteState extends State<AddNote>{

  DBHandler dbHandler;
  final GlobalKey<FormBuilderState> formBuildKey = GlobalKey<FormBuilderState>();


  void initDBHandler(){
    this.dbHandler = DBHandler();
  }

  //TODO: Prevent 'this field is required' message from showing up when first clicking on a field
  void onSavePressed() async{

    if (formBuildKey.currentState.saveAndValidate()){

      await dbHandler.init();
      await dbHandler.checkCurrentId(isNote);

      Note note = Note(noteId: dbHandler.currentNoteId,
          noteTitle: formBuildKey.currentState.value['title'],
          noteDescription: formBuildKey.currentState.value['description'],
          noteContent: formBuildKey.currentState.value['content'],
          noteLanguage: formBuildKey.currentState.value.containsKey("language") ? formBuildKey.currentState.value['language'] : "none",
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          isSaved: false
      );

      await dbHandler.addNote(note);

      Fluttertoast.showToast(msg: "Added new note", toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, note);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: Text("Add new note"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: onSavePressed,)
        ],
      ),

      body: buildForm(),
    );
  }



  Widget buildForm(){
    return Column(
      children: <Widget>[
        FormBuilder(
          key: formBuildKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                attribute: "title",
                decoration: InputDecoration(labelText: "Title"),
                validators: [
                  FormBuilderValidators.maxLength(30, errorText: "Title is too long"),
                  FormBuilderValidators.required(errorText: "This field is required")
                ],
              ),

              FormBuilderTextField(
                attribute: "description",
                decoration: InputDecoration(labelText: "Description"),
                validators: [
                  FormBuilderValidators.maxLength(120, errorText: "Description is too long"),
                  FormBuilderValidators.required(errorText: "This field is required")
                ],
              ),

              FormBuilderTextField(
                attribute: "content",
                decoration: InputDecoration(labelText: "Content"),
                validators: [
                  FormBuilderValidators.required(errorText: "This field is required")
                ],
              ),

              FormBuilderTypeAhead(
                attribute: "language",
                decoration: InputDecoration(labelText: "Language"),
                itemBuilder: (context, suggestion){
                  return ListTile(
                    title: Text("$suggestion"),
                  );
                },
                suggestionsCallback: (pattern){
                  List<String> genList = List<String>();

                  languages.forEach((language){
                    if (language.toLowerCase().contains(pattern.toLowerCase())) genList.add(language);
                  });

                  return genList;
                },
              ),

            ],
          ),
        )
      ],
    );
  }
}


class AddNote extends StatefulWidget{

  AddNoteState createState(){
    AddNoteState addNoteState = AddNoteState();
    addNoteState.initDBHandler();
    return addNoteState;
  }
}