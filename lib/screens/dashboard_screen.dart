import 'package:sfpo/constants/packages.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int membersCount = 0;
  int maleCount = 0;
  int femaleCount = 0;

  final CollectionReference _membersRef = FirebaseFirestore.instance
      .collection("fpos")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("members");

  Future getMembersData() async {
    QuerySnapshot memSnap = await _membersRef.get();
    QuerySnapshot maleSnap =
        await _membersRef.where("gender", isEqualTo: "Male").get();
    QuerySnapshot femaleSnap =
        await _membersRef.where("gender", isEqualTo: "Female").get();
    setState(() {
      membersCount = memSnap.size;
      maleCount = maleSnap.size;
      femaleCount = femaleSnap.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    getMembersData();
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "Dashboard",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              badgeContent: const Text("0"),
              child: const Icon(Icons.notifications_none),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            CustomDashboardCard(
              title: "Members",
              subTitle: "Total members enrolled\n"
                  "Male members enrolled\n"
                  "Female members enrolled",
              subTitleValue: ":  $membersCount\n"
                  ":  $maleCount\n"
                  ":  $femaleCount",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembersScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
