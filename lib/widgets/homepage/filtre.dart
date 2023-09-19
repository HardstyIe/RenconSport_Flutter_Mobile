import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Classe pour représenter les détails du sport
class SportDetails {
  final String name;
  final String details;
  final List<String> workout;

  SportDetails({
    required this.name,
    required this.details,
    required this.workout,
  });
}

class Sport {
  final String name;
  final List<String> parameters;
  final String details;
  final List<String> workout;

  Sport({
    required this.name,
    required this.parameters,
    required this.details,
    required this.workout,
  });
}

class Filter {
  final Sport sport;
  String location = '';
  int numberOfPlayers = 0;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  int timeOut = 0;

  Filter({required this.sport});
}

class TrainingService {
  static final allTraining = "trainings";
  static final training = "trainings/:id";
  static final sendTraining = "trainings/:id";
  static final putTraining = "trainings/:id";
  static final delTraining = "trainings/:id";

  static final Dio _dio = Dio();
  
  static get url => null;

  static Future<List<dynamic>> getAllTraining() async {
    try {
      final response = await _dio.get(url + allTraining);

      if (response.statusCode == 200) {
        final List<dynamic> trainingDataList = response.data as List<dynamic>;
        final List<dynamic> trainings = trainingDataList.map((data) {
          return data;
        }).toList();
        return trainings;
      } else {
        throw Exception('Failed to fetch trainings');
      }
    } catch (error) {
      throw Exception('Failed to fetch trainings: $error');
    }
  }

  static Future<dynamic> getTraining(String id) async {
    try {
      final response = await _dio.get(url + training.replaceAll(':id', id));

      if (response.statusCode == 200) {
        final trainingDataJson = response.data as Map<String, dynamic>;
        final training = trainingDataJson;
        return training;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilterApp(),
    );
  }
}

class FilterApp extends StatefulWidget {
  const FilterApp({Key? key}) : super(key: key);

  @override
  _FilterAppState createState() => _FilterAppState();
}

class _FilterAppState extends State<FilterApp> {
  final List<Sport> sports = [
    Sport(
      name: 'Fitness',
      parameters: ['Location', 'Nombre de Joueurs', 'Date', 'Heure', 'Time Out'],
      details: 'Fitness details...',
      workout: ['Exercise 1', 'Exercise 2', 'Exercise 3'],
    ),
    Sport(
      name: 'Basketball',
      parameters: ['Location', 'Nombre de Joueurs', 'Date', 'Heure', 'Time Out'],
      details: 'Basketball details...',
      workout: ['Dribbling', 'Shooting', 'Passing'],
    ),
    Sport(
      name: 'Football',
      parameters: ['Location', 'Nombre de Joueurs', 'Date', 'Heure', 'Time Out'],
      details: 'Football details...',
      workout: ['Dribbling', 'Shooting', 'Passing'],
    ),
    Sport(
      name: 'Musculation',
      parameters: ['Location', 'Nombre de Joueurs', 'Date', 'Heure', 'Time Out'],
      details: 'Musculation details...',
      workout: ['Exercise 1', 'Exercise 2', 'Exercise 3'],
    ),
    // Ajoutez d'autres sports ici
  ];

  List<Filter> filters = []; // Liste des filtres
  TextEditingController searchController = TextEditingController(); // Contrôleur de champ de recherche
  List<String> searchResults = []; // Liste des résultats de recherche

  Future<SportDetails?> fetchSportDetails(String sportName) async {
    try {
      // Utilisez le service TrainingService pour récupérer les détails du sport.
      final sportData = await TrainingService.getTraining(sportName);

      if (sportData != null) {
        // Créez une instance de SportDetails à partir des données récupérées.
        final sportDetails = SportDetails(
          name: sportData['name'],
          details: sportData['details'],
          workout: List<String>.from(sportData['workout']),
        );
        return sportDetails;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  void addFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Sport selectedSport = sports[0]; // Sélectionnez le premier sport par défaut.
        String location = ''; // Champ de saisie pour la localisation
        int numberOfPlayers = 0; // Champ de nombre de joueurs
        DateTime date = DateTime.now(); // Sélection de la date
        TimeOfDay time = TimeOfDay.now(); // Sélection de l'heure
        int timeOut = 0; // Champ de saisie pour le Time Out

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Créer un Filtre'),
              contentPadding: EdgeInsets.all(16),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Code de création de filtre
                    DropdownButtonFormField<Sport>(
                      value: selectedSport,
                      items: sports.map((sport) {
                        return DropdownMenuItem<Sport>(
                          value: sport,
                          child: Text(sport.name, style: TextStyle(fontSize: 18)),
                        );
                      }).toList(),
                      onChanged: (sport) {
                        setState(() {
                          selectedSport = sport!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Localisation'),
                      onChanged: (value) {
                        location = value;
                      },
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nombre de Joueurs'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        numberOfPlayers = int.tryParse(value) ?? 0;
                      },
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Date: ${date.toLocal()}', style: TextStyle(fontSize: 18)),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null && selectedDate != date) {
                              setState(() {
                                date = selectedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Heure: ${time.format(context)}', style: TextStyle(fontSize: 18)),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (selectedTime != null && selectedTime != time) {
                              setState(() {
                                time = selectedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Time Out'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        timeOut = int.tryParse(value) ?? 0;
                      },
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (selectedSport != null &&
                                location.isNotEmpty &&
                                numberOfPlayers > 0 &&
                                timeOut > 0) {
                              Filter newFilter = Filter(sport: selectedSport)
                                ..location = location
                                ..numberOfPlayers = numberOfPlayers
                                ..date = date
                                ..time = time
                                ..timeOut = timeOut;

                              filters.add(newFilter);

                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content: Text('Veuillez remplir tous les champs requis.', style: TextStyle(fontSize: 18)),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text('Créer', style: TextStyle(fontSize: 18)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey;
                                }
                                return Color.fromARGB(255, 255, 255, 255);
                              },
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Filters'),
        actions: [
          IconButton(
            onPressed: () {
              // Ouvrir la vue de recherche
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return SearchBarApp(
                    sports: sports,
                    searchResults: searchResults,
                  );
                },
              ));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: FilterList(filters: filters),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lorsque le bouton "+" est cliqué, appelez la fonction pour ajouter un filtre.
          addFilter(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FilterList extends StatelessWidget {
  final List<Filter> filters;

  FilterList({required this.filters});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final startDate = DateTime(filter.date.year, filter.date.month, filter.date.day, filter.time.hour, filter.time.minute);
              final endDate = startDate.add(Duration(minutes: filter.timeOut));

              return ListTile(
                title: Text('Filter ${index + 1}', style: TextStyle(fontSize: 18)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sport: ${filter.sport.name}', style: TextStyle(fontSize: 18)),
                    Text('Heure de début: ${startDate.toString()}', style: TextStyle(fontSize: 18)),
                    Text('Heure de fin: ${endDate.toString()}', style: TextStyle(fontSize: 18)),
                    ElevatedButton(
                      onPressed: () async {
                        // Récupérez les détails du sport.
                        final sportDetails = await fetchSportDetails(filter.sport.name);

                        if (sportDetails != null) {
                          // Ouvrez la page des détails du sport avec les informations récupérées.
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return SportDetailsPage(sportDetails: sportDetails);
                            },
                          ));
                        } else {
                          // Gérez le cas où les détails du sport ne peuvent pas être récupérés.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Erreur'),
                                content: Text('Impossible de récupérer les détails du sport.', style: TextStyle(fontSize: 18)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Détails du Sport', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  fetchSportDetails(String name) {}
}

class SportDetailsPage extends StatelessWidget {
  final SportDetails sportDetails;

  SportDetailsPage({required this.sportDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sportDetails.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Détails du Sport:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(sportDetails.details, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Séries à faire:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sportDetails.workout.map((exercise) {
                return Text(exercise, style: TextStyle(fontSize: 18));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarApp extends StatefulWidget {
  final List<Sport> sports;
  final List<String> searchResults;

  SearchBarApp({required this.sports, required this.searchResults, Key? key}) : super(key: key);

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Renconsport')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (query) {
                  setState(() {
                    widget.searchResults.clear(); // Effacez la liste des résultats de recherche actuelle.
                    updateSearchResults(query); // Mettez à jour la liste des résultats de recherche.
                    controller.openView();
                  });
                },
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  Tooltip(
                    message: 'Change brightness mode',
                    child: IconButton(
                      isSelected: isDark,
                      onPressed: () {
                        setState(() {
                          isDark = !isDark;
                        });
                      },
                      icon: const Icon(Icons.wb_sunny_outlined),
                      selectedIcon: const Icon(Icons.brightness_2_outlined),
                    ),
                  )
                ],
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return widget.searchResults.map((sport) {
                return ListTile(
                  title: Text(sport),
                  onTap: () {
                    setState(() {
                      controller.closeView(sport);
                    });
                  },
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  void updateSearchResults(String query) {
    widget.searchResults.clear();
    for (var sport in widget.sports) {
      if (sport.name.toLowerCase().contains(query.toLowerCase())) {
        widget.searchResults.add(sport.name);
      }
    }
  }
}
