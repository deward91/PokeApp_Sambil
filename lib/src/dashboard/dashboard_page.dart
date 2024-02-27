// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapp_sambil/src/dashboard/dashboard_controller.dart';
import 'package:pokeapp_sambil/src/utils/my_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}
//cargamos controladores
class _DashboardPageState extends State<DashboardPage> {
  final DashboardController _con = DashboardController();
  final List<Map<String, dynamic>> _pokemons = [];
  final List<Map<String, dynamic>> _filteredPokemons = [];
  bool _loadingMore = false;
  bool _allPokemonsLoaded = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
//iniciamos controlador y carga de lista
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context);
      _loadPokemons();
    });
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
//obtenemos desde la api pokemon
  Future<void> _loadPokemons() async {
    if (!_loadingMore && !_allPokemonsLoaded) {
      setState(() {
        _loadingMore = true;
      });

      final url =
          'https://pokeapi.co/api/v2/pokemon?limit=10&offset=${_pokemons.length}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;

        if (results.isEmpty || _pokemons.length + results.length >= 1000) {
          _allPokemonsLoaded = true;
        }

        for (final result in results) {
          final pokemonUrl = result['url'] as String;
          final pokemonResponse = await http.get(Uri.parse(pokemonUrl));

          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            _pokemons.add({
              'name': pokemonData['name'],
              'image': pokemonData['sprites']['front_default'],
              'weight': pokemonData['weight'],
              'attacks': [
                pokemonData['moves'][0]['move']['name'],
                pokemonData['moves'][1]['move']['name'],
              ],
            });
          } else {
            if (kDebugMode) {
              print('Error al cargar Pokémon: ${pokemonResponse.statusCode}');
            }
          }
        }

        setState(() {
          _loadingMore = false;
          _filteredPokemons.addAll(_pokemons);
        });
      } else {
        if (kDebugMode) {
          print('Error al cargar lista de Pokémones: ${response.statusCode}');
        }
      }
    }
  }
//metodo para busqueda
  void _onSearchTextChanged() {
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredPokemons.clear();
      _filteredPokemons.addAll(_pokemons.where((pokemon) =>
          pokemon['name'].toString().toLowerCase().contains(searchText)));
    });
  }
//constructor visual
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeApp Sambil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(_pokemons),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemCount: _filteredPokemons.length + 1,
        itemBuilder: (context, index) {
          if (_filteredPokemons.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (index < _filteredPokemons.length) {
            final pokemon = _filteredPokemons[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(pokemon['image']),
                        Text('Nombre del Pokemon: ${pokemon['name']}'),
                        Text('Peso: ${pokemon['weight']}'),
                        Text('Ataque especial: ${pokemon['attacks'][0]}'),
                      ],
                    ),
                  ),
                );
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              pokemon['image'],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.transparent
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        'Peso: ${pokemon['weight']}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 3),
                      child: Text(
                        pokemon['name'],
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        'Ataque: ${pokemon['attacks'][0]}',
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (_loadingMore) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (_allPokemonsLoaded) {
            return const Center(
              child: Text('Todos los Pokémones han sido cargados.'),
            );
          } else {
            Future.delayed(Duration.zero, () => _loadPokemons());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        padding: const EdgeInsets.all(4.0),
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {},
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.home),
              onPressed: () async {},
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text(
                        '¿Está seguro que desea cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamedAndRemoveUntil( //cerramos sesion y vamos a login
                            context,
                            'login',
                            (route) => false,
                          );
                        },
                        child: const Text('Sí'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
//scroll infinito y lazy loader
  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (!_loadingMore && !_allPokemonsLoaded && currentScroll >= maxScroll) {
      _loadPokemons();
    }
  }
}
//clase para busqueda
class PokemonSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> pokemons;

  PokemonSearchDelegate(this.pokemons);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredPokemons = pokemons
        .where((pokemon) =>
            pokemon['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      itemCount: filteredPokemons.length,
      itemBuilder: (context, index) {
        final pokemon = filteredPokemons[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    pokemon['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 3),
                child: Text(
                  pokemon['name'],
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Ataque: ${pokemon['attacks'][0]}',
                  style: const TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = pokemons
        .where((pokemon) =>
            pokemon['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final pokemon = suggestions[index];
        return ListTile(
          title: Text(pokemon['name'].toString()),
          onTap: () {
            query = pokemon['name'].toString();
            showResults(context);
          },
        );
      },
    );
  }
}

