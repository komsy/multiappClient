import 'package:multiapp/features/shop/models/order_item_model.dart';
import 'package:multiapp/utils/constants/enums.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class OrderModel {
    final String id;
    // final String? docNo;
    final String orderDate;
    final String locationId;
    // final String? orderSeries;
    final String customerCode;
    final String companyName;
    final double totalAmount;
    final String paymentMethod;
    final String? orderStatus;
    final String createdBy;
    final String? address;
    final String? naration;
    final String? createdAt;
    String? cashCustomerName;
    String? cashPhoneNumber;
    String? cashPinNo;
    String? cashAddress;
    final List<OrderItemModel>? orderItems;
 
  OrderModel( {this.cashCustomerName, this.cashPhoneNumber,this.cashPinNo, this.cashAddress,this.naration,  required this.locationId,  required this.customerCode, required this.companyName, this.orderItems,required this.id, this.createdBy ='', this.orderStatus, 
  required this.totalAmount, required this.orderDate,this.paymentMethod = 'cash', this.address, this.createdAt});

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedCreatedAt => createdAt != null ? THelperFunctions.getFormattedDate(createdAt!) : '';

  String get orderStatusText => orderStatus == OrderStatus.delivered
  ? 'Delivered'
  : orderStatus == OrderStatus.shipped
    ? 'Shipment on the way'
    : 'Processing';

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'docNo': docNo,
      'orderDate': orderDate,
      'locationId': locationId,
      // 'orderSeries': orderSeries,
      'customerCode': customerCode,
      'companyName': companyName,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus.toString(),
      'createdBy': createdBy,
      'naration': naration,
      'cashCustomerName': cashCustomerName,
      'cashPhoneNumber': cashPhoneNumber,
      'cashPinNo': cashPinNo,
      'cashAddress': cashAddress,
      // 'address': address?.toJson(), //convert AddressModel to map
      'createdAt': createdAt,
      // 'items': orderItems.map((item) => item.toJson()).toList(), //Convert CartItemModel to map
    };
  }


  factory OrderModel.fromMap(Map<String, dynamic> data) {
    // print("order data: $data");
    //Map JSON record to the model
    return OrderModel(
        id: data['id'].toString(), 
        // docNo: data['docNo'] as String, 
        orderDate: data['orderDate'] as String, 
        // orderDate: (data['orderDate'] as Timestamp).toDate(), 
        locationId: data['locationId'] as String, 
        // orderSeries: data['orderSeries'] as String, 
        customerCode: data['customerCode'] as String, 
        companyName: data['companyName'] as String, 
        totalAmount: data['totalAmount'] as double, 
        paymentMethod: data['paymentMethod'] as String,
        naration: data['naration'] as String,
        cashCustomerName: data['cashCustomerName'] as String,
        cashPhoneNumber: data['cashPhoneNumber'] as String,
        cashPinNo: data['cashPinNo'] as String,
        cashAddress: data['cashAddress'] as String,
        // orderStatus: OrderStatus.values.firstWhere((e) => e.toString() == data['orderStatus']), 
        orderStatus: data['orderStatus']as String,
        createdBy: data['createdBy'] as String, 
        // address: AddressModel.fromMap(data['address'] as Map<String, dynamic>),
        createdAt: data['createdAt']  == null ? null : data['createdAt'] as String,
        // createdAt: data['createdAt']  == null ? null : (data['createdAt'] as Timestamp).toDate(),
        orderItems: data['OrderItems'] != null
              ? (data['OrderItems'] as List<dynamic>)
                  .map((item) => OrderItemModel.fromMap(item))
                  .toList()
              :  null,
        // orderItems: (data['OrderItems'] as List<dynamic>).map((itemdata) => OrderItemModel.fromJson(itemdata as Map<String, dynamic>)).toList(),
      );
  }

}