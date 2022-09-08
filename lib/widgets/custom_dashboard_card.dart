import 'package:sfpo/constants/packages.dart';

class CustomDashboardCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String subTitleValue;
  final Function()? onTap;

  const CustomDashboardCard({
    Key? key,
    required this.title,
    this.onTap,
    required this.subTitleValue,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(title, style: boldDashboardTitleText),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(subTitle),
                        Text(subTitleValue, style: regularMembersText),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
