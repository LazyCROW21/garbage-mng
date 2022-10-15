import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<Map<String, String>> bruh = [
    {
      'Name': "Haddi Nubda",
      'PhoneNumber': "988754445631",
      'Date': '12/12/2000'
    },
    {
      'Name': "Haddi Nubda",
      'PhoneNumber': "988754445631",
      'Date': '12/12/2000'
    },
    {
      'Name': "Haddi Nubda",
      'PhoneNumber': "988754445631",
      'Date': '12/12/2000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bruh.length,
      itemBuilder: (BuildContext context, int index) {
        return userProfileCard(bruh[index]);
      },
    );
  }

  Widget userProfileCard(Map<String, String> data) {
    return Card(
      child: SizedBox(
        height: 128,
        child: Stack(children: [
          Row(children: [
            Expanded(
                flex: 1,
                child: Image.network(
                    'https://img.icons8.com/color/96/000000/test-account.png')),
            Expanded(
              flex: 5,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['Name'] ?? 'Not Found',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Phone Number: ${data["PhoneNumber"]}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            )),
            Container(
              padding: EdgeInsets.all(10),
              child: IconButton(
                color: Colors.red,
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
