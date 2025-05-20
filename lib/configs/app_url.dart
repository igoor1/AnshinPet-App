class AppUrl {

  static var baseUrl = 'https://anshinpet-api-bc75c527a28e.herokuapp.com';

  static var loginUrl = '$baseUrl/api/auth/login';

  static var quantityAnimals = '$baseUrl/api/animais/quantidade';

  static var quantityDogs = '$baseUrl/api/animais/quantidade/C';

  static var quantityCats = '$baseUrl/api/animais/quantidade/G';

  static var quantityBirds = '$baseUrl/api/animais/quantidade/A';

  static var quantityAdoption = '$baseUrl/api/animais/quantidade/A';

  static var quantityUsers = '$baseUrl/api/usuarios/quantidade';

  static var quantityDonations = '$baseUrl/api/doacoes/quantidade/racao';
  
  static var quantityMoney = '$baseUrl/api/doacoes/quantidade/dinheiro';

  static String fetchDonate(String type) => '$baseUrl/api/doacoes/listar/$type';

static String deleteDonation(int id) => '$baseUrl/api/doacoes/$id';
}