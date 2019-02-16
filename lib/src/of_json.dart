part of easy_json;

dynamic _ofJson(ClassMirror cls, dynamic json) {
  var mark = _getJsonField(cls);
  if ((mark?.isModel ?? false) && (mark.of != null)) {
    return mark.of(json);
  }

  switch (cls?.simpleName) {
    case Symbol('int'):
    case Symbol('double'):
    case Symbol('String'):
    case Symbol('bool'):
    case Symbol('Null'):
      return json;
    case Symbol('List'):
      return json.map((json) => _ofJson(cls.typeArguments[0], json)).toList();
    case Symbol('Map'):
      return json.map((k, v) {
        return MapEntry(
          _ofJson(cls.typeArguments[0], k),
          _ofJson(cls.typeArguments[1], v),
        );
      });
  }

  var positionalArguments = <dynamic>[];
  var namedArguments = <Symbol, dynamic>{};
  var constructor = cls.declarations[cls.simpleName] as MethodMirror;
  (constructor.parameters ?? []).forEach((param) {
    var key = param.simpleName;
    var raw = json[MirrorSystem.getName(key)];
    var value = _ofJson(param.type, raw);
    if (param.isNamed) {
      namedArguments[key] = value;
    } else {
      positionalArguments.add(value);
    }
  });
  var instance =
      cls.newInstance(Symbol.empty, positionalArguments, namedArguments);

  cls.declarations.forEach((symbol, declare) {
    var mark = _getJsonField(declare);
    // TODO .
  });

  return instance.reflectee;
}

dynamic ofJson(Type type, dynamic json) => _ofJson(reflectClass(type), json);

dynamic ofJsonString(Type type, String text) => ofJson(type, json.encode(text));
