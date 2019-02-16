import 'package:easy_json/easy_json.dart';

import 'model.dart';

main() {
  var string = toJsonString(Model.init);
  print('Stringify `Model.init`: ${string}');
}
