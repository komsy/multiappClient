import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/common/widgets/images/m_circular_image.dart';
import 'package:multiapp/common/widgets/shimmers/shimmer.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/features/personalization/views/profile/widgets/change_name.dart';
import 'package:multiapp/features/personalization/views/profile/widgets/profile_menu.dart';
import 'package:multiapp/navigation_menu.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/constants/text_strings.dart';

import '../../../../utils/constants/enums.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar:
          const MAppBar(title: Text(MTexts.profileTitle), showBackArrow: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Obx(() => Column(
                children: [
                  const SizedBox(
                    child: Column(
                      children: [
                        Center(
                            child: MCircularImage(
                                image: MImages.user,
                                width: 80,
                                height: 80,
                                imageType: ImageType.asset)),
                      ],
                    ),
                  ),

                  //Profile Information Details
                  const SizedBox(height: MSizes.spaceBtwItems / 2),
                  const Divider(),
                  const SizedBox(height: MSizes.spaceBtwItems),
                  const MSectionHeading(
                    title: MTexts.profileSectionHeading1,
                    showActionButton: false,
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems),

                  MProfileMenu(
                      onPressed: () => Get.to(() => const ChangeName()),
                      title: 'User Name',
                      value: controller.user.value.userName),
                  MProfileMenu(
                      showIcon: false,
                      onPressed: () {},
                      title: 'Email',
                      value: controller.user.value.email),

                  const SizedBox(height: MSizes.spaceBtwItems * 10),
                  SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      onPressed: () => Get.off(() => const NavigationMenu()),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: MColors.dark),
                      child: Text(
                        "Go Back",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: MColors.light),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
