
  class CustomerModel {
    String cusCode;
    String? accType;
    num? crLimit;
    String? locationID;
    String companyName;
    num currBalance;

  CustomerModel({
    required this.cusCode,
    required this.currBalance,
    required this.companyName,
    this.crLimit,
    this.locationID,
    this.accType,
  });

  //Empty helper Function
  static CustomerModel empty() => CustomerModel(cusCode: '',companyName: '', currBalance:  0);

  //Convert model to Json structure so that you can store data in sqlite
  Map<String, dynamic> toJson() {
    return {
      'customerCode': cusCode,
      'accType': accType,
      'locationId': locationID,
      'companyName': companyName,
      'currBalance': currBalance,
      'crLimit': crLimit,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> data) {
      // print('CustomerModel.fromMap: ${data}');
    return CustomerModel(
      cusCode: data['customerCode']?.toString() ?? '', 
      accType: data['accType']?.toString() ?? '',  
      locationID: data['locationId']?.toString() ?? '',
      crLimit: data['crLimit'] ?? 0,
      companyName: data['companyName'].toString(), 
      currBalance:data['currBalance'] ?? 0,
    );
    }
}