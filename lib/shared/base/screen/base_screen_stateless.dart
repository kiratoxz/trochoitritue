import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_logger/pretty_logger.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

abstract class BaseScreenStateless extends HookWidget with BaseScreenMixin {
  BaseScreenStateless({
    Key? key,
  }) : super(key: key);
  final FToast fToast = FToast();

  void showToast(BuildContext context, String message) {
    try {
      fToast.init(context);
      fToast.showToast(
          child: ToastInfoView(message),
          toastDuration: const Duration(seconds: 4),
          positionedToastBuilder: (context, child) {
            return Positioned(top: 24, left: 32, right: 32, child: child);
          });
    } catch (e) {
      PLog.error("Error while showing toast $e");
    }
  }
}
