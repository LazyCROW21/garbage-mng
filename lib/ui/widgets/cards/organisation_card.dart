import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/user_model.dart';

class OrganisationCard extends StatefulWidget {
  final UserModel data;
  const OrganisationCard(this.data, {Key? key}) : super(key: key);

  @override
  State<OrganisationCard> createState() => _OrganisationCardState();
}

class _OrganisationCardState extends State<OrganisationCard> {
  String? storageImgURL;

  @override
  void initState() {
    super.initState();
    FirebaseStorage.instance.ref().child('files/user_${widget.data.id}').getDownloadURL().then((value) {
      setState(() {
        storageImgURL = value;
      });
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 96,
        child: Stack(children: [
          Row(children: [
            Expanded(
                flex: 2,
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: storageImgURL == null
                          ? Image.asset(
                              'assets/images/account.png',
                              height: 128,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              storageImgURL!,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                    ))),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.data.fullName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data.phone,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                color: Colors.green,
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed('/editOrganisation', arguments: widget.data);
                },
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
