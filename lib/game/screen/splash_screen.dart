// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiratoxz_flutter/game/services/service.dart';
import 'package:kiratoxz_flutter/gen/assets.gen.dart';
import 'package:kiratoxz_flutter/router/app_router.dart';
import 'package:kiratoxz_flutter/shared/shared.dart';

@RoutePage()
class SplashScreen extends BaseScreenStateful implements AutoRouteWrapper {
  static const String route = "/splash";
  SplashScreen({super.key}) {
    /// Init Some Service: such as Storage...
    debugPrint("SplashScreen");
  }

  @override
  BaseScreenState<SplashScreen> createState() => _SplashScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}

class _SplashScreenState extends BaseScreenState<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      openGameScreen();
    });
    super.initState();
  }

  static const delayTime = 1;

  openGameScreen() {
    Future.delayed(
      const Duration(seconds: delayTime),
      () async {
        final StorageService storageService = getIt<StorageService>();
        context.router.replace(GameRoute(storageService: storageService));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.background.newYear.path),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.background.meothantai.image(width: 240),
            const SizedBox(
              height: 16,
            ),
            const CircularProgressIndicator(
              color: Colors.yellow,
            ),
          ],
        )),
      ),
    );
  }
}
