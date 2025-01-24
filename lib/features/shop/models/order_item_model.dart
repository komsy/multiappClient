
class OrderItemModel {
    String orderId;
    // String? docNo;
    String locationId;
    String itmCode;
    String longName;
    int quantity;
    String unit;
    String basicUnit;
    int vatRate;
    String vatCode;
    double costPrice;
    String defaultPricing;
    double amount;
    double exVat;
    double vatAmount;
    String createdBy;
    String createdAt;
    
  OrderItemModel({
    required this.defaultPricing,
    required this.orderId,
    // this.docNo,
    required this.locationId,
    required this.itmCode,
    required this.longName,
    required this.quantity,
    required this.unit,
    required this.basicUnit,
    required this.vatRate,
    required this.vatCode,
    this.vatAmount = 0.00,
    this.amount = 0.0,
    this.costPrice = 0.0,
    this.exVat = 0.00,
    this.createdBy ='Admin',
    this.createdAt ='',
  });

  //Create Empty function for clean code
  // static OrderItemModel empty() => OrderItemModel(itmCode: '',vatRate:0, quantity: 0, orderId: '', docNo: '');
  // String formattedTaxAmount = taxAmount.toStringAsFixed(2);
  //JSON Format
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      // 'docNo': docNo,
      'locationId': locationId,
      'itmCode': itmCode,
      'longName': longName,
      'quantity': quantity,
      'unit': unit,
      'basicUnit': basicUnit,
      'defaultPricing': defaultPricing,
      'vatRate': vatRate,
      'vatCode': vatCode,
      'amount': amount,
      'costPrice': costPrice,
      'exVat': exVat,
      'vatAmount': vatAmount,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }


  //Create a OrderItem from Json map
  factory OrderItemModel.fromMap(Map<String, dynamic> json) {
    return OrderItemModel(
      orderId: json['orderId'].toString() ?? '',
      // docNo: json['docNo'] ?? '',
      locationId: json['locationId'] ?? '',
      itmCode: json['itmCode'] ?? '',
      longName: json['longName'] ?? '',
      quantity: json['quantity'] ?? 0,
      basicUnit: json['basicUnit'] ?? '',
      defaultPricing: json['defaultPricing'] as String, 
      unit: json['unit'] ?? '',
      vatRate: json['vatRate'] ?? 0,
      vatCode: json['vatCode'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      costPrice: json['costPrice']?.toDouble() ?? 0.0,
      exVat: json['exVat']?.toDouble() ?? 0.0,
      vatAmount: json['vatAmount']?.toDouble() ?? 0.0,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

}