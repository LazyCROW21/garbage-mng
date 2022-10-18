import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garbage_mng/models/user_model.dart';

typedef CodeSentCallback = Function(String verificationId, int? resendToken);

class AuthService {
  static UserModel? user =
      UserModel(id: 'Jt5l82QR9uXigxn7dZ1Al6SRJre2', fullName: 'Admin User', phone: '+917567496109', type: 'admin');
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
    var userDoc = await userCollection.doc(userCredential.user?.uid).snapshots().first;
    var userJSON = userDoc.data();
    if (userJSON != null) {
      userJSON['id'] = userDoc.id;
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
    await userCollection
        .doc(userCredential.user?.uid)
        .set({'fullName': fullName, 'phone': userCredential.user?.phoneNumber ?? phone, 'type': type});
    var userDoc = await userCollection.doc(userCredential.user?.uid).snapshots().first;
    var userJSON = userDoc.data();
    if (userJSON != null) {
      userJSON['id'] = userDoc.id;
      AuthService.user = UserModel.fromJSON(userJSON);
    } else {
      throw Error.throwWithStackTrace('No User Found', StackTrace.current);
    }
  }
}
