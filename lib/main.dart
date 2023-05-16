import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyHomePage(),
    routes: {
      '/new-contact': (context) => const AddNewContact(),
    },
  ));
}

class Contact {
  final String id;
  final String name;

  Contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  static final ContactBook _shared = ContactBook._sharedInstance();
  ContactBook._sharedInstance() : super([]);
  factory ContactBook() => _shared;

  Contact? contactAt({required int atIndex}) {
    if (value.length > atIndex) {
      return value[atIndex];
    }
    return null;
  }

  void add({required String name}) {
    final contact = Contact(name: name);
    value.add(contact);
    notifyListeners();
    //we dont need notifylisteners but here we do because
    //our array.add will add new value
    //but it will not change value so the inherent notifyListener doesn't get called
  }

  void remove({required int atIndex}) {
    final contact = contactAt(atIndex: atIndex);
    if (contact != null) {
      value.remove(contact);
      notifyListeners();
    }
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contacts'),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (BuildContext context, value, Widget? child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final contact = value[index];
              return Material(
                elevation: 6.0,
                child: Dismissible(
                  onDismissed: (direction) {
                    value.remove(contact);
                  },
                  key: ValueKey(contact.id),
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-contact');
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
              ContactBook().add(name: name);
              Navigator.of(context).pop();
            },
            child: const Text('Add new contact')),
      ]),
    );
  }
}
