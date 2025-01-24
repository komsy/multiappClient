class ProductUnitConverter {
  final String? itmCode;
  final String? locationID;
  final num? bulkPackQty;  // Changed to double
  final String? bulkPackUnit;
  final num? basePackQty;  // Changed to double
  final String? basePackUnit;

  ProductUnitConverter({
    this.locationID, 
    this.itmCode,
    this.bulkPackQty,
    this.bulkPackUnit,
    this.basePackQty,
    this.basePackUnit,
  });

  
  // toJson() function
  Map<String, dynamic> toJson() {
    return {
      'itmCode': itmCode,
      'locationId': locationID,
      'bulkPackQty': bulkPackQty,
      'bulkPackUnit': bulkPackUnit,
      'basePackQty': basePackQty,
      'basePackUnit': basePackUnit,
    };
  }
  // Factory method to create a ProductUnitConverter from a Map
  factory ProductUnitConverter.fromMap(Map<String, dynamic> data) {
    //  print("UC data ${data}");
    return ProductUnitConverter(
      itmCode: data['itmCode']?.toString() ?? '',
      locationID: data['locationId']?.toString(),
      bulkPackQty: data['BulkPackQty'] ?? 0,  // Ensure it's converted to double
      bulkPackUnit: data['BulkPackUnit']?.toString() ?? '',
      basePackQty: (data['BasePackQty'] ?? 0).toDouble(),  // Ensure it's converted to double
      basePackUnit: data['BasePackUnit']?.toString() ?? '',
    );
  }
}
