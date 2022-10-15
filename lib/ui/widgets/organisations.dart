import 'package:flutter/material.dart';

import 'organisation_card.dart';

class Organisations extends StatefulWidget {
  const Organisations({Key? key}) : super(key: key);

  @override
  State<Organisations> createState() => _OrganisationsState();
}

class _OrganisationsState extends State<Organisations> {
  List<Map<String, String>> orgs = [
    {
      'Name': "Haddi Nubda",
      'PhoneNumber': "988754445631",

    },
    {
      'Name': "Haddi Nubda",
      'PhoneNumber': "988754445631",

    },
    {
      'Name': "Haddi Nubda",
      'PhoneNumber': "988754445631",

    },
  ];
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: orgs.length,
      itemBuilder: (BuildContext context, int index) {
        return OrganisationCard(data : orgs[index]);
      },
    );;
  }
}


