import 'package:flutter/rendering.dart';
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
      body: CustomScrollView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            title: Text('Members', style: TextStyle(color: accentColor)),
            actions: [
              IconButton(
                color: accentColor,
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('fpos')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('members')
                  .orderBy("memId", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map(
                          (document) => CustomMembersCard(
                            memImageUrl: document['memImgUrl'],
                            fullName: document['fullName'],
                            surname: document['surname'],
                            fatherOrHusbandName:
                                document['fatherOrHusbandName'],
                            revenueVillage: document['revenueVillage'],
                            maritalTitle: document['maritalTitle'],
                            habitaion: document['habitation'],
                            membership: document['membership'],
                            shareCapital: document['shareCapital'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemberDetailsScreen(
                                      memberId: document.id),
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
        ],
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
