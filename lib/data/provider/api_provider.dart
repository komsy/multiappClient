import 'dart:async';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/env.dart';
import 'package:multiapp/features/shop/models/customer_model.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/utils/popups/loaders.dart';


class ApiProvider {
  final deviceStorage = GetStorage();
  final LocalDatabase db = LocalDatabase.instance; // Reference to the database
  RxString apiURL = ''.obs; // API URL will be set dynamically
  int retryCount = 0; // Retry counter for requests

  late Dio _dio; // Declare Dio here to initialize dynamically

  // ApiProvider() {
  //   // Initialize Dio instance
  //   _dio = Dio(
  //     BaseOptions(
  //       baseUrl: apiURL.value, // Initially empty, will be updated dynamically
  //       connectTimeout: const Duration(seconds: 60),
  //       receiveTimeout: const Duration(seconds: 60),
  //       responseType: ResponseType.json,
  //       contentType: "application/json",
  //     ),
  //   );

  //   // Add interceptors
  //   _dio.interceptors.add(InterceptorsWrapper(
  //     onRequest: (options, handler) async {
  //       try {
  //         // Fetch JWT token from local storage
  //         final jwtToken = deviceStorage.read('jwt_token') ?? "";

  //         // Fetch App Key and API Key from the database
  //         final setting = await db.getSingleAppSetting();
  //         final appKey = setting?['appKey'] ?? "";
  //         final apiKey = setting?['APIKey'] ?? "";

  //         // Dynamically update the base URL before making a request
  //         if (apiURL.value.isNotEmpty) {
  //           options.baseUrl = apiURL.value;
  //         }

  //         // Add headers
  //         options.headers["Accept"] = "application/json";
  //         options.headers["Authorization"] = 'Bearer $jwtToken';
  //         options.headers["X-App-Key"] = appKey;
  //         options.headers["API-Key"] = apiKey;

  //         handler.next(options); // Proceed with the request
  //       } catch (e) {
  //         // Log and reject if something goes wrong
  //         print("Error in onRequest interceptor: $e");
  //         handler.reject(
  //           DioException(
  //             requestOptions: options,
  //             error: "Error adding headers: $e",
  //           ),
  //         );
  //       }
  //     },
  //     onError: (error, handler) async {
  //       // Handle 401 Unauthorized errors
  //       // if (error.response?.statusCode == 401) {
  //       //   print("Token expired. Attempting to refresh...");

  //       //   try {
  //       //     // Refresh the token
  //       //     String? newJwtToken = await AuthenticationRepository.instance.refreshToken();

  //       //   print("newJwtToken $newJwtToken");
  //       //     if (newJwtToken != null) {
  //       //       // Update the local storage with the new token
  //       //       await deviceStorage.write('jwt_token', newJwtToken);

  //       //       // Update headers with the new token
  //       //       _dio.options.headers["Authorization"] = 'Bearer $newJwtToken';

  //       //       // Retry the failed request
  //       //       final opts = error.requestOptions;
  //       //       opts.headers["Authorization"] = 'Bearer $newJwtToken';
  //       //       final response = await _dio.fetch(opts);

  //       //       return handler.resolve(response);
  //       //     } else {
  //       //       print("Token refresh failed.");
  //       //       return handler.reject(error); // Reject if token refresh fails
  //       //     }
  //       //   } catch (refreshError) {
  //       //     print("Error during token refresh: $refreshError");
  //       //     return handler.reject(error); // Reject if token refresh process fails
  //       //   }
  //       // }

  //       // For other errors, pass them along
  //       // MLoaders.errorSnackBar(
  //       //   title: 'Oh Snap!',
  //       //   message: 'Something went wrong. Please try again.',
  //       // );
  //       //  print("Api error $error");
  //       return handler.reject(error);
  //     },
  //   ));

  //   // Fetch and set API URL dynamically
  //   fetchAndSetApiUrl();
  // }

  // // Expose Dio instance
  // // Dio get dio => _dio;


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
          print("Error in onRequest interceptor: $e");
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
// }

//   // Fetch and dynamically update the API URL
//   Future<void> fetchAndSetApiUrl() async {
//     try {
//       final setting = await db.getSingleAppSetting();
      
//       if (setting != null && setting['APIURL'] != null) {
//         apiURL.value = setting['APIURL'];
//         // Update Dio's base URL dynamically
//         _dio.options.baseUrl = apiURL.value;
//       } else {
//         throw Exception("API URL not found!");
//       }
//     } catch (e) {
//       MLoaders.errorSnackBar(title: 'Error', message: e.toString());
//     }
//   }

  



  Future<List<dynamic>> getAPIData(String apiName) async {
    try {
      // Construct the full URL to print it
      final fullUrl = '${_dio.options.baseUrl}$apiName';
      print("Request URL: $fullUrl");

      final response = await _dio.get(apiName);
      return response.data as List;
    } on DioException catch (err) {
      // Get error message from the response or set a fallback
      final errorMessage = err.response?.data is Map<String, dynamic> 
          ? err.response?.data['message'] ?? 'Something went wrong'
          : 'Something went wrong.'; // Default message for unexpected response structures

      // Handle specific status codes
      if (err.response?.statusCode == 401) {
        return Future.error(errorMessage); // Unauthorized
      } else if (err.response?.statusCode == 403) {
        return Future.error('Forbidden: $errorMessage'); // Forbidden
      } else if (err.response?.statusCode == 500) {
        return Future.error('Server Error: $errorMessage'); // Internal server error
      } else {
        return Future.error(errorMessage); // Generic error handler
      }
    }
  }
  

  Future<Map<String, dynamic>>  acknowledgeCustomerData(String apiName, CustomerModel customer) async {
  try {
    final fullUrl = '${_dio.options.baseUrl}$apiName';
    // print("Request URL: $fullUrl");

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
      // Get error message from the response or set a fallback
      final errorMessage = err.response?.data is Map<String, dynamic> 
          ? err.response?.data['message'] ?? 'Something went wrong'
          : 'Something went wrong.'; // Default message for unexpected response structures

      // Handle specific status codes
      if (err.response?.statusCode == 401) {
        return Future.error(errorMessage); // Unauthorized
      } else if (err.response?.statusCode == 403) {
        return Future.error('Forbidden: $errorMessage'); // Forbidden
      } else if (err.response?.statusCode == 500) {
        return Future.error('Server Error: $errorMessage'); // Internal server error
      } else {
        return Future.error(errorMessage); // Generic error handler
      }
    }
  }

  Future<Map<String, dynamic>> acknowledgeProductData(String apiName, ProductModels product) async {
  try {
    final fullUrl = '${_dio.options.baseUrl}$apiName';
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
      // Get error message from the response or set a fallback
      final errorMessage = err.response?.data is Map<String, dynamic> 
          ? err.response?.data['message'] ?? 'Something went wrong'
          : 'Something went wrong.'; // Default message for unexpected response structures

      // Handle specific status codes
      if (err.response?.statusCode == 401) {
        return Future.error(errorMessage); // Unauthorized
      } else if (err.response?.statusCode == 403) {
        return Future.error('Forbidden: $errorMessage'); // Forbidden
      } else if (err.response?.statusCode == 500) {
        return Future.error('Server Error: $errorMessage'); // Internal server error
      } else {
        return Future.error(errorMessage); // Generic error handler
      }
    }
  }


  

  Future<Map<String, dynamic>>  sendOrders(String apiName) async {
  try {
    final fullUrl = '${_dio.options.baseUrl}$apiName';
    // print("Request URL: $fullUrl");
    final orders = await db.getOrders();

    // Handle null or empty result (no categories found)
    if (orders == null || orders.isEmpty) {
      return Future.error("No orders found");
    }

    // print('Fetched orders: $orders');
    final response = await _dio.post(apiName, data: orders);
    // print('order response: ${response.data}');
    return response.data;
  } on DioException catch (err) {
      // Get error message from the response or set a fallback
      final errorMessage = err.response?.data is Map<String, dynamic> 
          ? err.response?.data['message'] ?? 'Something went wrong'
          : 'Something went wrong.'; // Default message for unexpected response structures

      // Handle specific status codes
      if (err.response?.statusCode == 401) {
        return Future.error(errorMessage); // Unauthorized
      } else if (err.response?.statusCode == 403) {
        return Future.error('Forbidden: $errorMessage'); // Forbidden
      } else if (err.response?.statusCode == 500) {
        return Future.error('Server Error: $errorMessage'); // Internal server error
      } else {
        return Future.error(errorMessage); // Generic error handler
      }
    }
  }

}
