

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/DBHandler.dart';
import 'package:notes/Note.dart';

import 'Folder.dart';
import 'constants.dart';

class SingleNotesState extends State<SingleNotes>{

  List<Note> noteList;
  List<Folder> folderList;
  DBHandler dbHandler = DBHandler();
  TextEditingController folderTitleController = TextEditingController();

  SingleNotesState(List<Note> listNotes, List<Folder> listFolders){this.noteList = listNotes; this.folderList = listFolders;}


  void createPlaceholderNotes(){
    noteList = new List<Note>();

    noteList.add(new Note(noteId: 1, noteTitle: "title1", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 2, noteTitle: "title2", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 3, noteTitle: "title3", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
  }


  //TODO: Handle 'add note to a folder'
  void popupMenuController(var value, BuildContext context){
    if (value is Note){
      //Delete note
      dbHandler.removeNote(value);

      setState(() {
        noteList.remove(value);
      });

      Fluttertoast.showToast(msg: "Deleted note", toastLength: Toast.LENGTH_LONG);
    }

    else{
      //Add note to a folder
      showDialog(
        context: context,
        builder: (context){
          return buildAlertDialog();
        }
      );
    }
  }


  @override
  void initState() {
    dbHandler.init();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return buildList();
  }




  Widget buildList(){

    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, i){
        return buildItem(noteList[i]);
      },
    );
  }




  Widget buildItem(Note note){

    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.insert_drive_file),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${note.noteTitle}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${note.noteContent.substring(0, note.noteContent.length>20 ? 20 : note.noteContent.length)}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${note.dateCreated.toIso8601String()}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 9
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: note,
                    child: Text("Delete note"),
                  ),

                  PopupMenuItem(
                    value: 2,
                    child: Text("Add note to a folder"),
                  )
                ],

                onSelected: (value){
                  popupMenuController(value, context);
                },
              )
          )
        ],
      ),
    );
  }


  /*Widgets for the list of folders when clicking on 'add a note to a folder' on each popup menu*/
  Widget buildAlertDialog(){
    return AlertDialog(
      title: Text("Choose folder"),
      content: buildAddToFolderDialogList(),

    );
  }

  Widget buildAddToFolderDialogList(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                  controller: folderTitleController,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New folder title',
                  )
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async{
                  //Create a new folder and add the note to the folder, only if there is a valid title written on the text field
                  if (folderTitleController.text == "") Fluttertoast.showToast(msg: "Please name the folder before creating it");
                  else{
                    await dbHandler.checkCurrentId(isFolder);
                    int id = dbHandler.currentFolderId;
                    Folder folder = Folder(folderId: id, folderTitle: folderTitleController.text, folderDescription: "");

                    await dbHandler.addFolder(folder);

                    setState(() {
                      folderList.add(folder);
                    });

                    //TODO: Also add the note to the folder
                    Fluttertoast.showToast(msg: "Added note to new folder", toastLength: Toast.LENGTH_LONG);

                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 3.0, right: 3.0, bottom: 3.0),
          child:
            folderList.length > 0 ?
              ListView.builder(
                shrinkWrap: true,
                itemCount: folderList.length,
                itemBuilder: (context, i){
                  return buildAddToFolderDialogItem(folderList[i]);
                },
              )
            :
              Text("No folders here")
        )
      ],
    );
  }

  //TODO: Improve the layout of the folder list in the alert dialog
  Widget buildAddToFolderDialogItem(Folder folder){
    return ListTile(
      title: Text("${folder.folderTitle}"),
      subtitle: Text("${folder.folderDescription}"),
    );
  }
}


class SingleNotes extends StatefulWidget{

  List<Note> noteList;
  List<Folder> folderList;

  SingleNotes(List<Note> listNotes, List<Folder> listFolders){this.noteList = listNotes; this.folderList = listFolders;}

  SingleNotesState createState(){
    SingleNotesState singleNotesState = SingleNotesState(noteList, folderList);
    /*Do something*/
    //singleNotesState.createPlaceholderNotes();
    return singleNotesState;
  }
}