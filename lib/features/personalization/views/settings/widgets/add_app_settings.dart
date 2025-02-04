import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/features/personalization/controllers/settings_controller.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/validators/validation.dart';


class AddAppSettingsScreen extends StatelessWidget {
  const AddAppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    
    return Scaffold(
      appBar: const MAppBar(title: Text('Add App Settings'), showBackArrow: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Form(
          key: controller.settingsFormKey,
          child: Column(
            children: [
              TextFormField( 
                controller: controller.apiUrl,
                validator: (value) => MValidator.validateEmptyText('API URL', value),
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'API URL')),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField( 
                controller: controller.apiKey,
                validator: (value) => MValidator.validateEmptyText('API Key', value),
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.key), labelText: 'API Key')),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              // TextFormField( 
              //   controller: controller.docSeries,
              //   validator: (value) => MValidator.validateEmptyText('Document Series', value),
              //   decoration: const InputDecoration(prefixIcon: Icon(Iconsax.document), labelText: 'Document Series')),
              // const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField( 
                controller: controller.locationId,
                validator: (value) => MValidator.validateEmptyText('Location', value),
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.location), labelText: 'Default Location')),
              const SizedBox(height: MSizes.spaceBtwInputFields),
              TextFormField( 
                controller: controller.defaultCustomer,
                validator: (value) => MValidator.validateEmptyText('Default Customer', value),
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Default Customer')),
              const SizedBox(height: MSizes.defaultSpace),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed:  () => controller.addNewAppSettings(), child: const Text('Save'))),

            ],
          ),
        ),
      ),
    );
  }
}