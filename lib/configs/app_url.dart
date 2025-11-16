class AppUrl {
  static var baseUrl = 'https://anshinpet-api-102cd23baaed.herokuapp.com';

  static var loginUrl = '$baseUrl/api/auth/signin';

  static var diseaseUrl = '$baseUrl/api/diseases';

  static String deleteDisease(int id) => '$baseUrl/api/diseases/$id';

  static var vaccineUrl = '$baseUrl/api/vaccines';

  static String deleteVaccine(int id) => '$baseUrl/api/vaccines/$id';

  static var fetchAnimals = '$baseUrl/api/animals';

  static var createAnimal = '$baseUrl/api/animals';

  static String updateAnimal(int id) => '$baseUrl/api/animals/$id';

  static String deleteAnimal(int id) => '$baseUrl/api/animals/$id';
  
  static String uploadAnimalImage(int animalId) => '$baseUrl/api/animals/$animalId/image';

  static String animalImageUrl(int animalId) => "$baseUrl/api/animals/$animalId/image";

  static var fetchAnimalStatus = "$baseUrl/api/status";

  static var fetchAnimalTypes = "$baseUrl/api/types";
}
