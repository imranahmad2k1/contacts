import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: MyHomePage(),
    routes: {
      '/new-contact': (context) => const AddNewContact(),
    },
  ));
}

class Contact {
  final String name;

  const Contact({required this.name});
}

class ContactBook {
  static final ContactBook _shared = ContactBook._sharedInstance();
  ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  List<Contact> get contacts => [];

  Contact? contactAt({required int atIndex}) {
    if (contacts.length > atIndex) {
      return contacts[atIndex];
    }
    return null;
  }

  void add({required String name}) {
    final contact = Contact(name: name);
    contacts.add(contact);
  }

  void remove({required int atIndex}) {
    final contact = contactAt(atIndex: atIndex);
    if (contact != null) {
      contacts.remove(contact);
    }
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final ContactBook cb = ContactBook();
  final contacts = ContactBook().contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cb.contactAt(atIndex: index)!.name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/new-contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  late final TextEditingController _controller;
  final ContactBook cb = ContactBook();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new Contact')),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration:
              const InputDecoration(hintText: 'Enter name for new contact'),
        ),
        TextButton(
            onPressed: () {
              final name = _controller.text;
              cb.add(name: name);
              Navigator.of(context).pop();
            },
            child: const Text('Add new contact')),
      ]),
    );
  }
}
