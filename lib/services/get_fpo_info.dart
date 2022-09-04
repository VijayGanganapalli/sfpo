import 'package:sfpo/constants/packages.dart';

class GetFpoInfo extends StatelessWidget {
  GetFpoInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('fpos')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('members')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("/Loading");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          snapshot.data!.docs.map((snapshot) {
            var k = snapshot.data();
            return Text("/$k");
          });
        }
        return Text('/Loading..');
      },
    );
  }
}
