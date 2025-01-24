class ProductPackingPrice {
  final String? itmCode;
  final String? locationID;
  final String? scanCode;
  final num? basePackQty;  // Changed to int
  final num? bulkPackUPrice;  // Changed to int // giving error on type mismatch when converting to double
  final String? bulkPackUnit;

  ProductPackingPrice({
    this.locationID, 
    this.scanCode,
    this.itmCode,
    this.basePackQty,
    this.bulkPackUPrice,
    this.bulkPackUnit,
  });

  
  //Create empty Fun
  static ProductPackingPrice empty() => ProductPackingPrice(itmCode: '', bulkPackUnit: '',bulkPackUPrice: 0);
  // toJson() function
  Map<String, dynamic> toJson() {
    return {
      'itmCode': itmCode,
      'locationId': locationID,
      'scanCode': scanCode,
      'BasePackQty': basePackQty,
      'BulkPackUPrice': bulkPackUPrice,
      'BulkPackUnit': bulkPackUnit,
    };
  }

  // Factory method to create a ProductPackingPrice from a Map
  factory ProductPackingPrice.fromMap(Map<String, dynamic> data) {
    // print("PP data ${data}");
    return ProductPackingPrice(
      itmCode: data['itmCode']?.toString() ?? '',
      locationID: data['locationId']?.toString(),
      scanCode: data['scanCode']?.toString() ?? '',
      basePackQty: data['basePackQty'] ?? 0,  // Ensure it's converted to double
      bulkPackUPrice: data['bulkPackUPrice'] ?? 0,  // Ensure it's converted to double
      bulkPackUnit: data['bulkPackUnit']?.toString() ?? '',
    );
  }
}
