import 'package:sfpo/constants/packages.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String? memberId;
  String memImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Members",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('fpos')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('members')
              .orderBy("memId", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }
            if (snapshot.hasData) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs
                    .map(
                      (document) => CustomMembersCard(
                        memImageUrl: document['memImgUrl'],
                        fullName: document['fullName'],
                        surname: document['surname'],
                        fatherOrHusbandName: document['fatherOrHusbandName'],
                        revenueVillage: document['revenueVillage'],
                        maritalTitle: document['maritalTitle'],
                        habitaion: document['habitation'],
                        membership: document['membership'],
                        shareCapital: document['shareCapital'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MemberDetailsScreen(memberId: document.id),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: "Add member",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMember(),
            ),
          );
        },
      ),
    );
  }
}
