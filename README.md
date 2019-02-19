# A JSON serialization library for Dart developers.
> Based on reflection (by `dart:mirrors`), serialized and parse json easily without generate code.

## Usage

A simple usage example:

```dart
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

```

## Features and TODO List
- [x] toJson (serialized object without generate code)
- [x] ofJson (parse from json map without generate code)
- [x] nested (auto serialized and parse the nested type)
- [x] @JsonIgnored (ingored some fields when serialized and parse)
- [x] @JsonField (custom the `of` and `to` function of some fields)
- [x] @JsonModel (custom the `of` and `to` function of some class)
- [x] @EasJson<It, Json> (full support of explicit generic type)
- [ ] redirecting support (syntax like `factory Constructor = aConstructor`)
- [ ] cache (cache the reflection shape of the model to speed up the next usage)
