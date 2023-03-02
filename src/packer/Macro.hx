package packer;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using Safety;
using haxe.macro.ComplexTypeTools;

/**
  Gets the values of the given object expression and
  turns it into an untyped lua call with the values in the right order.
  like this:
  ```
  // plugin({1, 2, a=3})
  untyped __lua__("{ {0}, {1}, a={2} }", 1, 2, 3)
  ```
 */
macro function plugin(expr:Expr) {
  final expected = Context.getExpectedType();
  switch (expected) {
    case TType(t, params):
      final values = TableWrapper.extractObjFields(expr);
      var idx = 0;
      final lala = [for (k => v in values.fieldExprs) {
        {str: '$k = {${idx++}}, ', expr: v};
      }];
      final lolo = lala.fold(
        (item, acc:{str:String, expr:Array< Expr >}) -> {
          acc.str += item.str;
          acc.expr.push(item.expr);
          return acc;
        },
        {str: "", expr: []}
      );
      // We need to split this last thing like this because we need to get
      // an array of Expr first so reification converts
      // the  resulting array to the arguments of the __lua__ call
      final args = [macro $v{'{ ${lolo.str} }'}].concat(lolo.expr);
      // This is the actual wanted output
      final out = macro untyped __lua__($a{args});
      trace(out.toString());
      return out;
    case _:
      trace("other");
  };

  return null;
}
