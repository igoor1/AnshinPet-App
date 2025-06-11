import 'package:anshinpet/configs/routes/routes.dart';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/configs/theme/app_theme.dart';
import 'package:anshinpet/view_model/auth_view_model.dart';
import 'package:anshinpet/view_model/disease_view_model.dart';
import 'package:anshinpet/view_model/donation_view_model.dart';
import 'package:anshinpet/view_model/home_view_model.dart';
import 'package:anshinpet/view_model/token_view_model.dart';
import 'package:anshinpet/view_model/vaccine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TokenViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => DonationViewModel()),
        ChangeNotifierProvider(create: (_) => DiseaseViewModel()),
        ChangeNotifierProvider(create: (_) => VaccineViewModel())
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}