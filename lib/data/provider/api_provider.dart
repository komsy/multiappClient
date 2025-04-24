import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/features/shop/models/customer_model.dart';
import 'package:easyapp/features/shop/models/product_model.dart';
import 'package:easyapp/utils/popups/loaders.dart';


class ApiProvider {
  final deviceStorage = GetStorage();
  final LocalDatabase db = LocalDatabase.instance; // Reference to the database
  RxString apiURL = ''.obs; // API URL will be set dynamically
  int retryCount = 0; // Retry counter for requests

  late Dio _dio; // Declare Dio here to initialize dynamically

  ApiProvider() {
    // Initialize Dio instance
    _dio = Dio(
      BaseOptions(
        baseUrl: apiURL.value, // Initially empty, will be updated dynamically
        connectTimeout: const Duration(seconds: 6000),
        receiveTimeout: const Duration(seconds: 6000),
        responseType: ResponseType.json,
        contentType: "application/json",
      ),
    );
 
    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Fetch the JWT token from local storage
          final jwtToken = deviceStorage.read('jwt_token') ?? "";
  
          // Fetch the App Key from the database
          final setting = await db.getSingleAppSetting();
          final appKey = setting?['appKey'] ?? "";
          final apiKey = setting?['APIKey'] ?? "";

          // Dynamically update the base URL before making a request
          if (apiURL.value.isNotEmpty) {
            options.baseUrl = apiURL.value;
          }

          // Add headers
          options.headers["Accept"] = "application/json";
          options.headers["Authorization"] = 'Bearer $jwtToken';
          options.headers["X-App-Key"] = appKey;
          options.headers["API-Key"] = apiKey;

          handler.next(options); // Proceed with the request
        } catch (e) {
          // Log and reject if something goes wrong
          // print("Error in onRequest interceptor: $e");
          handler.reject(
            DioException(
              requestOptions: options,
              error: "Error adding headers: $e",
            ),
          );
        }
      },
      onError: (error, handler) async {
        // if (error.response?.statusCode == 401) { 
        //   print("expired");
        //   String? newRefreshToken = await AuthenticationRepository.instance.refreshToken();
        //   _dio.options.headers["Authorization"] = 'Bearer $newRefreshToken';

        //   return handler.resolve(await _dio.fetch(error.requestOptions));
        // } else {
        //   MLoaders.errorSnackBar( title: 'Oh Snap!',message: 'Something went wrong.',
        //   );
          return handler.reject(error);
        // }
        // return handler.next(error); // Pass other errors
      },
    ));
    // Fetch and set API URL dynamically
    fetchAndSetApiUrl();
  }

  // Fetch and dynamically update the API URL
  Future<void> fetchAndSetApiUrl() async {
    try {
      final setting = await db.getSingleAppSetting();
      if (setting != null && setting['APIURL'] != null) {
        apiURL.value = setting['APIURL']; // Update the API URL dynamically
        _dio.options.baseUrl = apiURL.value;
      } else {
        throw Exception("API URL not found in settings!");
      }
    } catch (e) {
      MLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to set API URL: $e',
      );
    }
  }


  Future<List<dynamic>> getAPIData(String apiName) async {
  try {
      final response = await _dio.get(apiName);
      return response.data as List;
    } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }
  

  Future<Map<String, dynamic>>  acknowledgeCustomerData(String apiName, CustomerModel customer) async {
  try {
    // Convert customer to a map and add additional fields
    final formData = {
      'status': 'success',
      'message': 'Data received successfully',
      'cusCode': customer.cusCode,
      'locationID': customer.locationID,
      'date': DateTime.now().toIso8601String(),
      // ...customer.toJson(), // Spread operator to include customer fields
    };
    final response = await _dio.post(apiName, data: formData);

    return response.data;
  } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }

  Future<Map<String, dynamic>> acknowledgeProductData(String apiName, ProductModels product) async {
  try {
    // final fullUrl = '${_dio.options.baseUrl}$apiName';
    // print("Request update URL: $fullUrl");

    // Convert product to a map and add additional fields
    final formData = {
      'status': 'success',
      'message': 'Data received successfully',
      'itmCode': product.itmCode,
      'locationID': product.locationID,
      'date': DateTime.now().toIso8601String(),
    };
    
    final response = await _dio.post(apiName, data: formData);
    return response.data;
  } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }


  

  Future<Map<String, dynamic>>  sendOrders(String apiName) async {
  try { 
    final orderDays = AuthenticationRepository.instance.orderDays.value;
    final orderRecordDays = AuthenticationRepository.instance.orderRecordDays.value;
    const isSending=true;

    // print("Request URL: $fullUrl");
    final orders = await db.getOrders(orderDays, isSending);
    // Calculate the total sum of totalAmount and no of orders
    double totalSum = orders!.fold(0, (sum, order) => sum + (order["totalAmount"] as double));
    final noofOrders = orders.length;

    // Handle null or empty result (no categories found)
    if (orders.isEmpty) {
      return Future.error("No orders found");
    }

    // print('Fetched orders: $orders');
    final response = await _dio.post(apiName, data: orders);
    // print('order response: ${response.data}');
    
    //if successful update ordersrecord
    if (response.data['code'] == 200 &&  response.data['acknowledgments'].isNotEmpty) {
      await db.updateOrderRecords(noofOrders, totalSum, orderRecordDays);
    }
    return response.data;
  } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }
  Future<Map<String, dynamic>>  sendLocationData(String apiName) async {
  try { 
 
    // print("Request URL: $fullUrl");
    final location = await db.getCurrLocation();

    // Handle null or empty result (no categories found)
    if (location.isEmpty) {
      return Future.error("No location found");
    }

    // print('Fetched location: $location');
    final response = await _dio.post(apiName, data: location);
    // print('order response: ${response.data}');
    
    return response.data;
  } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }
  //send user data
  Future<Map<String, dynamic>>  checkAppUser(String userName,String email) async {
  try {

    final formData = {
      'userName': userName,
      'email': email,
    };
    
    final response = await _dio.post("checkAppUser", data: formData);

    return response.data;
  } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }
  
  Future<Map<String, dynamic>>  deleteUserAccount(String email) async {
  try {

    final formData = {
      'email': email,
    };
    
    final response = await _dio.post("deleteUserAccount", data: formData);

    return response.data;
  } on DioException catch (err) {
      return Future.error(handleDioError(err));  // Using the reusable function
    }
  }


String handleDioError(DioException err) {
  // Default error message
  String errorMessage = 'Something went wrong.';

  // If the response contains an error message, use it
  if (err.response?.data is Map<String, dynamic>) {
    errorMessage = err.response?.data['message'] ?? errorMessage;
  }

  // Handle different Dio error types
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timeout. Please check your internet.';
    case DioExceptionType.receiveTimeout:
      return 'Server took too long to respond.';
    case DioExceptionType.badResponse:
      if (err.response != null) {
        switch (err.response!.statusCode) {
          case 400:
            return 'Bad request: $errorMessage';
          case 401:
            return 'Unauthorized: $errorMessage';
          case 403:
            return 'Forbidden: $errorMessage';
          case 404:
            return 'Not Found: $errorMessage';
          case 500:
            return 'Server Error: $errorMessage';
          default:
            return 'Error: $errorMessage';
        }
      }
      break;
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    case DioExceptionType.connectionError:
      return 'No internet connection.';
    case DioExceptionType.unknown:
    default:
      return errorMessage;
  }

  return errorMessage;
}


}
