import 'package:multiapp/features/shop/models/product_packing_price.dart';
import 'package:multiapp/features/shop/models/product_unit_converter.dart';


class ProductModels {
  final String? id;
  final String itmCode;
  final String? locationID;
  final String? godownName;
  final String longName;
  final String? unit;
  final String? fixUnitOfSell;
  final int currBalance; //new
  final String? catCode;
  final String? catName;
  final String? taxCode;
  final String? isFavourite;
  final int taxRate;
  final double  rspIncVat;
  final double  wspIncVat; //new
  final List<ProductPackingPrice>? quantityPrice;
  // final List<ProductUnitConverter>? packagingDetail;
  
  ProductModels( {this.fixUnitOfSell,this.isFavourite,this.id,this.catName,this.godownName,required this.currBalance,this.quantityPrice,required this.itmCode, this.locationID, 
  required this.longName, this.unit, this.catCode, this.taxCode,required this.taxRate, required this.rspIncVat,required this.wspIncVat});

  //Create Empty function for clean code
  static ProductModels empty() => ProductModels(id: '',itmCode: '', longName: '',taxRate: 0, currBalance:0, rspIncVat: 0, wspIncVat: 0);
  
  // toJson() function
  Map<String, dynamic> toJson() {
    return {
      'itmCode': itmCode,
      'locationId': locationID,
      'longName': longName,
      'godownName': godownName,
      'unit': unit,
      'fixUnitOfSell': fixUnitOfSell,
      'currBalance': currBalance,
      'catCode': catCode,
      'catName': catName,
      'taxCode': taxCode,
      'taxRate': taxRate,
      'RspAmount': rspIncVat,
      'wspIncVat': wspIncVat,
      'isFavourite': isFavourite,
      // 'quantityPrice': quantityPrice?.map((item) => item.toJson()).toList(),
      // 'packagingDetail': packagingDetail?.map((item) => item.toJson()).toList(),
    };
  }

factory ProductModels.fromMap(Map<String, dynamic> data) {
    // print("PM data ${data['ProductPackingPrice']}");
    // print("PC data ${data['ProductUnitConverter']}");
  return ProductModels(
    id: data['itmCode']?.toString() ?? '', // Mapping itmCode as id
    itmCode: data['itmCode']?.toString() ?? '', // itmCode should be mapped properly
    locationID: data['locationId']?.toString(),
    godownName: data['godownName']?.toString(),
    longName: data['longName'] ?? '',
    unit: data['unit']?.toString(),
    fixUnitOfSell: data['fixUnitOfSell']?.toString(),
    currBalance: data['currBalance'] ?? 0,
    catCode: data['catCode']?.toString(),
    catName: data['catName']?.toString(),
    taxCode: data['taxCode']?.toString(),
    taxRate: data['taxRate'],
    isFavourite: data['isFavourite']?.toString(),
    rspIncVat: data['RspAmount'] ?? 0, 
    wspIncVat: data['wspIncVat'] ?? 0, 
    // Map ProductPackingPrice
    quantityPrice: data['ProductPackingPrice'] != null
          ? (data['ProductPackingPrice'] as List<dynamic>)
              .map((item) => ProductPackingPrice.fromMap(item))
              .toList()
          :  null,
    // packagingDetail: data['ProductUnitConverter'] != null
    //     ? (data['ProductUnitConverter'] as List<dynamic>)
    //         .map((item) => ProductUnitConverter.fromMap(item))
    //         .toList()
    //     :  null,
  );
}
// From JSON function
  factory ProductModels.fromJson(Map<String, dynamic> json) {
    return ProductModels(
      // id: json['id'] as String,
      itmCode: json['ItmCode'] as String,
      locationID: json['LocationID'] as String?,
      godownName: json['GodownName'] as String?,
      longName: json['LongName'] as String,
      unit: json['Unit'] as String?,
      fixUnitOfSell: json['fixUnitOfSell'] as String?,
      currBalance:  json['CurrBalance'],
      catCode: json['CatCode'] as String?,
      catName: json['CatName']  as String?,
      taxCode: json['TaxCode'] as String?,
      taxRate: json['TaxRate'],
      isFavourite:"0",
      rspIncVat: (json['RspIncVat'] as num).toDouble(),
      wspIncVat: (json['WspIncVat'] as num).toDouble(),
      // quantityPrice: (json['quantityPrice'] as List<dynamic>?)
      //     ?.map((item) => ProductPackingPrice.fromJson(item))
      //     .toList(),
      // packagingDetail: (json['packagingDetail'] as List<dynamic>?)
      //     ?.map((item) => ProductUnitConverter.fromJson(item))
      //     .toList(),
    );
  }
}
  