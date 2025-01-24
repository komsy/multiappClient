
  class CreditCustomerModel {
    String customerName;
    String phoneNumber;
    String? pinNo;
    String? address;
    int selectedCrCustomer;

  CreditCustomerModel({
    required this.customerName,
    this.pinNo,
    this.address,
    required this.phoneNumber,
    this.selectedCrCustomer = 1,
  });

  //Empty helper Function
  static CreditCustomerModel empty() => CreditCustomerModel(customerName: '', phoneNumber: '');

  //Convert model to Json structure so that you can store data in sqlite
  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'pinNo': pinNo,
      'selectedCrCustomer': selectedCrCustomer,
    };
  }

  factory CreditCustomerModel.fromMap(Map<String, dynamic> data) {
      // print('CustomerModel.fromMap: ${data}');
    return CreditCustomerModel(
      customerName: data['customerName']?.toString() ?? '', 
      phoneNumber: data['phoneNumber']?.toString() ?? '',  
      address: data['address']?.toString() ?? '',
      pinNo: data['pinNo'] ?? '',
      selectedCrCustomer: data['selectedCrCustomer'] as int, 
    );
    }
}