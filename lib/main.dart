import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiratoxz_flutter/data/repository/api_repository.dart';
import 'package:kiratoxz_flutter/data/storage_manager.dart';
import 'package:kiratoxz_flutter/game/services/service.dart';
import 'package:kiratoxz_flutter/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  final apiRepository = ApiRepository();
  await apiRepository.initialize();
  final appRouter = AppRouter();
  await StorageManager().initPrefs();
  final StorageService storageService = getIt<StorageService>();
  await storageService.init();
  runApp(MyApp(
    apiRepository: apiRepository,
    appRouter: appRouter,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.apiRepository,
    required this.appRouter,
  });
  static final GlobalKey<NavigatorState> naviagtorKey =
      GlobalKey<NavigatorState>();
  final AppRouter appRouter;
  final ApiRepository apiRepository;

  Widget _buildAppRouter(BuildContext context) {
    return MaterialApp.router(
      title: 'Số Đỏ - Trò Chơi Trí Tuệ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: appRouter.config(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /// Repository -> Bloc -> Mobx Store -> ...
      providers: [
        // Provider(
        //   create: (context) => Repository(),
        // ),
        Provider.value(value: apiRepository),
      ],
      child: Builder(
        builder: (context) {
          return _buildAppRouter(context);
        },
      ),
    );
  }
}
