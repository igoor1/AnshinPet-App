import 'package:anshinpet/viewmodels/animal_status_view_model.dart';
import 'package:anshinpet/viewmodels/animal_type_view_model.dart';
import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/auth_view_model.dart';
import 'package:anshinpet/viewmodels/disease_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:anshinpet/viewmodels/vaccine_view_model.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        ChangeNotifierProvider<TokenViewModel>(create: (_) => TokenViewModel()),
        ChangeNotifierProvider<DiseaseViewModel>(create: (_) => DiseaseViewModel()),
        ChangeNotifierProvider<VaccineViewModel>(create: (_) => VaccineViewModel()),
        ChangeNotifierProvider<AnimalViewModel>(create: (_) => AnimalViewModel()),
        ChangeNotifierProvider<AnimalTypeViewModel>(create: (_) => AnimalTypeViewModel()),
        ChangeNotifierProvider<AnimalStatusViewModel>(create: (_) => AnimalStatusViewModel()),
      ];
}
