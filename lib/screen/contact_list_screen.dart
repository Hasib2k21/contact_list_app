import 'package:flutter/material.dart';

import '../Contact/contact.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Contact List')),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        toolbarHeight: 75,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      labelText: 'Name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Number',
                      labelText: 'Number',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addContact();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: contacts.isEmpty
                ? const Center(child: Text('No contacts added yet.'))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.account_circle, size: 40),
                            title: Text(
                              contacts[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            subtitle: Text(contacts[index].number),
                            trailing: const Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            onLongPress: () =>
                                _showDeleteConfirmationDialog(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addContact() {
    if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
      setState(() {
        contacts.add(Contact(nameController.text, numberController.text));
        nameController.clear();
        numberController.clear();
      });
    }
  }

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text('Confirmation')),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.blue),
            onPressed: () {
              _deleteContact(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }
}
