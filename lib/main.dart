import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'provider/stock_provider.dart';
import 'routes/router.dart';
import 'services/locator_service.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StockProvider>(
          create: (context) => locator<StockProvider>(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hendshake',
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: generateRoutes,
        navigatorObservers: [locator<NavigationService>().routeObserver],
        home: HomePage(),
      ),
    );
  }
}
