import 'dart:collection';

import 'package:app/middleware/models/packlist.dart';
import 'package:flutter/material.dart';

class PacklistNotifier with ChangeNotifier {
  List<Packlist> _packlistCollection = [];
  Packlist _packlist;

  UnmodifiableListView<Packlist> get packlistCollection =>
      UnmodifiableListView(_packlistCollection);

  Packlist get packlist => _packlist;

  set packlist(Packlist packlist) {
    _packlist = packlist;
    notifyListeners();
  }

  set packlistCollection(List<Packlist> packlistCollection) {
    _packlistCollection = packlistCollection;
    notifyListeners();
  }

  remove() {
    _packlist = null;
  }
}
