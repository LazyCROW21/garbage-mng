import 'package:flutter/material.dart';
import 'package:garbage_mng/models/organisation.dart';

class OrganisationCard extends StatefulWidget {
  const OrganisationCard({Key? key, required Map<String, String> this.data})
      : super(key: key);

  final Map<String, String> data;

  @override
  State<OrganisationCard> createState() => _OrganisationCardState();
}

class _OrganisationCardState extends State<OrganisationCard> {
  @override
  Widget build(BuildContext context) {
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
                      widget.data['Name'] ?? 'Not Found',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Phone Number: ${widget.data["PhoneNumber"]}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: IconButton(
                color: Colors.green,
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed('/editOrganisation',
                      arguments:
                          Organisation(name: 'hedrick', number: '74878135135'));
                },
              ),
            )
          ]),
        ]),
      ),
    );
    ;
  }
}
