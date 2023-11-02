import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_logger/pretty_logger.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';

mixin BaseScreenMixin {
  @protected
  void initWithContext(BuildContext context) {}
}

mixin ScreenStatefulMixin<CS extends StatefulWidget> on State<CS> {
  void showToast(BuildContext context, String message,
      {Widget? icon,
      bool isCenterMessage = true,
      double? bottomPosition,
      double? leftPosition,
      double? rightPosition,
      Duration? toastDuration}) {
    try {
      final FToast fToast = FToast();
      fToast.init(context);
      fToast.removeQueuedCustomToasts();
      fToast.showToast(
          child: ToastInfoView(
            message,
            icon: icon,
            isCenterMessage: isCenterMessage,
          ),
          toastDuration: toastDuration ?? const Duration(seconds: 4),
          positionedToastBuilder: (context, child) {
            return Positioned(
              bottom: bottomPosition ?? 24,
              left: leftPosition ?? 32,
              right: rightPosition ?? 32,
              child: child,
            );
          });
    } catch (e) {
      PLog.error("Error while showing toast $e");
    }
  }

  void showCustomToast(BuildContext context,
      {required child, Duration? toastDuration}) {
    try {
      final FToast fToast = FToast();
      fToast.init(context);
      fToast.removeQueuedCustomToasts();
      fToast.showToast(
          child: child,
          toastDuration: toastDuration ?? const Duration(milliseconds: 1500),
          positionedToastBuilder: (context, child) {
            return Positioned.fill(
              child: Center(child: child),
            );
          });
    } catch (e) {
      PLog.error("Error while showing toast $e");
    }
  }

  void showErrorMessage(
    String? errorMessage, {
    bool onlyShowWhenNoInternet = false,
  }) {
    showToast(
      context,
      errorMessage ?? '',
    );
  }

  void showSuccessfulMessage(
    String? message, {
    Widget? icon,
    bool isCenterMessage = true,
  }) {
    showToast(
      context,
      message ?? 'Successful',
      icon: icon,
      isCenterMessage: isCenterMessage,
    );
  }

  void showLoading() {
    LoadingOverlay().showLoadingPage(context);
  }

  void hideLoading() {
    LoadingOverlay().hideLoadingPage();
  }
}

mixin ScreenStatelessMixin on StatelessWidget {
  void showLoading(BuildContext context) {
    LoadingOverlay().showLoadingPage(context);
  }

  void hideLoading() {
    LoadingOverlay().hideLoadingPage();
  }

  void showNotFoundErrorMessage(BuildContext context) {
    showToast(context, "id not found");
  }

  void showToast(
    BuildContext context,
    String message, {
    Widget? icon,
    bool isCenterMessage = true,
  }) {
    try {
      final FToast fToast = FToast();

      fToast.init(context);
      fToast.removeQueuedCustomToasts();
      fToast.showToast(
          child: ToastInfoView(
            message,
            icon: icon,
            isCenterMessage: isCenterMessage,
          ),
          toastDuration: const Duration(seconds: 4),
          positionedToastBuilder: (context, child) {
            return Positioned(
              bottom: 24,
              left: 32,
              right: 32,
              child: child,
            );
          });
    } catch (e) {
      PLog.error("Error while showing toast $e");
    }
  }

  void showCustomToast(BuildContext context,
      {required child, Duration? toastDuration}) {
    try {
      final FToast fToast = FToast();
      fToast.init(context);
      fToast.removeQueuedCustomToasts();
      fToast.showToast(
          child: child,
          toastDuration: toastDuration ?? const Duration(milliseconds: 1500),
          positionedToastBuilder: (context, child) {
            return Positioned.fill(
              child: Center(child: child),
            );
          });
    } catch (e) {
      PLog.error("Error while showing toast $e");
    }
  }
}
