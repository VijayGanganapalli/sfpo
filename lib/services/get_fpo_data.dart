import 'package:sfpo/constants/packages.dart';

class GetFpoData extends StatelessWidget {
  final String? fieldName;
  final TextStyle? textStyle;

  final fposRef = FirebaseFirestore.instance.collection("fpos");

  GetFpoData({Key? key, this.fieldName, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fpoUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: fposRef.doc(fpoUid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            data[fieldName],
            style: textStyle,
          );
        }
        return Text('Loading..');
      },
    );
  }
}
