import 'package:coinmarket_api_app/CCData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CClist extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return CClistState();
  }
}


class CClistState extends State<CClist>{
  
  List<CCData> data = [];
  int limit = 10;
  bool loadState = true;


  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('CC tracker'),
    //   ),
    //   body: Container(
    //     child: ListView(
    //       children: _buildList(),
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.add),
    //     onPressed: () => _refresh_on_pressed(),
    //   ),
    // );
    // var container = AppStateContainer.of(context);
     Widget body = _pageToDisplay;
        return new Scaffold(
          appBar: AppBar(
          title: Text('CC tracker'),
            ),
          body: body,
          floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
         onPressed: () => _refresh_on_pressed(),
            ),
           );
  }

    Widget get _pageToDisplay {
    if (loadState) {
      return _loadingView;
    } else {
      return _homeView;
    }
  }

   Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

   Widget get _homeView {
    return Scaffold(

      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),

    );
  }

   _refresh_on_pressed() async {

     if(!loadState){
        setState(() {
          loadState = true;
      });
     }

    var url = "https://api.coinmarketcap.com/v2/ticker/?limit=${limit}";
    final response = await http.get(url); 

    if(response.statusCode == 200){
      var allData = (json.decode(response.body) as Map)["data"] as Map<String, dynamic>;

      var ccDataList = List<CCData>();
      allData.forEach((String key, dynamic val){
      var record = CCData(name: val["name"],symbol:val["symbol"], rank:val["rank"], price:val["quotes"]["USD"]["price"]);

      ccDataList.add(record);
      });
      
      setState(() {
        data = ccDataList;
        limit = limit + 10;
        loadState = false;
      });
    }
    print("refresh on pressed ${response.statusCode}");
    print("https://api.coinmarketcap.com/v2/ticker/?limit=${limit}");

  } 

  List<Widget> _buildList(){
    return data.map((CCData f) => ListTile(
      title: Text(f.symbol),
      subtitle: Text(f.name),
      leading: CircleAvatar( child: Text(f.rank.toString())),
      trailing: Text('\$ ${f.price.toStringAsFixed(2)}'),
    )).toList();
  }

  @override
    void initState() { 
      super.initState();
      _refresh_on_pressed();
    }

}