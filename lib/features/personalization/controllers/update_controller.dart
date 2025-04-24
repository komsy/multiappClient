import 'package:easyapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:flutter/material.dart';

class UpdateController extends GetxController {
  static UpdateController get instance => Get.find();

  final ShorebirdUpdater _updater = ShorebirdUpdater();
  final isUpdaterAvailable = false.obs;
  final isCheckingForUpdates = false.obs;
  final currentTrack = UpdateTrack.stable.obs;
  final currentPatch = Rxn<Patch>();

  late BuildContext context;

  void setContext(BuildContext ctx) {
    context = ctx;
    _init();
  }

  Future<void> _init() async {
    isUpdaterAvailable.value = _updater.isAvailable;
    try {
      final patch = await _updater.readCurrentPatch();
      currentPatch.value = patch;
    } catch (e) {
      debugPrint('Error reading current patch: $e');
    }
  }

  Future<void> checkForUpdate() async {
    if (isCheckingForUpdates.value) return;

    isCheckingForUpdates.value = true;
    try {
      final status = await _updater.checkForUpdate(track: currentTrack.value);
      switch (status) {
        case UpdateStatus.upToDate:
          MLoaders.successSnackBar(
            title: 'No Update',
            message: 'Your app is already up to date on the ${currentTrack.value.name} track.',
          );
          break;
        case UpdateStatus.outdated:
          await _downloadUpdate();
          break;
        case UpdateStatus.restartRequired:
          MLoaders.successSnackBar(
            title: 'Update Ready',
            message: 'A new patch is ready! Please restart the app.',
          );
          break;
        case UpdateStatus.unavailable:
          MLoaders.errorSnackBar(
            title: 'Unavailable',
            message: 'Unable to check for updates. Try again later.',
          );
          break;
      }
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Update Error', message: e.toString());
    } finally {
      isCheckingForUpdates.value = false;
    }
  }

  Future<void> _downloadUpdate() async {
    try {
      MLoaders.successSnackBar(title: 'Downloading', message: 'Downloading the latest patch...');
      await _updater.update(track: currentTrack.value);
      MLoaders.successSnackBar(
        title: 'Update Downloaded',
        message: 'A new patch has been downloaded. Please restart your app.',
      );
    } on UpdateException catch (e) {
      MLoaders.errorSnackBar(title: 'Download Failed', message: e.message);
    }
  }
}
