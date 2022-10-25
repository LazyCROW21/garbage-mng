import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/user_model.dart';
import 'cards/organisation_card.dart';

class Organisations extends StatefulWidget {
  const Organisations({Key? key}) : super(key: key);

  @override
  State<Organisations> createState() => _OrganisationsState();
}

class _OrganisationsState extends State<Organisations> {
  final Stream<QuerySnapshot> organisationQuery =
      FirebaseFirestore.instance.collection('users').where('type', isEqualTo: 'buyer').snapshots();

  organisationListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return OrganisationCard(
          UserModel.fromJSON(data),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: organisationQuery,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Something went wrong',
                  textAlign: TextAlign.center,
                ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Loading",
                  textAlign: TextAlign.center,
                ));
          }
          return organisationListView(snapshot);
        });
  }
}
