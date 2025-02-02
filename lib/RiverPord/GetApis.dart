import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model class for JSON Data
class Jsondata {
  final int userId;
  final int id;
  final String title;
  final String body;

  Jsondata({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Jsondata.fromJson(Map<String, dynamic> json) => Jsondata(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );
}



final apidata=FutureProvider<List<Jsondata>>((ref)async{
  final respone =await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  if(respone.statusCode==200){
    List<dynamic>data=json.decode(respone.body);
    return data.map((json){
      return
      Jsondata.fromJson(json);
    }).toList();
  }
  else {
    throw Exception("Failed to Load Data");
  }
});

class  MyAppss extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
       floatingActionButton: Consumer(builder: (context,ref,child){
         return
          FloatingActionButton(onPressed: (){
            ref.invalidate(apidata);
         });
       }),
       body: Consumer(builder: (context ,ref, child){
         final asyncdata=ref.watch(apidata);
         return
          asyncdata.when(data:
          (data)=>ListView.builder(

            itemBuilder: (context,index){
              final item = data[index];
              return ListTile(
                title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.body),
              );
            },
          )
            , error: (error,stack)=>Center(child: Text("Error Occur")), loading: ()=>Center(
            child: CircularProgressIndicator(),
          ) ,  );
       }),
      ),
    );
  }
}