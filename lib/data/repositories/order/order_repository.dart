import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/features/personalization/models/setting_model.dart';
import 'package:easyapp/features/shop/models/order_item_model.dart';
import 'package:easyapp/features/shop/models/order_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Get all order
  Future<void> saveOrders(OrderModel order) async{
    try{
      await db.saveOrders(order);
    } catch (e) {
      print("eror saving order: $e");
      throw 'Something went wrong while saving Order Information. Please try again later';
    }
  }

  Future<void> saveOrderItems(OrderItemModel orderItem) async{
    try{
      await db.saveOrderItem(orderItem);
    } catch (e) {
      print("eror saving order: $e");
      throw 'Something went wrong while saving Order Information. Please try again later';
    }
  }
  
   Future<void> saveAppSettings(SettingModel settings) async{
    try{
      await db.saveAppSettings(settings);
    } catch (e) {
      print("eror saving SettingModel: $e");
      throw 'Something went wrong while saving SettingModel Information. Please try again later';
    }
  }
}