// From https://try.haxe.org/#0D7f4371
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.TypeTools;
using haxe.macro.ExprTools;

var uniqueCount = 1;
#end
// Class that transforms any Haxe object into a plain lua table
// Thanks to @kLabz
#if macro
abstract TableWrapper< T:{} >(Dynamic) {
#else
abstract TableWrapper< T:{} >(lua.Table< String, Dynamic >) {
#end
@:pure @:noCompletion extern public static function check< T:{} >(v:T):TableWrapper< T >;

#if macro
public static function followTypesUp(arg:haxe.macro.Type) {
  return switch (arg) {
    case TAnonymous(_.get().fields => fields):
      fields;
    case TAbstract(_, [type]):
      followTypesUp(type);
    case TType(_, _):
      followTypesUp(arg.follow());
    case other:
      trace("other", other);
      throw "dead end 2?";
  }
}

static function extractObjFields(objExpr) {
  return switch Context.getTypedExpr(Context.typeExpr(objExpr)).expr {
    case EObjectDecl(inputFields):
      var inputFields = inputFields.copy();
      {fieldExprs: [for (f in inputFields) f.field => f.expr], inputFields: inputFields};

    case _:
      throw "Must be called with an anonymous object";
  }
}

static function objToTable(obj:Expr):Expr {
  return try {
    switch (obj.expr) {
      case EObjectDecl(fields):
        final objExpr:Expr = {
          expr: EObjectDecl([for (f in fields) {
            {
              field: f.field,
              expr: objToTable(f.expr)
            }
          }]),
          pos: obj.pos
        };
        macro lua.Table.create(null, $objExpr);
      case EArrayDecl(values):
        macro lua.Table.create(${ExprTools.map(obj, objToTable)}, null);
      case EFunction(kind, f):
        trace("function", kind, f);
        obj;
      case _:
        ExprTools.map(obj, objToTable);
    }
  }
  catch (e) {
    trace("Failed here:", obj.toString());
    obj;
  }
}
#end

@:from public static macro function fromExpr(ex:Expr):Expr {
  var expected = Context.getExpectedType();
  var complexType = expected.toComplexType();

  switch expected {
    case TAbstract(_, [_]) | TType(_, _):
      final fields = followTypesUp(expected);
      final x = extractObjFields(ex);
      final inputFields = x.inputFields;
      final fieldExprs = x.fieldExprs;

      var objFields:Array< ObjectField > = [for (f in fields) {
        final currentFieldExpression = fieldExprs.get(f.name);
        switch (f.type) {
          case _.toComplexType() => macro :Array< String > :{
            field:f.name,
            expr:macro
            lua.Table.create
            (${fieldExprs.get(f.name)})
          };

          case TAbstract(_.toString() => "TableWrapper", [_]):
            var ct = f.type.toComplexType();

            for (inf in inputFields) if (inf.field == f.name) {
              inf.expr = macro(TableWrapper.check(${inf.expr}) : $ct);
              break;
            }

            {field: f.name, expr: macro(TableWrapper.fromExpr(${fieldExprs.get(f.name)}) : $ct)};

          case TAnonymous(_):
            {field: f.name, expr: objToTable(fieldExprs.get(f.name))};
          // case TInst(_.get().name => "Array", [TAnonymous(_)]):
          //   trace(currentFieldExpression.toString());
          //   {
          //     field: f.name,
          //     expr: macro lua.Table.create(${ExprTools.map(currentFieldExpression, objToTable)})
          //   }

          case TAbstract(_, _) | TFun(_, _):
            {field: f.name, expr: (fieldExprs.get(f.name))};
          case _:
            {field: f.name, expr: objToTable(fieldExprs.get(f.name))};
        }
      }];

      var inputObj = {expr: EObjectDecl(inputFields), pos: ex.pos};
      var obj = {expr: EObjectDecl(objFields), pos: ex.pos};

      final name = '_dce${uniqueCount++}';
      return macro @:mergeBlock {
        // Type checking; should be removed by dce
        @:pos(ex.pos) final $name:$complexType = TableWrapper.check($inputObj);

        // Actual table creation
        (cast lua.Table.create(null, $obj) : $complexType);
      };

    case other:
      trace(complexType);
      // trace(followTypesUp(other));
      throw "TableWrapper<T> only works with anonymous objects";
  }
}
}
