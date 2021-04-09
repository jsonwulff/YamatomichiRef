# Testing Strategy

Inspiration taking from the following video: [https://www.youtube.com/watch?v=URSWYvyc42M&ab_channel=Confreaks](https://www.youtube.com/watch?v=URSWYvyc42M&ab_channel=Confreaks)

The main goals of our testing strategy are:

- Gives Value
- Thorough
- Stable
- Fast
- Few

By using this strategy we're also putting the responsibility on the developers, to themselves make a judegement of whether a method needs testing or not

## Sandi Metz's Testing Matrix

And testing the parts of the code that is shown in the diagram below

![sandi-metz-testing-matrix](https://github.com/jsonwulff/YamatomichiApp/tree/main/Documentation/assets/Sandi_Metz_Testing_Matrix.png)

Due to the goal of 'Gives Value' no testing is done of the widgets as it doesn't help us in the long run, and they're extremelu 'Unstable'

### Query

The <ins>Query</ins> is a call to an object that doesn't change its inner stage but returns a value

### Command

The <ins>Command</ins> is a call to an object that changes its inner stage but doesn't return anything

### Row 1 Incoming

In case of <ins>Query</ins> an example can be seen below

```Dart
    Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
      var snaps = await calendarEvents
          .where('startDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(date),
              isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
          .orderBy('startDate')
          .get();
      List<Map<String, dynamic>> events = [];

      snaps.docs.forEach((element) => events.add(element.data()));
      return events;
    }
```

With the test only looking at the interface, which in simpler terms meaning looking at the input and output, such that the inner workings of the class is irrelevant, and this implementation can now be exchanged with any other implementaion without the test needing to change

```Dart
    Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date);
```

In case of <ins>Query</ins> an example can be seen below, note that this assert on the side effect, i.e. that the field of event is set to null

```Dart
  class EventNotifier with ChangeNotifier {
    Event _event;

    remove() {
      _event = null;
    }
  }
```

### Row 2 Sent To Self

Aka private methods which in Dart is defined by the prefix of underline _ in methods names. Any method that is private and hence only used in that object should NOT be tested. An example can be seen below

```Dart
class ThemeDataCustom {
  static TextTheme _getTextTheme() {
    return TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
    );
  }
}
```

### Row 3 Outgoing

Here only <ins>Commands</ins> are tested, meaning that we aren't testing that the message is being sent, but we assert on the side effect of this method which here is that the Firestore (_store) is updated. To do that the class EventApi is given a mocked firestore, in which an update can be asserted

```Dart
class EventApi {
  final _store;

  EventApi(this._store);
  
  highlight(Event event, bool setTo) async {
    print('highlight event begun');
    CollectionReference eventRef = _store.collection('calendarEvent');
    await eventRef.doc(event.id).update({'highlighted': setTo}).then(
      (value) {
        print('event highlighted set to $setTo');
        return true;
      },
    );
  }
}

```

## Final note

As metioned at the top it is the responsibility of the developers to decide whether a test is needed, as seen with the example below this class was decided not to be tested, as it will change quite often because the theme of the app changes often


```dart
class ThemeDataCustom {
  static ThemeData getThemeData() {
    return ThemeData(
      textTheme: _getTextTheme(),
    );
  }

  static TextTheme _getTextTheme() {
    return TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
    );
  }
}
```