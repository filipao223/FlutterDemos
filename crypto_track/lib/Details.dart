


import 'dart:convert';

import 'package:crypto_track/DBHandler.dart';
import 'package:crypto_track/constants.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/CryptoList.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';

class DetailsState extends State<Details>{
  Coin _coin;
  DBHandler dbHandler;
  String _apiKey;
  ChartData chartData = new ChartData();
  bool haveChartData = false;
  bool checkingApi = true;


  void initDBHandler() {
    dbHandler = new DBHandler();
    dbHandler.init();

    queryPriceHistory();
  }

  void debugPrintCustom(List<dynamic> items){
    if (items != null) items.forEach((item) => print(item));
    else print("Null object");
  }


  void queryPriceHistory() async{
    /*Get the api key from the file*/
    await GlobalConfiguration().loadFromPath("assets/config.json");
    _apiKey = GlobalConfiguration().get("chart_api_key");

    /*Make the API request*/
    String url = 'https://min-api.cryptocompare.com/data/v2/histoday?fsym=${_coin.id}&tsym=USD&limit=60&api_key=$_apiKey';
    Response response = await get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;

    var dataMap = jsonDecode(json);
    var historyArray = dataMap['Data']['Data'];

    debugPrintCustom(historyArray);

    var result = chartData.fillSampleData(historyArray);
    setState(() {
      if (result == OK){
        haveChartData = true;
        checkingApi = false;
      }

      else checkingApi = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    _coin = ModalRoute.of(context).settings.arguments;

    if (_coin == null){
      return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Center(
          child: Text("Error, coin is null"),
        ),
      );
    }
    else{
      if (haveChartData){
        return Scaffold(

          appBar: AppBar(
            title: Text("${_coin.name}"),
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.delete), onPressed: (){
                /*Remove coin from database*/
                dbHandler.removeCoin(_coin);

                /*Pop with deleted coin return value*/
                Navigator.pop(context, DELETED_COIN);

                /*Show a toast when deleting a coin*/
                Fluttertoast.showToast(
                  msg: "Deleted coin",
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIos: 3
                );
              })
            ],
          ),

          body: new Container(
            child:
            new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "${_coin.name}",
                    style: new TextStyle(fontSize:36.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),

                  new Text(
                    "Price: ${_coin.price.toStringAsFixed(2)}",
                    style: new TextStyle(fontSize:12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),

                  new Text(
                    "Price history over 60 days",
                    style: new TextStyle(fontSize:10.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.italic,
                        fontFamily: "Roboto"),
                  ),

                  new Flexible(
                    child: new OHLCVGraph(
                        data: chartData.sampleData,
                        enableGridLines: true,
                        volumeProp: 0.2,
                        gridLineAmount: 5,
                        gridLineColor: Colors.grey[300],
                        gridLineLabelColor: Colors.grey
                    ),
                  )
                ]

            ),

            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
          ),
        );
      }


      else{
        return Scaffold(

          appBar: AppBar(
            title: Text("${_coin.name}"),
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.delete), onPressed: (){
                /*Remove coin from database*/
                dbHandler.removeCoin(_coin);

                /*Pop with deleted coin return value*/
                Navigator.pop(context, DELETED_COIN);

                Fluttertoast.showToast(
                    msg: "Deleted coin",
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIos: 3
                );
              })
            ],
          ),

          body: new Container(
            child:
            new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "${_coin.name}",
                    style: new TextStyle(fontSize:36.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),

                  new Text(
                    "Price: ${_coin.price.toStringAsFixed(2)}",
                    style: new TextStyle(fontSize:12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),

                  new Flexible(
                    child: new Center(
                      child: new Text(
                        checkingApi ? "Checking API for price history" : "No price history data for this coin.",
                        style: new TextStyle(fontSize:12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.italic,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  )
                ]

            ),

            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
          ),
        );
      }
    }
  }
}



class Details extends StatefulWidget{

  DetailsState createState(){
    DetailsState detailsState = new DetailsState();
    detailsState.initDBHandler();
    return detailsState;
  }
}



class ChartData{
  List<Map<String, double>> sampleData;
  
  int fillSampleData(List<dynamic> json){
    if (json == null) return ERROR;

    sampleData = new List<Map<String, double>>();

    json.forEach((object){
      Map<String, double> newMap = {
        "open"     :  object['open'] is int? (object['open'] as int).toDouble() : object['open'],
        "high"     :  object['high'] is int? (object['high'] as int).toDouble() : object['high'],
        "low"      :  object['low'] is int? (object['low'] as int).toDouble() : object['low'],
        "close"    :  object['close'] is int? (object['close'] as int).toDouble() : object['close'],
        "volumeto" :  object['volumeto'] is int? (object['volumeto'] as int).toDouble() : object['volumeto'],};
      sampleData.add(newMap);
    });

    return OK;
  }
}