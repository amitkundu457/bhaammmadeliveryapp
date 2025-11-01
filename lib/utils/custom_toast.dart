import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

import 'default_colors.dart';

class ToastManager {
  static void showToast({
    required String msg,
    required BuildContext? context,
    Color? color,
  }) {
    context!.showSuccessBar(
      content: Text(msg),
      duration: const Duration(seconds: 5),
      indicatorColor: color ?? DefaultColor.green,
      position: FlashPosition.bottom,
      icon: const Icon(Icons.info_outline),
    );
  }
}
