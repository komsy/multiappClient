class SettingModel {
  String appKey;
  String apiUrl;
  String apiKey;
  String locationId;
  String defaultCustCode;
  String defaultPricing;
  int routeWiseSell;
  int editOrder;
  int orderDays;
  int isRSP;
  String createdAt;

  SettingModel({
    required this.appKey,
    this.defaultCustCode = '',
    this.apiUrl = '',
    this.apiKey = '',
    this.defaultPricing = '',
    this.routeWiseSell = 0,
    this.locationId ='00',
    this.editOrder = 0,
    this.orderDays = 1,
    this.isRSP = 0,
    this.createdAt ='',
  });

  // Empty helper function
  static SettingModel empty() => SettingModel(appKey: '');

  // Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'appKey': appKey,
      'defaultCustCode': defaultCustCode,
      'APIURL': apiUrl,
      'APIKey': apiKey,
      'defaultPricing': defaultPricing,
      'routeWiseSell': routeWiseSell,
      'locationId': locationId,
      'editOrder': editOrder,
      'orderDays': orderDays,
      'IsRSP': isRSP,
      'createdAt': createdAt,
    };
  }

  // Create SettingModel from a map
  factory SettingModel.fromMap(Map<String, dynamic> data) {
    return SettingModel(
      appKey: data['appKey'] ?? '',
      defaultCustCode: data['defaultCustCode'] ?? '',
      apiUrl: data['APIURL'] ?? '',
      apiKey: data['APIKey'] ?? '',
      defaultPricing: data['defaultPricing'] ?? '',
      routeWiseSell: data['routeWiseSell'] ?? 0,
      locationId: data['locationId'] ?? '00',
      editOrder: data['editOrder'] ?? 0,
      orderDays: data['orderDays'] ?? 1,
      isRSP: data['IsRSP'] ?? 0,
      createdAt: data['createdAt'] ?? '',
    );
  }
}
