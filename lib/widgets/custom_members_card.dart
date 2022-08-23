import 'package:sfpo/constants/packages.dart';

class CustomMembersCard extends StatelessWidget {
  final String? fullName;
  final String? surname;
  final Function()? onTap;
  final bool? isProfileImageLoaded;
  final String? fatherOrHusbandName;
  final bool? isMarried;
  final String? gramaPanchayati;
  final String? habitaion;
  final num? membership;
  final num? shareCapital;
  final String? gender;
  final String? maritalTitle;

  const CustomMembersCard({
    Key? key,
    this.onTap,
    this.fullName,
    this.surname,
    this.isProfileImageLoaded,
    this.fatherOrHusbandName,
    this.gramaPanchayati,
    this.habitaion,
    this.membership,
    this.shareCapital,
    this.isMarried,
    this.gender,
    this.maritalTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: accentColor,
        ),
        height: 100,
        width: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: avatarBackgroundColor,
                  radius: 30.0,
                  child: Icon(
                    Icons.person_rounded,
                    size: 44,
                    color: avatarIconColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$fullName $surname",
                    style: boldMembersTitle,
                  ),
                  Text(
                    "$maritalTitle $fatherOrHusbandName",
                    style: regularMembersText,
                  ),
                  Text(
                    "$gramaPanchayati",
                    style: regularMembersText,
                  ),
                  Text(
                    "$habitaion",
                    style: regularMembersText,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("$membership"),
                    Text("$shareCapital"),
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
