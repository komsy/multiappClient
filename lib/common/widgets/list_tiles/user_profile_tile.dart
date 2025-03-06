import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/features/personalization/views/settings/widgets/app_settings.dart';
import 'package:easyapp/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/images/m_circular_image.dart';
import 'package:easyapp/features/personalization/views/profile/widgets/change_name.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/image_strings.dart';

import '../../../features/personalization/controllers/user_controller.dart';

class MUserProfileTile extends StatelessWidget {
  const MUserProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final apiURL = AuthenticationRepository.instance.apiURL;
    
    return ListTile(
      leading: const MCircularImage(
          image: MImages.user, width: 50, height: 50, padding: 0),
      title: Text(
        controller.user.value.userName,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: MColors.white),
      ),
      subtitle: Text(
        controller.user.value.email,
        style:
            Theme.of(context).textTheme.bodyMedium!.apply(color: MColors.white),
      ),
      trailing: controller.user.value.userName == "admin" ?  IconButton(
          onPressed: () //=>Get.to(() => const ChangeName()),
              {
            if (apiURL.isEmpty) {
              MLoaders.warningSnackBar(
                  title: 'Oh Snap!',
                  message: 'Kindly update the app settings first!');
              Get.to(() => const AppSettingsScreen());
            } else  {
              Get.to(() => const ChangeName());
            } 
          },
          icon: const Icon(Iconsax.edit, color: MColors.white)): null,
    );
  }
}
