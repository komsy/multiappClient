class SettingModel {
  String appKey;
  String apiUrl;
  String apiKey;
  String locationId;
  String defaultCustCode;
  String defaultLocation;
  String defaultPricing;
  int routeWiseSell;
  int setDefaultCust;
  int editOrder;
  int editAfter;
  int orderDays;
  int orderRecordDays;
  int isRSP;
  int prodNumber;
  int goLive;
  int exField1;
  int exField2;
  int exField3;
  String createdAt;
  

  SettingModel({
    required this.appKey,
    this.defaultCustCode = '',
    this.defaultLocation = '',
    this.apiUrl = '',
    this.apiKey = '',
    this.defaultPricing = '',
    this.routeWiseSell = 0,
    this.locationId ='00',
    this.setDefaultCust = 0,
    this.editOrder = 0,
    this.editAfter = 0,
    this.orderDays = 1,
    this.orderRecordDays = 1,
    this.isRSP = 0,
    this.prodNumber = 30,
    this.goLive = 0,
    this.exField1 = 0,
    this.exField2 = 0,
    this.exField3 = 0,
    this.createdAt ='',
  });

  // Empty helper function
  static SettingModel empty() => SettingModel(appKey: '');

  // Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'appKey': appKey,
      'defaultCustCode': defaultCustCode,
      'defaultLocation': defaultLocation,
      'APIURL': apiUrl,
      'APIKey': apiKey,
      'defaultPricing': defaultPricing,
      'routeWiseSell': routeWiseSell,
      'locationId': locationId,
      'setDefaultCust': setDefaultCust,
      'editOrder': editOrder,
      'editAfter': editAfter,
      'orderDays': orderDays,
      'orderRecordDays': orderRecordDays,
      'IsRSP': isRSP,
      'prodNumber': prodNumber,
      'goLive': goLive,
      'exField1': exField1,
      'exField2': exField2,
      'exField3': exField3,
      'createdAt': createdAt,
    };
  }

  // Create SettingModel from a map
  factory SettingModel.fromMap(Map<String, dynamic> data) {
    return SettingModel(
      appKey: data['appKey'] ?? '',
      defaultCustCode: data['defaultCustCode'] ?? '',
      defaultLocation: data['defaultLocation'] ?? '',
      apiUrl: data['APIURL'] ?? '',
      apiKey: data['APIKey'] ?? '',
      defaultPricing: data['defaultPricing'] ?? '',
      routeWiseSell: data['routeWiseSell'] ?? 0,
      locationId: data['locationId'] ?? '00',
      setDefaultCust: data['setDefaultCust'] ?? 0,
      editAfter: data['editAfter'] ?? 0,
      editOrder: data['editOrder'] ?? 0,
      orderDays: data['orderDays'] ?? 1,
      orderRecordDays: data['orderRecordDays'] ?? 7,
      isRSP: data['IsRSP'] ?? 0,
      prodNumber: data['prodNumber'] ?? 30,
      goLive: data['goLive'] ?? 0,
      exField1: data['exField1'] ?? 0,
      exField2: data['exField2'] ?? 0,
      exField3: data['exField3'] ?? 0,
      createdAt: data['createdAt'] ?? '',
    ); 
  }
}
