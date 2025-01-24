import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:multiapp/features/shop/models/credit_customer_model.dart';
import 'package:multiapp/features/shop/models/customer_model.dart';
import 'package:multiapp/utils/popups/loaders.dart';
import 'dart:developer'; 
import 'dart:async';


class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Variables
  // RxBool refreshData = true.obs;
  final Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;
  final isLoading = false.obs;
  RxList<CustomerModel> featuredCustomers = <CustomerModel>[].obs;
  RxString searchKeyword = ''.obs; // Observes changes to the search keyword
  RxString naration = ''.obs; // Observes changes to the naration
  Timer? _debounce; // Declare a Timer variable
  RxInt refreshData = 0.obs; // Observes changes to force FutureBuilder refresh
  final RxBool refreshSignal = false.obs; // Signal to refresh data
  final creditController = Get.put(CreditCustomerController());

  @override
  void onInit() {
    // fetchFeaturedCustomers();
    fetchCustomers();
    super.onInit();
    debounce(refreshSignal, (_) => fetchCustomers(), time: const Duration(milliseconds: 300)); 
  }
  
  Future<List<CustomerModel>> fetchCustomers() async {
  try {
    List<Map<String, dynamic>> snapshot;

    // log('Search keyword: $searchKeyword');
    if (searchKeyword.isEmpty) {
      // Fetch all customers when there's no search keyword
      snapshot = await db.getCustomers();
    } else {
      // Search for customers using the keyword
      snapshot = await db.getCustomerSearch('%$searchKeyword%'); // Use wildcards for LIKE query
    }
    // log('Search snapshot: $snapshot');
    // Handle null or empty result
    if (snapshot.isEmpty) {
      return [];
    }

    // Map each customer from the snapshot to a CustomerModel instance
    final allCustomers = snapshot.map((data) {
      return CustomerModel.fromMap(data);
    }).toList();

    // Set the selectedCustomer based on company name with error handling
    selectedCustomer.value = allCustomers.firstWhere(
      (customer) => customer.companyName == "Cash Sale",
      orElse: () => CustomerModel.empty(), // Provide a default empty customer
    );

    // Assign all customers to featuredCustomers
    featuredCustomers.assignAll(allCustomers);

    return allCustomers;
  } catch (e) {
    MLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    return [];
  }
}
  // Called when the search bar changes
  void saveNaration(String keyWord) {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // Cancel the previous timer if it's still active

    _debounce = Timer(const Duration(seconds: 1), () { // Set a delay of 1 second
      naration.value = keyWord; // Update the naration value
    });
  }

  // Called when the search bar changes
  void fetchSearchCustomer(String keyWord) {
    searchKeyword.value = keyWord; // Update the keyword
    refreshData.value++; // Trigger FutureBuilder refresh
  }

  Future selectCustomer(String? newSelectedCustomer) async {
    try {
      // // Clear the selected credit customer details from db and observable
      // if(creditController.selectedCrClient.value.customerName.isNotEmpty){
      //   await db.updateSelectedField(creditController.selectedCrClient.value.customerName, 0);
      // }
      // creditController.selectedCrClient.value = CreditCustomerModel.empty();
      await creditController.clearCashCustomer(); // Clear the cash customer details from db and observable if any exists.

      // get the customer details
      // and assign selectedCustomer.value 
      selectedCustomer.value = featuredCustomers.firstWhere(
        (customer) => customer.companyName == newSelectedCustomer,
        orElse: () => CustomerModel.empty(),
      );
      //  print(" new selected customer: ${selectedCustomer.value.crLimit}");
    } catch (e) {
     MLoaders.errorSnackBar(title: 'Error in Selection', message: e.toString());
    }
  }
}