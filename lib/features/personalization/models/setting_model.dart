
class SettingModel {
  String appKey;
  String androidId;
  String apiUrl;
  String apiKey;
  String docSeries;
  String defaultCustomer;
  int docNo;
  int isRSP;
    String createdAt;

  SettingModel({
    required this.appKey,
    this.androidId = '',
    this.apiUrl = '',
    this.apiKey = '',
    this.docSeries = '',
    this.defaultCustomer = 'Cash Sale',
    this.docNo = 0,
    this.isRSP = 0,
    this.createdAt ='',
  });

  // Empty helper function
  static SettingModel empty() => SettingModel(appKey: '');

  // Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'appKey': appKey,
      'androidId': androidId,
      'APIURL': apiUrl,
      'APIKey': apiKey,
      'docSeries': docSeries,
      'defaultCustomer': defaultCustomer,
      'docNo': docNo,
      'IsRSP': isRSP,
      'createdAt': createdAt,
    };
  }

  // Create SettingModel from a map
  factory SettingModel.fromMap(Map<String, dynamic> data) {
    return SettingModel(
      appKey: data['appKey'] ?? '',
      androidId: data['androidId'] ?? '',
      apiUrl: data['APIURL'] ?? '',
      apiKey: data['APIKey'] ?? '',
      docSeries: data['docSeries'] ?? '',
      defaultCustomer: data['defaultCustomer'] ?? 'Cash Sale',
      docNo: data['docNo'] ?? 0,
      isRSP: data['IsRSP'] ?? 0,
      createdAt: data['createdAt'] ?? '',
    );
  }
}
