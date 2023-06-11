import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  ProfileSettingsState createState() => ProfileSettingsState();
}



class ProfileSettingsState extends State<ProfileSettings> {
  final nameController = TextEditingController();

  @override
  initState() {
    super.initState();
    nameController.text = '0';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Weight:"),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Weight',
                        ),
                      ),
                    ])
              ])),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final localContext = context;
          Navigator.pop(localContext, {
            'weight': nameController.text,
          });
        },
        backgroundColor: Colors.red[800],
        tooltip: 'Increment',
        child: const Icon(Icons.save),
      ),
    );
  }
}
