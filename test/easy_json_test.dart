import 'package:easy_json/easy_json.dart';
import 'package:test/test.dart';

import '../example/model.dart';

void main() {
  group('Test stringify `Model.init`:', () {
    Map<String, dynamic> json;
    Map<String, dynamic> server;
    List<dynamic> events;

    setUp(() {
      json = toJson(Model.init);
      server = json['servers'][0];
      events = json['events'][0];
    });

    test('Model', () {
      expect(json['name'], TypeMatcher<String>());
      expect(json['servers'], TypeMatcher<List>());
      expect(json['events'], TypeMatcher<List>());
      expect(json['version'], TypeMatcher<String>());
      expect(json['params'], TypeMatcher<Map>());
    });

    test('Nested Servers', () {
      expect(server['name'], TypeMatcher<String>());
      expect(server['address'], TypeMatcher<String>());
      expect(server.containsKey('comments'), false);
    });

    test('Nested Events', () {
      expect(events[0], TypeMatcher<int>());
      expect(events[1], TypeMatcher<String>());
    });
  });
}
