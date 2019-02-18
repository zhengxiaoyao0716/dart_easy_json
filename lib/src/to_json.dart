part of easy_json;

dynamic toJson(dynamic obj) {
  switch (obj.runtimeType) {
    case int:
    case double:
    case String:
    case bool:
    case Null:
    case dynamic:
      return obj;
    default:
      if (obj is List) {
        return obj.map(toJson).toList();
      }
      if (obj is Map) {
        return obj.map((k, v) => MapEntry(k, toJson(v)));
      }
  }

  var instance = reflect(obj);

  var mark = _getJsonMark(instance.type);
  if ((mark?.isModel ?? false) && (mark.to != null)) {
    return mark.to(obj);
  }

  return Map.fromEntries(instance.type.declarations.entries.map((entry) {
    var symbol = entry.key;
    var declare = entry.value;

    if (declare is VariableMirror) {
      if (declare.isStatic) return null;
      if (declare.isPrivate) return null;
    } else if (declare is MethodMirror) {
      if (declare.isStatic) return null;
      // if (declare.isConstructor) return null;
      // if (declare.isRegularMethod) return null;
      // if (declare.isSetter) return null;
      if (!declare.isGetter) return null;
    }
    var mark = _getJsonMark(declare);
    if (mark?.ignored ?? false) return null;

    var key = mark?.field ?? MirrorSystem.getName(symbol);
    var raw = instance.getField(symbol).reflectee;
    var value = mark?.to == null ? toJson(raw) : mark.to(raw);

    return MapEntry(key as String, value);
  }).where((entry) => entry != null));
}

String toJsonString(dynamic obj) => json.encode(toJson(obj));
