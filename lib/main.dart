import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kasirku_flutter/app/presentation/login/login_screen.dart';
import 'package:kasirku_flutter/core/di/dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  initDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasirku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
