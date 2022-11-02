import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garbage_mng/models/user_model.dart';

typedef CodeSentCallback = Function(String verificationId, int? resendToken);

class AuthService {
  static UserModel? user =
      UserModel(id: '5m9FmfGCMuYn9a226yjrLzcjWS02', fullName: 'Soham Amin', phone: '+918488947361', type: 'admin');
  static Future<void> sendOTP(String phoneNumber, CodeSentCallback codeSent) {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<void> confirmOTP(String verificationId, String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    UserCredential userCredential = await auth.signInWithCredential(credential);
    var userCollection = FirebaseFirestore.instance.collection("users");
    var userDoc = await userCollection.where('phone', isEqualTo: userCredential.user!.phoneNumber).limit(1).snapshots().first;
    if (userDoc.docs.isNotEmpty) {
      var userJSON = userDoc.docs.first.data();
      userJSON['id'] = userDoc.docs.first.id;
      AuthService.user = UserModel.fromJSON(userJSON);
    } else {
      throw Error.throwWithStackTrace('No User Found', StackTrace.current);
    }
  }

  static Future<void> createAccount(String fullName, String phone, String verificationId, String smsCode, String type) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    UserCredential userCredential = await auth.signInWithCredential(credential);
    var userCollection = FirebaseFirestore.instance.collection("users");
    var data = {'fullName': fullName, 'phone': userCredential.user?.phoneNumber ?? phone, 'type': type};
    var newUser = await userCollection.add(data);
    data['id'] = newUser.id;
    AuthService.user = UserModel.fromJSON(data);
  }
}
