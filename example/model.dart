import 'package:easy_json/easy_json.dart';

import 'alias.dart';

class Model {
  static Model init = Model(
    'test',
    servers: [Server.local],
    events: [Event(200, 'ok')],
    params: {
      'symbol': Symbol('test'),
    },
  );

  static int TIMESTAMP =
      new DateTime.now().millisecondsSinceEpoch; // test `static variable`
  static get VERSION => '1.0.0-${TIMESTAMP}'; // test `static getter`

  final String name; // test `variable`
  String get version => VERSION; // test `getter`
  final List<Server> servers; // test `List` and `nested type`
  final List<Event>
      events; // test `nested type` with custom `of` and `to` function.
  final Map<String, Symbol> params; // test `nested map` and `Symbol`

  const Model(
    this.name, {
    this.servers,
    this.events,
    this.params,
  });

  // factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  // Map<String, dynamic> toJson() => _$ConfigToJson(this);

  Map<String, dynamic> toJson() {
    return {};
  }
}

class Server {
  static Server local = Server(
    ServerName('localhost'),
    ServerAddress('http://127.0.0.1:8000'),
  );

  @NameField // strict usage
  final ServerName name;
  @JsonField(of: _AddressOf, to: _AddressTo) // simple usage
  final ServerAddress address;
  @JsonIgnore // test ignore
  final String comments; // test null

  const Server(this.name, this.address, [this.comments]);

  static const EasyJson<ServerName, String> NameField =
      EasyJson.field(of: _NameOf, to: _NameTo);
  static ServerName _NameOf(String json) => ServerName(json);
  static String _NameTo(ServerName it) => it.raw;

  static _AddressOf(json) => ServerAddress((json as String));
  static _AddressTo(it) => (it as ServerAddress).raw;
}

class ServerName = Alias<String> with Type;
class ServerAddress = Alias<String> with Type;

// const EventModel =
//     EasyJson<Event, List<String>>.model(of: Event._ofJson, to: Event._toJson);
// @EventModel // strict usage
@JsonModel(of: Event._ofJson, to: Event._toJson) // simple usage
class Event {
  final int code;
  final String message;

  const Event(this.code, this.message);

  static _ofJson(json) => Event(json[0], json[1]);
  static _toJson(it) => [it.code, it.message];
}
