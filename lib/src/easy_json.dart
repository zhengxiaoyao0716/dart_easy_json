part of easy_json;

typedef It OfJson<It, Json>(Json it);
typedef Json ToJson<It, Json>(It it);

class EasyJson<It, Json> {
  final String field;
  final bool isModel;
  final OfJson<It, Json> of;
  final ToJson<It, Json> to;

  final bool ignored;

  const EasyJson._({
    this.field,
    this.of,
    this.to,
    this.ignored,
    this.isModel,
  });

  const EasyJson.model({
    OfJson<It, Json> of,
    ToJson<It, Json> to,
  }) : this._(field: null, isModel: true, of: of, to: to);

  const EasyJson.field({
    String key,
    OfJson<It, Json> of,
    ToJson<It, Json> to,
  }) : this._(field: key, isModel: false, of: of, to: to);

  static const ignore = EasyJson._(ignored: true);
}

class JsonModel extends EasyJson {
  const JsonModel({OfJson of, ToJson to}) : super.model(of: of, to: to);
}

class JsonField extends EasyJson {
  const JsonField({String key, OfJson of, ToJson to})
      : super.field(key: key, of: of, to: to);
}

const JsonIgnore = EasyJson.ignore;

dynamic _getJsonField(DeclarationMirror mirror) => mirror.metadata
    .singleWhere(
      (mirror) => mirror.reflectee is EasyJson,
      orElse: () => null,
    )
    ?.reflectee;
