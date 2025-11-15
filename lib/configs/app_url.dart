class AppUrl {
  static var baseUrl = 'https://anshinpet-api-102cd23baaed.herokuapp.com';

  static var loginUrl = '$baseUrl/api/auth/signin';

  static var quantityAnimals = '$baseUrl/api/animais/quantidade';

  static var quantityDogs = '$baseUrl/api/animais/quantidade/C';

  static var quantityCats = '$baseUrl/api/animais/quantidade/G';

  static var quantityBirds = '$baseUrl/api/animais/quantidade/A';

  static var quantityAdoption = '$baseUrl/api/animais/quantidade/A';

  static var quantityUsers = '$baseUrl/api/usuarios/quantidade';

  static var quantityDonations = '$baseUrl/api/doacoes/quantidade/racao';

  static var quantityMoney = '$baseUrl/api/doacoes/quantidade/dinheiro';

  static String fetchDonate(String type) => '$baseUrl/api/doacoes/listar/$type';

  static var createDonation = '$baseUrl/api/doacoes';

  static String deleteDonation(int id) => '$baseUrl/api/doacoes/$id';

  static String updateDonation(int id) => '$baseUrl/api/doacoes/$id';

  static var diseaseUrl = '$baseUrl/api/doencas';

  static String updateDisease(int id) => '$baseUrl/api/doencas/$id';

  static String deleteDisease(int id) => '$baseUrl/api/doencas/$id';

  static var vaccineUrl = '$baseUrl/api/vacinas';

  static String updateVaccine(int id) => '$baseUrl/api/vacinas/$id';

  static String deleteVaccine(int id) => '$baseUrl/api/vacinas/$id';

  static var fetchAnimals = '$baseUrl/api/animais';
}
