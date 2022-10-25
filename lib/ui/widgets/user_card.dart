import 'package:flutter/material.dart';
import 'package:garbage_mng/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel data;
  final Function onDelete;
  const UserCard(this.data, {super.key, required this.onDelete});

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
                      data.fullName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.phone,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                color: Colors.red,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDelete();
                },
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
