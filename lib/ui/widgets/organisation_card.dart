import 'package:flutter/material.dart';
import 'package:garbage_mng/models/user_model.dart';

class OrganisationCard extends StatefulWidget {
  final UserModel data;
  const OrganisationCard(this.data, {Key? key}) : super(key: key);

  @override
  State<OrganisationCard> createState() => _OrganisationCardState();
}

class _OrganisationCardState extends State<OrganisationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 96,
        child: Stack(children: [
          Row(children: [
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network('https://img.icons8.com/color/96/000000/test-account.png'))),
            Expanded(
                flex: 3,
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
