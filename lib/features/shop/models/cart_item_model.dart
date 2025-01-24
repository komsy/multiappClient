
class CartItemModel {
    String itmCode;
    int quantity;
    String title;
    double price;
    double exVat;
    double taxAmount;
    String unit;
    String basicUnit;
    String variationId; 
    String defaultPricing;
    int vatRate;
    String vatCode;
    String? selectedVariation;

  CartItemModel({
    required this.defaultPricing,
    required this.itmCode,
    required this.quantity,
    required this.unit,
    required this.basicUnit,
    this.variationId ='',
    this.price = 0.0,
    this.exVat = 0.00,
    this.taxAmount = 0.00,
    this.title ='',
    required this.vatRate,
    required this.vatCode,
    this.selectedVariation,
  });

  //Create Empty function for clean code
  static CartItemModel empty() => CartItemModel(itmCode: '',vatRate:0, quantity: 0, vatCode: '', unit: '', basicUnit: '', defaultPricing: 'QSP');
  // String formattedTaxAmount = taxAmount.toStringAsFixed(2);
  //JSON Format
  Map<String, dynamic> toJson() {
    return {
      'itmCode': itmCode,
      'Title': title,
      'Unit': unit,
      'basicUnit': basicUnit,
      'defaultPricing': defaultPricing,
      'Price': price,
      'TaxAmount': taxAmount,
      'Quantity': quantity,
      'vatRate': vatRate,
      'vatCode': vatCode,
      'VariationId': variationId,
      'SelectedVariation': selectedVariation,
    };
  }

    //Create a cartItem from Json map
  factory CartItemModel.fromJson(Map<String, dynamic> json){
    // print("json: $json");
    return CartItemModel(
        itmCode: json['itmCode'],  
        title: json['Title'],  
        unit: json['Unit'],  
        basicUnit: json['basicUnit'],  
        price: json['Price']?.toDouble(), 
        taxAmount: json['TaxAmount']?.toDouble(), 
        defaultPricing: json['defaultPricing'] as String, 
        quantity: json['Quantity'],  
        vatRate: json['vatRate'],  
        vatCode: json['vatCode'],  
        variationId: json['VariationId'],  
        selectedVariation: json['SelectedVariation'],  
      );
  }
}