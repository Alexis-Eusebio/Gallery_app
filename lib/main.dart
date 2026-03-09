import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_app/services/service_pokemon.dart';

import 'models/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _changeTheme(ThemeMode thememode) {
    setState(() {
      _themeMode = thememode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // cambiar la etiqueta de debug
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 181, 63),
          brightness: Brightness.dark,
        ),
      ),
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
  final TextEditingController _controller = TextEditingController();
  final ServicePokemon _servicePokemon = ServicePokemon();

  Future<Pokemon>? _futurePokemom;

  void _buscarPokemon() {
    setState(() {
      _futurePokemom = _servicePokemon.fetchPokemon(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria de Pokemones")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nombre del pokemon",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarPokemon,
              child: Text("Buscar el pokemon"),
            ),
            SizedBox(height: 20),
            Text("Datos del pokemón", style: TextStyle(fontSize: 25)),
            SizedBox(height: 20),
            _futurePokemom == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Ingresar un nombre"),
                  )
                : Column(
                    children: [
                      FutureBuilder(
                        future: _futurePokemom,
                        builder: (context, datos) {
                          if (datos.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (datos.hasError) {
                            return Center(
                              child: Text(
                                "Pokemón no existe o un error en la API",
                              ),
                            );
                          }

                          // datos para desplegar lo faltante
                          final pokemon = datos.data!;

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(pokemon.name.toLowerCase()),
                                SizedBox(height: 20),
                                //Image.network(pokemon.imageURL),
                                SvgPicture.network(pokemon.imageURL),
                              ],
                            ),
                          );

                          //return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => widget.changeTheme(ThemeMode.light),
            tooltip: 'Modo claro',
            child: Icon(Icons.light_mode),
          ),
          FloatingActionButton(
            onPressed: () => widget.changeTheme(ThemeMode.dark),
            tooltip: 'Modo oscuro',
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
    );
  }
}
