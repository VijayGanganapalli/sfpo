import 'package:sfpo/constants/packages.dart';

class GetMembersInfo extends StatelessWidget {
  const GetMembersInfo({Key? key}) : super(key: key);

  /*getMemberData(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((document) {
      Text(document.get(fieldName));
    }).toList();
  }*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Global.membersRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading..");
        }
        final List storeDocs = [];
        snapshot.data!.docs.map((DocumentSnapshot snapshot) {
          Map a = snapshot.data() as Map<String, dynamic>;
          storeDocs.add(a);
        }).toList();
        return Text("$storeDocs");
      },
    );
  }
}
