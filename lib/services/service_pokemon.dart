import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ServicePokemon {
  Future<Pokemon> fetchPokemon(String name) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}',
    );

    // Solo debe haber un "final resp"
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      // Aquí imprimimos el JSON para que lo veas en la Debug Console de VS Code
      print("JSON RECIBIDO: ${resp.body}"); 
      
      final data = json.decode(resp.body);
      return Pokemon.fromJSON(data);
    } else {
      throw Exception("No se encontró");
    }
  }
}