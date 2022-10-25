import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/user_model.dart';
import 'package:garbage_mng/ui/widgets/cards/user_card.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final Stream<QuerySnapshot> usersQuery =
      FirebaseFirestore.instance.collection('users').where('type', isEqualTo: 'seller').snapshots();

  removeUser(String id) {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
    usersCollection.doc(id).delete().then((value) {
      const snackBar = SnackBar(content: Text('User removed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((err) {
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  userListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return UserCard(
          UserModel.fromJSON(data),
          onDelete: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Confirm delete?'),
                      content: const Text('Are you sure you want to delete this item?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Delete');
                            removeUser(document.id);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ));
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: usersQuery,
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
          return userListView(snapshot);
        });
  }
}
