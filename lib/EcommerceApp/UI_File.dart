
import 'package:flutter/material.dart' as flutter;

// ...


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Json_data.dart';

class FetchProductList extends StatefulWidget {
  const FetchProductList({Key? key}) : super(key: key);

  @override
  _FetchProductListState createState() => _FetchProductListState();
}

class _FetchProductListState extends State<FetchProductList> {
  late Future<Menwear?> menwearData;


  Future<Menwear?> fetchMenWearData() async {
    try {
      final response = await http.get(Uri.parse("https://api.hm.com/search-services/v1/en_in/listing/resultpage?pageSource=PLP&page=2&sort=RELEVANCE&pageId=/men/shop-by-product/t-shirts-and-tanks&page-size=36&categoryId=men_tshirtstanks&filters=sale:false||oldSale:false&touchPoint=DESKTOP&skipStockCheck=false"));

      if (response.statusCode == 200) {
        return menwearFromJson(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
  @override
  void initState() {
    super.initState();
    menwearData = fetchMenWearData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Men's Wear")),
      body: FutureBuilder<Menwear?>(
        future: menwearData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data available"));
          }

          final menwear = snapshot.data!;
          return ListView.builder(
            itemCount: menwear.plpList.productList.length,
            itemBuilder: (context, index) {
              final product = menwear.plpList.productList[index];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                    flutter.Image.network(product.productImage,height: 200,width: 200,)

                  ,
                   // Empty placeholder if no swatches available
                  Text("${product.productName.toString().split('.').last}"),
                  Text("${product.brandName.toString().split('.').last}"), // Removes 'BrandName.' prefix

                ],
              );
            },
          );

        },
      ),
    );
  }
}

void main(){
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FetchProductList()));
}