

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/database/DBHandler.dart';
import 'package:notes/widgets/FormTextFieldDecoration.dart';

import '../models/Note.dart';
import '../constants.dart';

class AddNoteState extends State<AddNote>{

  DBHandler dbHandler = DBHandler();
  final GlobalKey<FormBuilderState> formBuildKey = GlobalKey<FormBuilderState>();


  void initDBHandler(){
    if (dbHandler == null) this.dbHandler = DBHandler();
  }

  //TODO: Prevent 'this field is required' message from showing up when first clicking on a field
  //FIXME: No language chosen results in an empty box
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
      resizeToAvoidBottomPadding: true,

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
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 6.0),
      children: <Widget>[
        FormBuilder(
          key: formBuildKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(3.0),
                child: FormBuilderTextField(
                  attribute: "title",
                  decoration: FormTextFieldDecoration().decoration(labelText: "Title"),
                  validators: [
                    FormBuilderValidators.maxLength(30, errorText: "Title is too long"),
                    FormBuilderValidators.required(errorText: "This field is required")
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(3.0),
                child: FormBuilderTextField(
                  attribute: "description",
                  decoration: FormTextFieldDecoration().decoration(labelText: "Description"),
                  validators: [
                    FormBuilderValidators.maxLength(120, errorText: "Description is too long"),
                    FormBuilderValidators.required(errorText: "This field is required")
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(3.0),
                child: FormBuilderTextField(
                  attribute: "content",
                  decoration: FormTextFieldDecoration().decoration(labelText: "Content"),
                  validators: [
                    FormBuilderValidators.required(errorText: "This field is required")
                  ],
                  minLines: 6,
                ),
              ),

              //FIXME: Suggestions appear below keyboard
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
                child: FormBuilderTypeAhead(
                  attribute: "language",
                  decoration: FormTextFieldDecoration().decoration(labelText: "Language"),
                  itemBuilder: (context, suggestion){
                    return ListTile(
                      title: Text("$suggestion"),
                    );
                  },
                  suggestionsCallback: (pattern){
                    print("Called suggestion $pattern");
                    List<String> genList = List<String>();

                    languages.forEach((language){
                      if (language.toLowerCase().contains(pattern.toLowerCase())) genList.add(language);
                    });

                    return genList;
                  },
                ),
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