import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/models/organisation.dart';

class EditOrganisationDetails extends StatefulWidget {
  final Organisation? editOrganisation;
  const EditOrganisationDetails({Key? key, required this.editOrganisation}) : super(key: key);

  @override
  State<EditOrganisationDetails> createState() => _EditOrganisationDetailsState();
}

class _EditOrganisationDetailsState extends State<EditOrganisationDetails> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSaving = false;
  bool isEditOrg = false;
  bool isDeleting = false;

  @override
  void initState() {
    if(widget.editOrganisation != null){
      isEditOrg = true;
    }
    super.initState();
  }

  String? titleValidator(String? inp) {
    if (inp == null) {
      return 'Title is required';
    } else if (inp.length < 3 || inp.length > 64) {
      return 'Title must be 3 to 64 characters';
    }
    return null;
  }

  String? numberValidator(String? inp) {
    if(inp == null) {
      return 'Number is required';
    }
    else if(inp.length != 10) {
      return 'Please enter a valid number';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isEditOrg ? 'Edit' : 'Add'} Organisation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Organisation Name'),
                validator: titleValidator,
                initialValue: widget.editOrganisation?.name,
                onSaved: (String? inp) {

                },
              ),
              const SizedBox(
                height: 12,
              ),TextFormField(
                keyboardType: TextInputType.number,
                initialValue: widget.editOrganisation?.number,
                decoration: const InputDecoration(labelText: 'Number'),
                validator: numberValidator,
                onSaved: (String? inp) {

                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: () {
                    bool? isValid = formKey.currentState?.validate();
                    if (isValid == null || isValid == false) {
                      return;
                    }
                    formKey.currentState?.save();
                    setState(() {
                      isSaving = true;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isSaving
                            ? const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: SpinKitRing(
                            color: Colors.white,
                            lineWidth: 2,
                            size: 18.0,
                          ),
                        )
                            : const SizedBox.shrink(),
                        Text(
                          isEditOrg ? 'Save' : 'Add',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 12,
              ),
              isEditOrg ?
              ElevatedButton(
                  onPressed: () {
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
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isDeleting
                            ? const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: SpinKitRing(
                            color: Colors.white,
                            lineWidth: 2,
                            size: 18.0,
                          ),
                        )
                            : const SizedBox.shrink(),
                        const Text(
                          'Remove',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ],
                    ),
                  )) : Container()

            ],
          ),
        ),
      ),
    );
  }
}
