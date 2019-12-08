


import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/constants.dart';
import 'package:notes/screens/AddNote.dart';
import 'package:notes/screens/MainScreen.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main(){

  AddNote addNote = AddNote();
  AddNoteState addNoteState = addNote.createState();
  
  group('Initial variables value test', () {

    test('Form build key should not be null', (){
      expect(addNoteState.formBuildKey, isNot(null));
    });

    test('DBHandler should not be null', (){
      expect(addNoteState.dbHandler, isNot(null));
    });
  });


  testWidgets('Test navigating to AddNote', (WidgetTester tester) async{

    NavigatorObserver mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        initialRoute: homeRoute,
        routes: {
          homeRoute : (context) => MainScreen(),
          addNoteRoute : (context) => AddNote(),
        }
      ),
    );


    await tester.tap(find.byKey(MainScreen.addNoteFabKey));
    await tester.pump();

    verify(mockObserver.didPush(any, any));
  });



  testWidgets("Test form widgets", (WidgetTester tester) async{
    List<String> testList = ["test1", "test2", "test3"];

    Column columnWidgets = Column();
    FormBuilderTextField textFieldWidgets = FormBuilderTextField();
    //FormBuilderTypeAhead typeAheadWidget = FormBuilderTypeAhead(itemBuilder: (context, i)=>Text("${testList[i]}"), suggestionsCallback: (s)=>s.split(""),);

    await tester.pumpWidget(
      MaterialApp(
        home: AddNote(),
        //navigatorObservers: [mockObserver],
      ),
    );

    /*There should be 3 FormBuilderTextFields and 1 FormBuilderTypeAhead*/
    expect(find.widgetWithText(FormBuilderTextField, "Title"), findsOneWidget);
    expect(find.widgetWithText(FormBuilderTextField, "Description"), findsOneWidget);
    expect(find.widgetWithText(FormBuilderTextField, "Content"), findsOneWidget);
    /*Not currently working*/
    //expect(find.widgetWithText(FormBuilderTypeAhead, "Language"), findsOneWidget);

    //TODO: Test the callback when clicking on 'add' button
    /*Test clicking on add note*/
    /*await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pump();

    verify(mockObserver.didPop(any, any));*/
  });
}