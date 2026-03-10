class Pokemon {
  final String name;
  final List<String> abilities;
  final String imageURL;
  final List<String> gallery; // Lista para las fotos extras

  Pokemon({
    required this.name,
    required this.abilities,
    required this.imageURL,
    required this.gallery,
  });

  factory Pokemon.fromJSON(Map<String, dynamic> json) {
    final abilitiesList = (json['abilities'] as List)
        .map((item) => item['ability']['name'] as String)
        .toList();

    // Recopilamos las imágenes para la galería
    List<String> galleryList = [];
    final sprites = json['sprites'];
    if (sprites['front_default'] != null) galleryList.add(sprites['front_default']);
    if (sprites['back_default'] != null) galleryList.add(sprites['back_default']);
    if (sprites['front_shiny'] != null) galleryList.add(sprites['front_shiny']);
    if (sprites['back_shiny'] != null) galleryList.add(sprites['back_shiny']);

    return Pokemon(
      name: json['name'],
      abilities: abilitiesList,
      imageURL: json['sprites']['other']['dream_world']['front_default'] ?? '',
      gallery: galleryList,
    );
  }
}