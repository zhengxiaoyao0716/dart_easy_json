part of easy_json;

dynamic _ofJson(TypeMirror type, dynamic json) {
  var mark = _getJsonMark(type);
  if ((mark?.isModel ?? false) && (mark.of != null)) {
    return mark.of(json);
  }

  if (json == null) return null;
  switch (type?.simpleName) {
    case Symbol('int'):
    case Symbol('double'):
    case Symbol('String'):
    case Symbol('bool'):
    case Symbol('Null'):
    case Symbol('dynamic'):
      return json;
    case Symbol('List'):
      return json.map((json) => _ofJson(type.typeArguments[0], json)).toList();
    case Symbol('Map'):
      return json.map((k, v) {
        return MapEntry(
          _ofJson(type.typeArguments[0], k),
          _ofJson(type.typeArguments[1], v),
        );
      });
  }

  if (!(type is ClassMirror)) return null;
  ClassMirror cls = type;

  var fields = Map.fromEntries(cls.declarations.entries.map((entry) {
    var symbol = entry.key;
    var declare = entry.value;

    String Function() name;
    TypeMirror type;

    if (declare is VariableMirror) {
      if (declare.isStatic) return null;
      if (declare.isPrivate) return null;
      name = () => MirrorSystem.getName(symbol);
      type = declare.type;
    } else if (declare is MethodMirror) {
      if (declare.isStatic) return null;
      // if (declare.isConstructor) return null;
      // if (declare.isRegularMethod) return null;
      // if (declare.isGetter) return null;
      if (!declare.isSetter) return null;
      name = () {
        var name = MirrorSystem.getName(symbol);
        return name.substring(0, name.length - 1);
      };
      type = declare.parameters[0].type;
    }
    var mark = _getJsonMark(declare);
    if (mark?.ignored ?? false) return null;

    var key = mark?.field ?? name();
    var raw = json[key];
    var value = mark?.of == null ? _ofJson(type, raw) : mark.of(raw);

    return MapEntry(key as String, value);
  }).where((entry) => entry != null));

  // cls.staticMembers.entries.where((entry) {
  //   var symbol = entry.key;
  //   var method = entry.value;
  //   if (method.isSynthetic) {
  //     print('isSynthetic'); // TODO redirecting constructor.
  //   }
  //   var key = MirrorSystem.getName(symbol);
  //   var value = cls.getField(symbol);
  //   print('$key, ${value}');
  //   return true;
  // }).toList();

  var constructor = cls.declarations[cls.simpleName] as MethodMirror;
  if (constructor == null) return null; // TODO redirecting constructor.
  var positionalArguments = <dynamic>[];
  var namedArguments = <Symbol, dynamic>{};
  constructor.parameters.forEach((param) {
    var key = param.simpleName;

    var value = fields.remove(MirrorSystem.getName(key)) ??
        param.defaultValue?.reflectee;
    if (param.isNamed) {
      namedArguments[key] = value;
    } else {
      positionalArguments.add(value);
    }
  });

  var instance =
      cls.newInstance(Symbol.empty, positionalArguments, namedArguments);
  fields.forEach((key, value) {
    instance.setField(Symbol(key), value);
  });

  return instance.reflectee;
}

dynamic ofJson(Type type, dynamic json) => _ofJson(reflectClass(type), json);
