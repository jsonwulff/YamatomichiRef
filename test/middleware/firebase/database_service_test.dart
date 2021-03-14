@Skip('Firebase merge issue')
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCalendarDBTest extends Mock {}

main() {
  final firebase = MockCalendarDBTest();
  Map<String, dynamic> correctdata = {
    'title': 'testTitle',
    'description': 'testDescription',
    'fromData': DateTime(2017, 9, 7, 17, 30),
    'toData': DateTime(2017, 9, 10, 17, 30),
  };

  group('Add Event', () {
    test('Logged In, correct data', () async {
      throw UnimplementedError();
    });

    test('With a null value in map, throws event not fulfilled', () async {
      throw UnimplementedError();
    });

    test('Without being logged in', () async {
      throw UnimplementedError();
    });
  });

  group('Get Events', () {
    test('getEventsByDate with correct date, returns correct list', () async {
      //expect(
      //  await DatabaseService().getEventsByDate(DateTime(2017, 9, 7, 17, 30)),
      //  '...');
      throw UnimplementedError();
    });

    test('getEventsByDate with type not date, returns correct error', () async {
      throw UnimplementedError();
    });
  });
}
