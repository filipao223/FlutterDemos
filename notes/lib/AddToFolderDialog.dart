


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/DBHandler.dart';

import 'Folder.dart';
import 'Note.dart';
import 'constants.dart';

class AddToFolderDialogState extends State<AddToFolderDialog>{

  DBHandler dbHandler = DBHandler();
  TextEditingController folderTitleController = TextEditingController();
  List<Folder> folderList;
  Note note;


  AddToFolderDialogState(List<Folder> listFolder, Note note){this.folderList = listFolder; this.note = note;}


  @override
  void initState(){
    dbHandler.init();
    super.initState();
  }


  /*Widgets for the list of folders when clicking on 'add a note to a folder' on each popup menu*/
  Widget build(BuildContext context){
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
                    await dbHandler.addNoteToFolder(folder, note);

                    setState(() {
                      folder.noteList.insert(0, note);
                      folderList.insert(0, folder);
                    });

                    Fluttertoast.showToast(msg: "Added note to new folder", toastLength: Toast.LENGTH_LONG);

                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),

        Flexible(
          child: Padding(
              padding: EdgeInsets.only(top: 8.0, left: 3.0, right: 3.0, bottom: 3.0),
              child:
              folderList.length > 0 ?
              ListView.builder(
                shrinkWrap: true,
                itemCount: folderList.length,
                itemBuilder: (context, i){
                  return buildAddToFolderDialogItem(folderList[i], note);
                },
              )
                  :
              Text("No folders here")
          ),
        )
      ],
    );
  }

  //TODO: Improve the layout of the folder list in the alert dialog
  Widget buildAddToFolderDialogItem(Folder folder, Note note){
    return ListTile(
      title: Text("${folder.folderTitle}"),
      subtitle: Text("${folder.folderDescription}"),
      onTap: () async{
        //TODO: Handle errors like if note is already in a folder
        await dbHandler.addNoteToFolder(folder, note);

        setState(() {
          folder.noteList.insert(0, note);
        });

        Fluttertoast.showToast(msg: "Added note to folder", toastLength: Toast.LENGTH_LONG);

        Navigator.pop(context);
      },
    );
  }
}


class AddToFolderDialog extends StatefulWidget{

  List<Folder> folderList;
  Note note;

  AddToFolderDialog(List<Folder> listFolder, Note note){this.folderList = listFolder; this.note = note;}

  AddToFolderDialogState createState(){
    AddToFolderDialogState addToFolderDialogState = AddToFolderDialogState(folderList, note);
    return addToFolderDialogState;
  }
}