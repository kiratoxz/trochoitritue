import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:kiratoxz_flutter/game/models/puzzle.dart';
import 'package:kiratoxz_flutter/game/presentation/background/utils/background_layers.dart';
import 'package:kiratoxz_flutter/game/presentation/home/home_page.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/background_layer_layout.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:kiratoxz_flutter/game/providers/phrases_provider.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:kiratoxz_flutter/game/providers/stop_watch_provider.dart';
import 'package:kiratoxz_flutter/game/services/storage/storage_service.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

@RoutePage()
class GameScreen extends StatefulWidget {
  static const route = "/game";
  final StorageService storageService;

  const GameScreen({
    Key? key,
    required this.storageService,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    if (!kIsWeb && Platform.isMacOS) {
      DesktopWindow.getWindowSize().then((size) {
        DesktopWindow.setMinWindowSize(Size(size.height * 0.5, size.height));
      }).onError((error, stackTrace) {
        DesktopWindow.setMinWindowSize(const Size(600, 1000));
      });
    }
    super.initState();
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      for (BackgroundLayerType layerType in BackgroundLayers.types) {
        precacheImage(
          Image.asset('assets/images/background/${layerType.name}.png').image,
          context,
        );
      }

      for (int size in Puzzle.supportedPuzzleSizes) {
        precacheImage(
          Image.asset('assets/images/puzzle-solved/solved-${size}x$size.png')
              .image,
          context,
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PuzzleProvider(widget.storageService)..generate(),
        ),
        ChangeNotifierProvider(
          create: (_) => StopWatchProvider(widget.storageService)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => PhrasesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Số Đỏ - Trò Chơi Trí Tuệ',
        darkTheme: ThemeData(
          fontFamily: AppTextStyles.secondaryFontFamily,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.black,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.yellow, width: 2),
              ),
              fixedSize: const Size.fromHeight(50),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              backgroundColor: Colors.yellow.withOpacity(0.2),
            ),
          ),
        ),
        themeMode: ThemeMode.dark,
        home: const HomePage(),
      ),
    );
  }
}
