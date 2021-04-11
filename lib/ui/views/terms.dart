// NOTE: Keep here if requirements changes
// import 'package:app/ui/shared/navigation/app_bar_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

// class TermsView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var texts = AppLocalizations.of(context);

//     return Scaffold(
//       appBar: AppBarCustom.basicAppBarWithContext(texts.termsAndConditionsTitle, context), 
//       body: SafeArea(
//         minimum: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: RichText(
//             key: Key('Terms_RichText'),
//             text: TextSpan(
//                 style: Theme.of(context).textTheme.bodyText1,
//                 text:
//                     texts.termsAndConditionsText),
//           ),
//         ),
//       ),
//     );
//   }
// }
