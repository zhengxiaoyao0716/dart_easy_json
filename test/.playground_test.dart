import 'dart:convert';
import 'dart:mirrors';

import 'package:easy_json/easy_json.dart';
import 'package:test/test.dart';

import '../example/model.dart';

class T {
  final String a;
  final List<String> b;
  final Map<String, int> c;
  // TODO .

  T(this.a, {this.b, this.c});
}

void main() {
  test('config serialize', () {
    // json.decode(
    //   '{"name":"test","servers":[{"name":{},"address":{},"comments":null}],"params":{"symbol":{"hashCode":83816405}},"version":"1.0.0-1550329285034"}',
    // );
    var data = ofJson(T, json.decode('{"a":"aaa","b":["b"],"c":{"c":123}}'));
    print(data.a);
    print(data.b);
    print(data.c);
  });
}

dynamic _getJsonField(DeclarationMirror mirror) => mirror?.metadata
    ?.singleWhere(
      (mirror) => mirror.reflectee is EasyJson,
      orElse: () => null,
    )
    ?.reflectee;
