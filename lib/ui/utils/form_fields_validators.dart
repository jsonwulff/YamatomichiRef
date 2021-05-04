import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormFieldValidators {
  final AppLocalizations texts;

  FormFieldValidators(this.texts);

  String userBirthday(String value) {
    if (value.isEmpty) {
      return texts.pleaseFillInYourBirthday;
    }
    return null;
  }

  String userCountry(String value) {
    if (value == null) {
      return texts.pleaseSelectYourCountry;
    }
    return null;
  }

  String userRegion(String value) {
    if (value == null) {
      return texts.pleaseSelectYourUsualHikingArea;
    } else if (value == 'Choose country') {
      return 'Please choose a country above and select region next';
    }
    return null;
  }

  String userFirstName(String value) {
    if (value.isEmpty) {
      return texts.pleaseFillInFirstName;
    } else if (value.length < 2 || value.length > 32) {
      return texts.firstNameMustBeMoreThan2and32;
    }
    return null;
  }

  String userLastName(String value) {
    if (value.isEmpty) {
      return texts.pleaseFillInLastName;
    } else if (value.length < 2 || value.length > 32) {
      return texts.lastNameMustBeMoreThan2and32;
    }
    return null;
  }

  String userGender(String value) {
    if (value == null) {
      return texts.selectGender;
    }
    return null;
  }
}
