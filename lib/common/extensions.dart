import 'package:flutter/material.dart';

extension PercentSized on double {
  double get hp =>
      (WidgetsBinding.instance.window.physicalSize.height * (this / 100));
  double get wp =>
      (WidgetsBinding.instance.window.physicalSize.width * (this / 100));
}

extension ResponsiveText on double {
  double get sp =>
      WidgetsBinding.instance.window.physicalSize.width / 100 * (this / 3);
}
