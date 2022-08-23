import 'package:sfpo/constants/packages.dart';
import 'package:sfpo/services/get_fpo_logo.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String logoUrl = "";

  fpoLogo() async {
    final User? user = FirebaseAuth.instance.currentUser!;
    final _uid = user!.uid;
    final fpoLogosRef = await FirebaseStorage.instance
        .ref()
        .child("fpoLogos")
        .child("$_uid.jpg");
    logoUrl = await fpoLogosRef.getDownloadURL();
    return logoUrl;
  }

  @override
  void initState() {
    fpoLogo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: logoUrl.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: avatarBackgroundColor,
                    child: Icon(Icons.person, size: 50, color: avatarIconColor),
                  )
                : GetFpoLogo(),
            accountName: GetFpoData(fieldName: "fpoShortName"),
            accountEmail: GetFpoData(fieldName: "email"),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    "https://cdn.wallpapersafari.com/47/99/AxSFbz.jpg",
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Governance"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GovernanceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_outlined),
            title: const Text("Members"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MembersScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services_outlined),
            title: const Text("Services"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServicesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.business_center_outlined),
            title: const Text("Business"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusinessScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_work_outlined),
            title: const Text("Employees"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: const Text("Weather"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WeatherScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text("Policies"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PoliciesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_outlined),
            title: const Text("About us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text("Notifications"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app_outlined),
            title: const Text("Sign out"),
            onTap: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
