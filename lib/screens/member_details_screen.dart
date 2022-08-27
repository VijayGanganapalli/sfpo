import 'package:sfpo/constants/packages.dart';
import 'package:sfpo/services/get_members_info.dart';

class MemberDetailsScreen extends StatefulWidget {
  final String memberId;

  const MemberDetailsScreen({Key? key, required this.memberId})
      : super(key: key);

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  String? memImgUrl;
  String? fullName;
  String? surname;
  String? gender;
  String? maritalStatus;
  String? fatherOrHusbandName;
  int? aadhar;
  int? mobileNumber;
  String? dob;
  double? landHolding;
  String? state;
  String? district;
  String? mandal;
  String? gramaPanchayati;
  String? habitation;
  String? joiningDate;
  int? membership;
  int? shareCapital;

  getRelationship() => (gender == "Female" && maritalStatus == "Married")
      ? "Husband name"
      : "Father name";

  @override
  Widget build(BuildContext context) {
    //getDataFromFirebase();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Member details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              print(const GetMembersInfo());
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('fpos')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('members')
              .doc(widget.memberId)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Center(child: Text("Error: ${snapshot.error}")),
                ),
              );
            }
            if (snapshot.hasData) {
              DocumentSnapshot docSnapshot = snapshot.data!;
              String relationship = (docSnapshot['gender'] == "Female" &&
                      docSnapshot['maritalStatus'] == "Married")
                  ? "Husband name"
                  : "Father name";
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          docSnapshot['memImgUrl'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Full name", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['fullName']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Surname", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['surname']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Gender", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['gender']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Marital status", style: membersTitle),
                    trailing: Text("${docSnapshot['maritalStatus']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text(relationship, style: membersTitle),
                    trailing: Text("${docSnapshot['fatherOrHusbandName']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Aadhar", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['aadhar']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Mobile", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['mobile']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Date of Birth", style: membersTitle),
                    trailing: Text("${docSnapshot['dob']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Land holding", style: membersTitle),
                    trailing: Text("${docSnapshot['landHolding']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Country", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['country']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("State", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['state']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("District", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['district']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Mandal", style: membersTitle),
                    trailing:
                        Text("${docSnapshot['mandal']}", style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Revenue village", style: membersTitle),
                    trailing: Text("${docSnapshot['revenueVillage']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Habitation", style: membersTitle),
                    trailing: Text("${docSnapshot['habitation']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Joining date", style: membersTitle),
                    trailing: Text("${docSnapshot['joiningDate']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Membership", style: membersTitle),
                    trailing: Text("${docSnapshot['membership']}",
                        style: membersText),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("Share capital", style: membersTitle),
                    trailing: Text("${docSnapshot['shareCapital']}",
                        style: membersText),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
