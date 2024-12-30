import 'package:flutter/material.dart';
import 'package:lufickapp/Weather_APP/Search_api_Weather.dart';

class searchScreen extends StatefulWidget {


  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){},child: IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.white,)),),
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: FutureBuilder(future:searchapiweather() , builder: (context,snapshot){
        if(snapshot.hasError){
          print("Error ${snapshot.error}");
          return Center(child: Text("Error ${snapshot.error}"),);
        }
        else if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.forecast.forecastday.length,
                itemBuilder: (context,index) {


              return Column(

                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 10,
                          ),
                          hintText: 'Search',
                          suffixIcon: Icon(Icons.search),
                          fillColor: Colors.black,
                      ),
                    ),
                  )
                  ,
                 Container(
                   height: 400,
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                   margin: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                   decoration: BoxDecoration(
                     color: Colors.cyan.shade50,
                     borderRadius: BorderRadius.circular(30),
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Name :- ${snapshot.data!.location.name.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text("Region :- ${snapshot.data!.location.region.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text("Country :- ${snapshot.data!.location.country.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text("Localtime :- ${snapshot.data!.location.localtime.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text(" Timezone :- ${snapshot.data!.location.tzId.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text("Lat :- ${snapshot.data!.location.lat.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text("Lon :- ${snapshot.data!.location.lon.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                       Text(" Time :- ${snapshot.data!.location.localtimeEpoch.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                     ],
                   ),
                 )
                ],
              );

            });
        }
        else if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(
            color: Colors.blue.shade700,
          ),);
        }
        else {
          return Center(child: Text("No Data"),);
        }

      }),
    );
  }
}
