// lib/models/pokemon.dart
class Pokemon {
  final String name;
  final List<String> abilities;
  //final List<String> sprites;
  final String imageURL;

  Pokemon({
    required this.name,
    required this.abilities,
    required this.imageURL,
    //required this.sprites,
  });

  factory Pokemon.fromJSON(Map<String, dynamic> json) {
    final abilitiesList = (json['abilities'] as List)
        .map((item) => item['ability']['name'] as String)
        .toList();
    // final spritesList = (json['sprites'] as List)
    //     .map((item) => item['ability']['name'] as String)
    //     .toList();

    final image = json['sprites']['other']['dream_world']['front_default'];

    return Pokemon(
      name: json['name'],
      abilities: abilitiesList,
      //sprites: spritesList,
      imageURL: image,
    );
  }
}


/*
{
  'name': "pikachu"
  'abilities': [
    {
      'ability' : {
          'name': 'fire'
        }
    }

  ],

  'sprites': {
    'other': 
      'dreamWorld': {'front_default': url}

  }

}

* */