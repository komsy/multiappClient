import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'ACCESS_TOKEN', obfuscate: true)
  static String accessToken = _Env.accessToken;

  @EnviedField(varName: 'REFRESH_TOKEN')
  static String refreshToken = _Env.refreshToken;

  @EnviedField(varName: 'API_URL')
  static String apiUrl = _Env.apiUrl;

  @EnviedField(varName: 'PRODUCT_API_URL')
  static String productApiUrl = _Env.productApiUrl;

  @EnviedField(varName: 'PRODUCT_UNIT_API_URL')
  static String unitApiUrl = _Env.unitApiUrl;

  @EnviedField(varName: 'PRODUCT_PACKAGING_API_URL')
  static String packagingApiUrl = _Env.packagingApiUrl;

  @EnviedField(varName: 'CATEGORY_API_URL')
  static String categoryApiUrl = _Env.categoryApiUrl;

  @EnviedField(varName: 'CUSTOMER_API_URL')
  static String customerApiUrl = _Env.customerApiUrl;

  @EnviedField(varName: 'ACK_CUSTOMER_API_URL')
  static String ackCustomerApiUrl = _Env.ackCustomerApiUrl;

  @EnviedField(varName: 'ACK_PRODUCT_API_URL')
  static String ackProductApiUrl = _Env.ackProductApiUrl;

  @EnviedField(varName: 'PRODUCT_TABLE')
  static String productTable = _Env.productTable;
  
  @EnviedField(varName: 'PRODUCT_PP_TABLE')
  static String productPPTable = _Env.productPPTable;
  
  @EnviedField(varName: 'PRODUCT_UC_TABLE')
  static String productUCTable = _Env.productUCTable;
  
  @EnviedField(varName: 'CATEGORY_TABLE')
  static String categoryTable = _Env.categoryTable;
  
  @EnviedField(varName: 'CUSTOMER_TABLE')
  static String customerTable = _Env.customerTable;
  
  @EnviedField(varName: 'ORDER_TABLE')
  static String orderTable = _Env.orderTable;
  
  @EnviedField(varName: 'ORDER_TRN_TABLE')
  static String orderTrnTable = _Env.orderTrnTable;

  @EnviedField(varName: 'USER_TABLE')
  static String userTable = _Env.userTable;

}