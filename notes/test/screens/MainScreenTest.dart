


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/constants.dart';
import 'package:notes/screens/AddNote.dart';
import 'package:notes/screens/MainScreen.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main(){

  MainScreen mainScreen = MainScreen();
  MainScreenState mainScreenState = mainScreen.createState();

  group("Test initial values", (){

    test("DBHandler should not be null", (){
      expect(mainScreenState.dbHandler, isNot(null));
    });

    test("controllers should not be null", (){
      expect(mainScreenState.controllers, isNot(null));
    });

    test("checkedDatabase should be false", (){
      expect(mainScreenState.checkedDatabase, false);
    });

    test("pageController should not be null", (){
      expect(mainScreenState.pageController, isNot(null));
    });

    test("selectedBottomNavItem should be 0", (){
      expect(mainScreenState.selectedBottomNavItem, 0);
    });
  });


  testWidgets("Test initial build", (WidgetTester tester) async{

    NavigatorObserver mockObserver = MockNavigatorObserver();
    
    MainScreen mainScreen = MainScreen();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        initialRoute: homeRoute,
        routes: {
          homeRoute : (context) => mainScreen,
          addNoteRoute : (context) => AddNote(),
        }
      ),
    );

    //await tester.drag(find.byType(PageView), Offset(500.0, 0.0));


  });

}