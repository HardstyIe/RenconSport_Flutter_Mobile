import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SportDetails {
  final String name, details;
  final List<String> workout;

  SportDetails({required this.name, required this.details, required this.workout});
}

class Sport {
  final String name;
  final List<String> parameters, workout;
  final String details;

  Sport({required this.name, required this.parameters, required this.details, required this.workout});
}

class Filter {
  final Sport sport;
  String location = '';
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int numberOfPlayers = 0;
  int timeOut = 0;

  Filter({required this.sport});
}

class TrainingService {
  static final allTraining = "trainings";
  static final Dio _dio = Dio();

  static Future<List<dynamic>> getAllTraining() async {
    try {
      final response = await _dio.get(allTraining);

      if (response.statusCode == 200) {
        return (response.data as List).map((data) => data).toList();
      } else {
        throw Exception('Failed to fetch trainings');
      }
    } catch (error) {
      throw Exception('Failed to fetch trainings: $error');
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
      home: const FilterApp(),
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
      parameters: ['Location', 'Date', 'Heure de début', 'Heure de fin', 'Nombre de Joueurs', 'Time Out'],
      details: 'Fitness details...',
      workout: ['Exercise 1', 'Exercise 2', 'Exercise 3'],
    ),
    Sport(
      name: 'Musculation',
      parameters: ['Location', 'Date', 'Heure de début', 'Heure de fin', 'Nombre de Joueurs', 'Time Out'],
      details: 'Musculation details...',
      workout: ['Exercise 1', 'Exercise 2', 'Exercise 3'],
    ),
    // Ajoutez d'autres sports ici
  ];

  List<Filter> filters = [];
  TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];

  void addFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Sport selectedSport = sports[0];
        String location = '';
        DateTime date = DateTime.now();
        TimeOfDay startTime = TimeOfDay.now();
        TimeOfDay endTime = TimeOfDay.now();
        int numberOfPlayers = 0;
        int timeOut = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Créer un Filtre'),
              contentPadding: EdgeInsets.all(16),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    // Date picker
                    Row(
                      children: [
                        Expanded(
                          child: Text('Date: ${date.toLocal()}',
                              style: TextStyle(fontSize: 18)),
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
                            if (selectedDate != null &&
                                selectedDate != date) {
                              setState(() {
                                date = selectedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    // Start time picker
                    Row(
                      children: [
                        Expanded(
                          child: Text('Heure de début: ${startTime.format(context)}',
                              style: TextStyle(fontSize: 18)),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: startTime,
                            );
                            if (selectedTime != null &&
                                selectedTime != startTime) {
                              setState(() {
                                startTime = selectedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    // End time picker
                    Row(
                      children: [
                        Expanded(
                          child: Text('Heure de fin: ${endTime.format(context)}',
                              style: TextStyle(fontSize: 18)),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: endTime,
                            );
                            if (selectedTime != null &&
                                selectedTime != endTime) {
                              setState(() {
                                endTime = selectedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nombre de Joueurs'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        numberOfPlayers = int.tryParse(value) ?? 0;
                      },
                      style: TextStyle(fontSize: 18),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Time Out'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        timeOut = int.tryParse(value) ?? 0;
                      },
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validation and filter creation logic
                      },
                      child: Text('Créer', style: TextStyle(fontSize: 18)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Annuler', style: TextStyle(fontSize: 18)),
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
              // ... Rest of the ListTile content
            },
          ),
        ),
      ],
    );
  }
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
                    widget.searchResults.clear();
                    // ... Update searchResults logic
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
}
