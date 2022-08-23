import 'package:sfpo/constants/packages.dart';

class GetFpoLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fpoUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("fpos")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return CircleAvatar(
            child: Icon(Icons.warning_amber),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: avatarBackgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(data['logoUrl'], fit: BoxFit.fill),
            ),
          );
        }
        return CircleAvatar(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
