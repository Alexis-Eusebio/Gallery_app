import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_app/services/service_pokemon.dart';
import 'models/pokemon.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  void _changeTheme(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      themeMode: _themeMode,
      home: PokemonScreen(changeTheme: _changeTheme),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  final void Function(ThemeMode) changeTheme;
  const PokemonScreen({super.key, required this.changeTheme});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final ServicePokemon _servicePokemon = ServicePokemon();
  final TextEditingController _controller = TextEditingController();
  Future<Pokemon>? _futurePokemon;
  int _currentImageIndex = 0;

  void _buscar() {
    setState(() {
      _currentImageIndex = 0;
      _futurePokemon = _servicePokemon.fetchPokemon(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokedex")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Nombre del pokémon",
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _buscar),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Pokemon>(
                future: _futurePokemon,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return const Center(child: Text("No encontrado"));
                  if (!snapshot.hasData) return const Center(child: Text("Busca un Pokémon"));

                  final pokemon = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // 1. EL NOMBRE
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        // 2. LA IMAGEN (Original SVG)
                        SvgPicture.network(pokemon.imageURL, height: 200),
                        const SizedBox(height: 30),

                        // 3. ABILIDADES (Con estrella rellena)
                        const Text("Abilidades", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...pokemon.abilities.map((ability) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber), // Estrella rellena
                            const SizedBox(width: 8),
                            Text(ability, style: const TextStyle(fontSize: 16)),
                          ],
                        )),
                        const SizedBox(height: 40),

                        // 4. GALERÍA DE IMÁGENES (Abajo de todo)
                        const Text("Galería", style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Botón estrictamente "<<"
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _currentImageIndex = (_currentImageIndex > 0) ? _currentImageIndex - 1 : pokemon.gallery.length - 1;
                                });
                              },
                              child: const Text("<<", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            // Imagen de galería
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              height: 120,
                              width: 120,
                              child: Image.network(pokemon.gallery[_currentImageIndex]),
                            ),
                            // Botón estrictamente ">>"
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _currentImageIndex = (_currentImageIndex < pokemon.gallery.length - 1) ? _currentImageIndex + 1 : 0;
                                });
                              },
                              child: const Text(">>", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: () => widget.changeTheme(ThemeMode.light), child: const Icon(Icons.light_mode)),
          const SizedBox(height: 10),
          FloatingActionButton(onPressed: () => widget.changeTheme(ThemeMode.dark), child: const Icon(Icons.dark_mode)),
        ],
      ),
    );
  }
}