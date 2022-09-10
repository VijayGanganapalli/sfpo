import 'package:sfpo/constants/packages.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text('Notifications', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
