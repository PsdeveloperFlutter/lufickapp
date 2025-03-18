// To parse this JSON data, do
//
//     final menwear = menwearFromJson(jsonString);

import 'package:flutter/widgets.dart' as widgets;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Menwear menwearFromJson(String str) => Menwear.fromJson(json.decode(str));

String menwearToJson(Menwear data) => json.encode(data.toJson());

class Menwear {
  DateTime requestDateTime;
  String responseSource;
  Pagination pagination;
  PlpList plpList;

  Menwear({
    required this.requestDateTime,
    required this.responseSource,
    required this.pagination,
    required this.plpList,
  });

  factory Menwear.fromJson(Map<String, dynamic> json) => Menwear(
    requestDateTime: json["requestDateTime"] != null ? DateTime.parse(json["requestDateTime"]) : DateTime.now(),
    responseSource: json["responseSource"],
    pagination: Pagination.fromJson(json["pagination"]),
    plpList: PlpList.fromJson(json["plpList"]),
  );

  Map<String, dynamic> toJson() => {
    "requestDateTime": requestDateTime.toIso8601String(),
    "responseSource": responseSource,
    "pagination": pagination.toJson(),
    "plpList": plpList.toJson(),
  };
}

class Pagination {
  double ? prevPageNum;
  double ?currentPage;
  double ?nextPageNum;
  double ?totalPages;

  Pagination({
    required this.prevPageNum,
    required this.currentPage,
    required this.nextPageNum,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    prevPageNum: (json["prevPageNum"] as num?)?.toDouble(),
    currentPage: (json["currentPage"] as num?)?.toDouble(),
    nextPageNum: (json["nextPageNum"] as num?)?.toDouble(),
    totalPages: (json["totalPages"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "prevPageNum": prevPageNum,
    "currentPage": currentPage,
    "nextPageNum": nextPageNum,
    "totalPages": totalPages,
  };
}

class PlpList {
  List<ProductList> productList;
  SortOptions sortOptions;
  double ? numberOfHits;
  List<dynamic> sliceRanges;
  List<Facet> facets;

  PlpList({
    required this.productList,
    required this.sortOptions,
    required this.numberOfHits,
    required this.sliceRanges,
    required this.facets,
  });

  factory PlpList.fromJson(Map<String, dynamic> json) => PlpList(
    productList: json["productList"] != null
        ? List<ProductList>.from(json["productList"].map((x) => ProductList.fromJson(x)))
        : [],
    sortOptions: SortOptions.fromJson(json["sortOptions"]),
    numberOfHits: (json["numberOfHits"]as num ?)?.toDouble(),
    sliceRanges: List<dynamic>.from(json["sliceRanges"].map((x) => x)),
    facets: List<Facet>.from(json["facets"].map((x) => Facet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
    "sortOptions": sortOptions.toJson(),
    "numberOfHits": numberOfHits,
    "sliceRanges": List<dynamic>.from(sliceRanges.map((x) => x)),
    "facets": List<dynamic>.from(facets.map((x) => x.toJson())),
  };
}

class Facet {
  String name;
  String id;
  double? selectedCount;
  Type type;
  double? min;
  double? max;
  List<Value>? filterValues;
  List<Group>? groups;

  Facet({
    required this.name,
    required this.id,
    required this.selectedCount,
    required this.type,
    this.min,
    this.max,
    this.filterValues,
    this.groups,
  });

  factory Facet.fromJson(Map<String, dynamic> json) => Facet(
    name: json["name"],
    id: json["id"],
    selectedCount: (json["selectedCount"] as num?)?.toDouble(),
    type: typeValues.map[json["type"]]!,
    min: (json["min"] as num?)?.toDouble(),
    max: (json["max"] as num?)?.toDouble(),
    filterValues: json["filterValues"] == null ? [] : List<Value>.from(json["filterValues"]!.map((x) => Value.fromJson(x))),
    groups: json["groups"] == null ? [] : List<Group>.from(json["groups"]!.map((x) => Group.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "selectedCount": selectedCount,
    "type": typeValues.reverse[type],
    "min": min,
    "max": max,
    "filterValues": filterValues == null ? [] : List<dynamic>.from(filterValues!.map((x) => x.toJson())),
    "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x.toJson())),
  };
}

class Value {
  String id;
  String name;
  double ? count;
  bool selected;

  Value({
    required this.id,
    required this.name,
    required this.count,
    required this.selected,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    id: json["id"],
    name: json["name"],
    count: (json["count"] as num?)?.toDouble(),
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "count": count,
    "selected": selected,
  };
}

class Group {
  String name;
  List<Value> facetValues;

  Group({
    required this.name,
    required this.facetValues,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    name: json["name"],
    facetValues: List<Value>.from(json["facetValues"].map((x) => Value.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "facetValues": List<dynamic>.from(facetValues.map((x) => x.toJson())),
  };
}

enum Type {
  RANGE,
  SIZE,
  TEXT
}

final typeValues = EnumValues({
  "RANGE": Type.RANGE,
  "SIZE": Type.SIZE,
  "TEXT": Type.TEXT
});

class ProductList {
  String id;
  String trackingId;
  String productName;
  bool productListExternal;
  BrandName brandName;
  String url;
  bool showPriceMarker;
  List<Price> prices;
  Availability availability;
  List<Swatch> swatches;
  List<dynamic> productMarkers;
  List<Image> images;
  bool hasVideo;
  String colorName;
  bool isPreShopping;
  bool isOnline;
  String modelImage;
  String colors;
  String productImage;
  bool newArrival;
  bool isLiquidPixelUrl;
  String colorWithNames;
  String mainCatCode;
  String? colourShades;
  SellingAttribute? sellingAttribute;
  String? quantity;
  bool? isMultipack;
  String? comparativeFormattedPrice;
  String? flexiLayoutType;

  ProductList({
    required this.id,
    required this.trackingId,
    required this.productName,
    required this.productListExternal,
    required this.brandName,
    required this.url,
    required this.showPriceMarker,
    required this.prices,
    required this.availability,
    required this.swatches,
    required this.productMarkers,
    required this.images,
    required this.hasVideo,
    required this.colorName,
    required this.isPreShopping,
    required this.isOnline,
    required this.modelImage,
    required this.colors,
    required this.productImage,
    required this.newArrival,
    required this.isLiquidPixelUrl,
    required this.colorWithNames,
    required this.mainCatCode,
    this.colourShades,
    this.sellingAttribute,
    this.quantity,
    this.isMultipack,
    this.comparativeFormattedPrice,
    this.flexiLayoutType,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    id: json["id"],
    trackingId: json["trackingId"],
    productName: json["productName"],
    productListExternal: json["external"],
    brandName: brandNameValues.map[json["brandName"]] ?? BrandName.H_M,
    url: json["url"],
    showPriceMarker: json["showPriceMarker"],
    prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
    availability: Availability.fromJson(json["availability"]),
    swatches: List<Swatch>.from(json["swatches"].map((x) => Swatch.fromJson(x))),
    productMarkers: List<dynamic>.from(json["productMarkers"].map((x) => x)),
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    hasVideo: json["hasVideo"],
    colorName: json["colorName"],
    isPreShopping: json["isPreShopping"],
    isOnline: json["isOnline"],
    modelImage: json["modelImage"],
    colors: json["colors"],
    productImage: json["productImage"],
    newArrival: json["newArrival"],
    isLiquidPixelUrl: json["isLiquidPixelUrl"],
    colorWithNames: json["colorWithNames"],
    mainCatCode: json["mainCatCode"],
    colourShades: json["colourShades"],
    sellingAttribute: sellingAttributeValues.map[json["sellingAttribute"]] ?? SellingAttribute.defaultValue,
    quantity: json["quantity"],
    isMultipack: json["isMultipack"],
    comparativeFormattedPrice: json["comparativeFormattedPrice"],
    flexiLayoutType: json["flexiLayoutType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trackingId": trackingId,
    "productName": productName,
    "external": productListExternal,
    "brandName": brandNameValues.reverse[brandName],
    "url": url,
    "showPriceMarker": showPriceMarker,
    "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
    "availability": availability.toJson(),
    "swatches": List<dynamic>.from(swatches.map((x) => x.toJson())),
    "productMarkers": List<dynamic>.from(productMarkers.map((x) => x)),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "hasVideo": hasVideo,
    "colorName": colorName,
    "isPreShopping": isPreShopping,
    "isOnline": isOnline,
    "modelImage": modelImage,
    "colors": colors,
    "productImage": productImage,
    "newArrival": newArrival,
    "isLiquidPixelUrl": isLiquidPixelUrl,
    "colorWithNames": colorWithNames,
    "mainCatCode": mainCatCode,
    "colourShades": colourShades,
    "sellingAttribute": sellingAttributeValues.reverse[sellingAttribute],
    "quantity": quantity,
    "isMultipack": isMultipack,
    "comparativeFormattedPrice": comparativeFormattedPrice,
    "flexiLayoutType": flexiLayoutType,
  };
}

class Availability {
  StockState stockState;
  bool comingSoon;

  Availability({
    required this.stockState,
    required this.comingSoon,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    stockState: stockStateValues.map[json["stockState"]]!,
    comingSoon: json["comingSoon"],
  );

  Map<String, dynamic> toJson() => {
    "stockState": stockStateValues.reverse[stockState],
    "comingSoon": comingSoon,
  };
}

enum StockState {
  AVAILABLE
}

final stockStateValues = EnumValues({
  "Available": StockState.AVAILABLE
});

enum BrandName {
  H_M
}

final brandNameValues = EnumValues({
  "H&M": BrandName.H_M
});

class Image {
  String url;

  Image({
    required this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}

class Price {
  PriceType priceType;
  double? price;
  double? minPrice;
  double ?maxPrice;
  String formattedPrice;

  Price({
    required this.priceType,
    required this.price,
    required this.minPrice,
    required this.maxPrice,
    required this.formattedPrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    priceType: priceTypeValues.map[json["priceType"]]!,
    price: (json["price"] as num?)?.toDouble() ,
    minPrice: (json["minPrice"] as num?)?.toDouble() ,
    maxPrice: (json["maxPrice"] as num?)?.toDouble() ,
    formattedPrice: json["formattedPrice"],
  );

  Map<String, dynamic> toJson() => {
    "priceType": priceTypeValues.reverse[priceType],
    "price": price,
    "minPrice": minPrice,
    "maxPrice": maxPrice,
    "formattedPrice": formattedPrice,
  };
}

enum PriceType {
  WHITE_PRICE
}

final priceTypeValues = EnumValues({
  "whitePrice": PriceType.WHITE_PRICE
});

enum SellingAttribute {
  NEW_ARRIVAL, defaultValue
}

final sellingAttributeValues = EnumValues({
  "New Arrival": SellingAttribute.NEW_ARRIVAL
});

class Swatch {
  String articleId;
  String url;
  String colorName;
  String colorCode;
  String trackingId;
  String productImage;

  Swatch({
    required this.articleId,
    required this.url,
    required this.colorName,
    required this.colorCode,
    required this.trackingId,
    required this.productImage,
  });

  factory Swatch.fromJson(Map<String, dynamic> json) => Swatch(
    articleId: json["articleId"],
    url: json["url"],
    colorName: json["colorName"],
    colorCode: json["colorCode"],
    trackingId: json["trackingId"],
    productImage: json["productImage"],
  );

  Map<String, dynamic> toJson() => {
    "articleId": articleId,
    "url": url,
    "colorName": colorName,
    "colorCode": colorCode,
    "trackingId": trackingId,
    "productImage": productImage,
  };
}

class SortOptions {
  String selected;
  List<Option> options;

  SortOptions({
    required this.selected,
    required this.options,
  });

  factory SortOptions.fromJson(Map<String, dynamic> json) => SortOptions(
    selected: json["selected"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "selected": selected,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  String id;
  String label;

  Option({
    required this.id,
    required this.label,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}




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
                children: [
               
                  widgets.Image.network(product.swatches[0].productImage),
                  widgets.Image.network(product.images[0].url),
              ListTile(
              title: Text(product.productName),
              subtitle: Text(product.brandName.toString()),
              ),
]
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