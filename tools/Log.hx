package tools;

import haxe.Json;

function prettyPrint(?msg, data:Dynamic) {
  Sys.println(msg);
  Sys.println(Json.stringify(data, null, "  "));
}

function print(data:Dynamic) {
  Sys.println(data);
}

function print2(msg, data:Dynamic) {
  Sys.print(msg);
  Sys.println(data);
}
