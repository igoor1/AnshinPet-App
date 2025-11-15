import 'package:anshinpet/viewmodels/animal_view_model.dart';
import 'package:anshinpet/viewmodels/auth_view_model.dart';
import 'package:anshinpet/viewmodels/disease_view_model.dart';
import 'package:anshinpet/viewmodels/donation_view_model.dart';
import 'package:anshinpet/viewmodels/home_view_model.dart';
import 'package:anshinpet/viewmodels/token_view_model.dart';
import 'package:anshinpet/viewmodels/vaccine_view_model.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        ChangeNotifierProvider<TokenViewModel>(create: (_) => TokenViewModel()),
        ChangeNotifierProvider<HomeViewModel>(create: (_) => HomeViewModel()),
        ChangeNotifierProvider<DonationViewModel>(create: (_) => DonationViewModel()),
        ChangeNotifierProvider<DiseaseViewModel>(create: (_) => DiseaseViewModel()),
        ChangeNotifierProvider<VaccineViewModel>(create: (_) => VaccineViewModel()),
        ChangeNotifierProvider<AnimalViewModel>(create: (_) => AnimalViewModel()),
      ];
}
