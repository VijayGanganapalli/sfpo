import 'package:sfpo/constants/packages.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int memCount = 0;
  int maleCount = 0;
  int femaleCount = 0;

  getMemData() async {
    CollectionReference _memRef = await FirebaseFirestore.instance
        .collection('fpos')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('members');
    QuerySnapshot memSnapshot = await _memRef.get();
    QuerySnapshot maleMemSnapshot =
        await _memRef.where('gender', isEqualTo: 'Male').get();
    QuerySnapshot femaleMemSnapshot =
        await _memRef.where('gender', isEqualTo: 'Female').get();
    setState(() {
      memCount = memSnapshot.size;
      maleCount = maleMemSnapshot.size;
      femaleCount = femaleMemSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    getMemData();
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // appbar
          SliverAppBar.medium(
            stretch: true,
            title: const Text(
              "Dashboard",
              style: TextStyle(color: accentColor),
            ),
            actions: [
              IconButton(
                color: accentColor,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomDashboardCard(
                    title: "Members",
                    subTitle: "Total members enrolled\n"
                        "Male members enrolled\n"
                        "Female members enrolled",
                    subTitleValue: ":  $memCount\n"
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
          ),
        ],
      ),
    );
  }
}
