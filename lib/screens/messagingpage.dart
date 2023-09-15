import 'package:flutter/material.dart';
import 'package:renconsport/models/message.dart';
import 'package:renconsport/services/Authentification/messageService.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            color: Color(0xFFEEECDE),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('Renconsport'),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                )
              ],
            ),
          ),
          Container(
            height: 50,
            color: Color(0xFFEEECDE),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt_outlined),
                ),
                TextButton(
                  child: const Text('Discutions'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
                TextButton(
                  child: const Text('Statut'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
                TextButton(
                  child: const Text('Activités'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: MessageService.fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Une erreur s\'est produite : ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Aucun message à afficher.'),
                  );
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text(message.senderId),
                        // Autres informations sur le message et mise en forme.
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
