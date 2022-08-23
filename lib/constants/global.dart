import 'package:sfpo/constants/packages.dart';

class Global {
  static final fpoInfoRef = FirebaseFirestore.instance
      .collection("fpos")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  static final CollectionReference membersRef = FirebaseFirestore.instance
      .collection("fpos")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("members");

  static final fpoUid = FirebaseAuth.instance.currentUser!.uid;

  static getMemberData(String memId, String fieldName) {
    return FirebaseFirestore.instance
        .collection("fpos")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("members")
        .doc(memId)
        .snapshots()
        .map((document) => document.data()![fieldName]);
  }
}
