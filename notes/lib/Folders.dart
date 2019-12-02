

import 'package:flutter/material.dart';
import 'Folder.dart';
import 'Note.dart';

class FoldersState extends State<Folders>{

  List<Note> noteList;
  List<Folder> folderList;


  FoldersState(List<Folder> list){this.folderList = List<Folder>(); folderList.addAll(list);}


  void addPlaceholderFolders(){
    folderList = List<Folder>();
    folderList.add(new Folder(folderId: 1, folderTitle: "title1", folderDescription: "testtest"));
    folderList.add(new Folder(folderId: 2, folderTitle: "title2", folderDescription: "testtest"));
    folderList.add(new Folder(folderId: 3, folderTitle: "title3", folderDescription: "testtest"));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: <Widget>[
        buildList()
      ],
    );

  }


  Widget buildList(){
    return ExpansionPanelList(

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
    );
  }


  Widget buildHeader(Folder folder){
    return ListTile(
      title: Text("${folder.folderTitle}"),
      subtitle: Text("${folder.folderDescription}"),
    );
  }


  Widget buildBody(Folder folder){
    return Center(
      child: Text("Expanded"),
    );
  }
}



class Folders extends StatefulWidget{

  List<Folder> folderList;

  Folders(List<Folder> list){this.folderList = list;}

  FoldersState createState(){
    FoldersState foldersState = FoldersState(folderList);
    foldersState.addPlaceholderFolders();
    return foldersState;
  }
}