import 'package:easy_json/easy_json.dart';

main() {
  var simple = SimpleExample(
    0x01001,
    'name',
    ['item0'],
    {'name0': 'value0'},
    SimpleNested(0x02001),
  );
  var simpleEncoded = toJsonString(simple);
  print(simpleEncoded);
  var simpleDecoded = ofJsonString(SimpleExample, simpleEncoded);
  print(simpleDecoded);
}

class SimpleExample {
  final int id;
  final String name;
  final List<String> list;
  final Map<String, dynamic> map;
  final SimpleNested nested;
  @JsonIgnore
  final String ignored;

  SimpleExample(
    this.id,
    this.name,
    this.list,
    this.map,
    this.nested, [
    this.ignored,
  ]);
}

class SimpleNested {
  final int id;

  SimpleNested(this.id);
}
