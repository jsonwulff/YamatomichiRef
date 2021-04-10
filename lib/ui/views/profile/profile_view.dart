// import 'package:app/ui/routes/routes.dart';
// import 'package:app/ui/shared/navigation/app_bar_custom.dart';
// import 'package:app/ui/shared/navigation/bottom_navbar.dart';
// import 'package:flutter/material.dart';

// class ProfileViewPublic extends StatefulWidget {
//   ProfileViewPublic({Key key}) : super(key: key);

//   @override
//   _ProfileViewPublicState createState() => _ProfileViewPublicState();
// }

// class _ProfileViewPublicState extends State<ProfileViewPublic> {
//   Widget buildAboutSection() {
//     return Expanded(
//       flex: 1,
//       child: Column(

//       ),
//     );
//   }

//   Widget buildPackListSection() {}

//   Widget buildEventSection() {}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: true // user in session == profile viewed
//           ? AppBarCustom.basicAppBarWithPopAndAction(
//               'firstname', context, profileRoute, Icons.settings)
//           : AppBarCustom.basicAppBarWithContext('username', context),
//       bottomNavigationBar: BottomNavBar(),
//       body: SafeArea(
//         minimum: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               buildAboutSection(),
//               buildPackListSection(),
//               buildEventSection()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
