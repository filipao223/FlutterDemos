

import 'package:flutter/material.dart';
import '../models/Folder.dart';
import '../models/Note.dart';

class FoldersState extends State<Folders>{

  List<Note> noteList;
  List<Folder> folderList;


  FoldersState(List<Folder> list){this.folderList = list;}


  void addPlaceholderFolders(){
    folderList = List<Folder>();
    folderList.add(new Folder(folderId: 1, folderTitle: "title1", folderDescription: "testtest"));
    folderList.add(new Folder(folderId: 2, folderTitle: "title2", folderDescription: "testtest"));
    folderList.add(new Folder(folderId: 3, folderTitle: "title3", folderDescription: "testtest"));
  }


  @override
  Widget build(BuildContext context) {
    if (folderList.isEmpty){
      return Center(
        child: Text(
          "No folders here",
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic
          ),
        ),
      );
    }

    else{
      return ListView(
        children: <Widget>[
          buildList()
        ],
      );
    }

  }

  //TODO: Folder list looks different than note list (and eventually saved list), maybe try using expansion tile and list view
  Widget buildList(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ExpansionPanelList(

        expansionCallback: (index, isExpanded){
          setState(() {
            folderList[index].isExpanded = !isExpanded;
          });
        },

        children: folderList.map<ExpansionPanel>( (Folder folder){
          return ExpansionPanel(
              headerBuilder: (context, isExpanded){
                return buildHeader(folder);
              },

              body: buildBody(folder),

              isExpanded: folder.isExpanded
          );
        }).toList(),
      ),
    );
  }


  Widget buildHeader(Folder folder){
    return ListTile(
      title: Text("${folder.folderTitle}", style: TextStyle(fontFamily: "Roboto")),
      subtitle: Text("${folder.folderDescription}", style: TextStyle(fontFamily: "Roboto")),
    );
  }

  //TODO: Add a 'view more' at the end of the panel if more than 3 notes exists, opens a new scaffold with the full list
  Widget buildBody(Folder folder){
    if (folder.noteList.length > 0){
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: folder.noteList.length,
        itemBuilder: (context, i){
          return buildItem(folder.noteList[i]);
        },
      );
    }

    else return Text("");
  }

  Widget buildItem(Note note){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: ListTile(
          title: Text(
            "${note.noteTitle}",
            style: TextStyle(fontSize: 13, fontFamily: "Roboto"),
          ),

          subtitle: Text(
            "${note.noteDescription}",
            style: TextStyle(fontSize: 11, fontFamily: "Roboto"),
          ),
        ),
      ),
    );
  }
}



class Folders extends StatefulWidget{

  List<Folder> folderList;

  Folders(List<Folder> list){this.folderList = list;}

  FoldersState createState(){
    FoldersState foldersState = FoldersState(folderList);
    /*Run these two at same time*/
    //foldersState.addPlaceholderFolders();
    //foldersState.folderList[0].createPlaceholderNotes();
    /***********^^**************/
    return foldersState;
  }
}