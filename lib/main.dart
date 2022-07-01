import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_flutter/bindings/bindings.dart';
import 'package:todo_flutter/db/db_helper.dart';
import 'package:todo_flutter/services/theme_services.dart';
import 'package:todo_flutter/ui/theme.dart';

import 'ui/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeServices _ts = ThemeServices();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: TodoBindings(),
      title: 'TODO',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: _ts.theme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
