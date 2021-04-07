import 'package:flutter/material.dart';

class TermsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key('Terms_AppBar'),
        brightness: Brightness.dark,
        title: Text('Terms and conditions'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: RichText(
            key: Key('Terms_RichText'),
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris blandit ante hendrerit ultricies efficitur. Etiam tempus cursus justo, a vehicula orci dignissim vitae. Phasellus non pulvinar leo, mattis tincidunt ipsum. Suspendisse dapibus, neque sit amet vestibulum bibendum, urna quam vestibulum purus, sed aliquet lorem ligula ac mi. Quisque at lacus volutpat, consectetur urna quis, feugiat est. Morbi mollis, nisi maximus commodo lacinia, nulla nunc blandit justo, et malesuada sem dui in turpis. Mauris sodales cursus dolor, ut facilisis velit accumsan a. In at luctus felis. Suspendisse a mattis quam. Aliquam mattis purus mi, sit amet fringilla lorem egestas eget. Cras nec lacus velit. Donec scelerisque cursus augue sed ultrices. Proin viverra, sem id commodo elementum, enim dui auctor neque, sed posuere augue tellus gravida velit. Maecenas vitae enim convallis, accumsan mauris eu, semper massa. Ut sed diam eu purus sagittis venenatis nec sit amet eros. Sed vel placerat ante.'),
          ),
        ),
      ),
    );
  }
}
