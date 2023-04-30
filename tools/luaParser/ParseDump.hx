package tools.luaParser;

import hxparse.Position;
import byte.ByteData;

using StringTools;

function dumpAtCurrent(pos:Position, input:ByteData, lastToken:String) {
  final max:Int = input.length - 1;
  final inputAsString = input.readString(0, max);
  final lines = inputAsString.split("\n");
  final linePosition = pos.getLinePosition(input);
  final line = lines[linePosition.lineMin - 1];
  Log.print2("> Last parsed token: ", lastToken);
  Log.print2("> ", line);
  // final cursorWidth = (pos.pmax - pos.pmin) - 1;
  final padding = 2;
  final cursorPadding = linePosition.posMax + padding;
  // Log.print("^".lpad(" ", pos.pmin + padding) + "^".lpad(" ", cursorWidth + padding));
  Log.print("^".lpad(" ", cursorPadding));
  Log.print(pos.format(input));
}
