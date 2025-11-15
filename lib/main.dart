import 'package:anshinpet/configs/routes/routes.dart';
import 'package:anshinpet/configs/routes/routes_name.dart';
import 'package:anshinpet/configs/theme/app_theme.dart';
import 'package:anshinpet/core/providers/app_providers.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/auth_view_model.dart';
import 'package:anshinpet/viewmodels/disease_view_model.dart';
import 'package:anshinpet/viewmodels/donation_view_model.dart';
import 'package:anshinpet/viewmodels/home_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:anshinpet/viewmodels/vaccine_view_model.dart';
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
      providers: AppProviders.providers,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
