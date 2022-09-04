import 'package:sfpo/constants/packages.dart';

class GetMembersInfo extends StatefulWidget {
  const GetMembersInfo({Key? key}) : super(key: key);

  @override
  State<GetMembersInfo> createState() => _GetMembersInfoState();
}

class _GetMembersInfoState extends State<GetMembersInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('fpos')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('members')
          .where('aadhar', isEqualTo: 582323548154)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Text("${doc['aadhar']}");
            }).toList(),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
