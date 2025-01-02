import 'package:flutter/material.dart';
import 'package:lufickapp/Weather_APP/Search_api_Weather.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController searchController=TextEditingController();
  late Future<Searchweather?> searchweather;

  void initState() {
    super.initState();
    searchController.text="London";
    searchweather=searchApiWeather("London");
  }


  void _performSearch() {
    // Fetch weather based on user input
    setState(() {
      searchweather = searchApiWeather(searchController.text.trim());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: (){
          _performSearch();
        },child: Icon(Icons.search,color: Colors.white,),),
      appBar: AppBar(
        title: Text('Search Weather'),
        centerTitle: true,
      ),
      body: FutureBuilder(future:searchweather, builder: (context,snapshot){
        if(snapshot.hasError){
          print("Error ${snapshot.error}");
          return Center(child: Text("Error ${snapshot.error}"),);
        }
        else if(snapshot.hasData){
            return ListView.builder(
                itemCount: 1,
              physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context,index) {

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  TextField(
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
                  )
                  ,

                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          height: 160,
                          child:
                          Column(
                            children: [
                              Text("Condition",style: TextStyle(fontSize: 12,decoration: TextDecoration.underline),),
                              Container(child:Image.network('https:${snapshot.data!.current.condition.icon.toString()}',height: 100,),),
                              Text(snapshot.data!.current.condition.text.toString(),style: TextStyle(fontSize: 12),),
                              Text(snapshot.data!.current.condition.code.toString(),style: TextStyle(fontSize: 12),),
                            ],
                          ),
                        ),
                      ),



                      Card(
                        elevation: 5,
                        child: Container(
                          height: 160,
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Forecast",style: TextStyle(fontSize: 12,decoration: TextDecoration.underline),),
                              Text(snapshot.data!.forecast.forecastday[0].date.toString(),style: TextStyle(fontSize: 12),),
                              Text(snapshot.data!.forecast.forecastday[0].dateEpoch.toString(),style: TextStyle(fontSize: 12),),
                              Text("Max Temp :- "+snapshot.data!.forecast.forecastday[0].day.maxtempC.toString(),style: TextStyle(fontSize: 12),),
                              Text("Min Temp :- "+snapshot.data!.forecast.forecastday[0].day.mintempC.toString(),style: TextStyle(fontSize: 12),),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                  SizedBox(height: 20,),
                 Card(
                   elevation: 7,
                   child: Container(
                     height: 400,
                     margin: EdgeInsets.symmetric(horizontal: 20),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(30),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
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
                   ),
                 ),

                  SizedBox(height: 22,),

                  //Current Weather
                  Card(
                    elevation: 5,
                    child: Container(
                      width: 300,
                      height: 400,
                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                    Text("Current Weather",style: TextStyle(fontSize: 15,decoration: TextDecoration.underline),),
                    SizedBox(height: 10,),
                    Text("TempC :- "+snapshot.data!.current.tempC.toString(),style: TextStyle(fontSize: 15),), Text("TempF :- "+snapshot.data!.current.tempF.toString(),style: TextStyle(fontSize: 15),),
                    Text("Feels Like :- "+snapshot.data!.current.feelslikeC.toString(),style: TextStyle(fontSize: 15),),
                    Text("Feels Like :- "+snapshot.data!.current.feelslikeF.toString(),style: TextStyle(fontSize: 15),),
                    Text("Humidity :- "+snapshot.data!.current.humidity.toString(),style: TextStyle(fontSize: 15),),
                    Text("Cloud :- "+snapshot.data!.current.cloud.toString(),style: TextStyle(fontSize: 15),),
                    Text("Wind :- "+snapshot.data!.current.windKph.toString(),style: TextStyle(fontSize: 15),),
                    Text("Wind :- "+snapshot.data!.current.windMph.toString(),style: TextStyle(fontSize: 15),),


                        ],
                      ),
                    ),
                  )
,
                  SizedBox(height: 12,),



                  Card(
                    elevation: 5,
                    child: Container(
                      width: 300,
                      height: 400,
                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                      child: ListView(
                        children: [
                          Center(child: Text("Alerts",style: TextStyle(fontSize: 25,decoration: TextDecoration.underline),)),
                          SizedBox(height: 10,),
                          Text("Headline: " + snapshot.data!.alerts.alert[0].headline.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Message Type: " + snapshot.data!.alerts.alert[0].msgtype.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Severity: " + snapshot.data!.alerts.alert[0].severity.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Urgency: " + snapshot.data!.alerts.alert[0].urgency.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Areas: " + snapshot.data!.alerts.alert[0].areas.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Category: " + snapshot.data!.alerts.alert[0].category.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Certainty: " + snapshot.data!.alerts.alert[0].certainty.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Event: " + snapshot.data!.alerts.alert[0].event.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Note: " + snapshot.data!.alerts.alert[0].note.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Effective: " + snapshot.data!.alerts.alert[0].effective.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Expires: " + snapshot.data!.alerts.alert[0].expires.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Description: " + snapshot.data!.alerts.alert[0].desc.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                          Text("Instruction: " + snapshot.data!.alerts.alert[0].instruction.toString(), style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10,),
                        ],
                      ),
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
