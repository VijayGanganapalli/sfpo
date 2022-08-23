import 'package:sfpo/constants/packages.dart';

class GetFpoInfo extends StatelessWidget {
  final String fieldName;

  const GetFpoInfo({Key? key, required this.fieldName}) : super(key: key);

  getFpoLogo() async {
    final User? user = FirebaseAuth.instance.currentUser!;
    final _uid = user!.uid;
    final fpoLogosRef = await FirebaseStorage.instance
        .ref()
        .child("fpoLogos")
        .child("$_uid.jpg");
    return await fpoLogosRef.getDownloadURL();
  }

  getFpoInfo(snapshot) {
    return snapshot.data!.docs.map((doc) => Text(doc[fieldName])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Global.fpoInfoRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading..");
        return ListView(
          shrinkWrap: true,
          children: getFpoInfo(fieldName),
        );
      },
    );
  }
}
