// From"" https://try.haxe.org/#0D7f4371
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using Safety;
using haxe.macro.ComplexTypeTools;

var uniqueCount = 1;
#end

/**
  Generates a new array that does not contain duplicate values,
  giving preference to the leftmos elements.
 */
function uniqueValues< T >(array:Array< T >, indexer:(T) -> String) {
  final index = new haxe.ds.StringMap< Bool >();
  return [for (val in array) {
    final key = indexer(val);
    if (index.exists(key))
      continue;
    index.set(key, true);
    val;
  }];
}

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

public static function extractObjFields(objExpr) {
  return switch Context.getTypedExpr(Context.typeExpr(objExpr)).expr {
    case EObjectDecl(inputFields):
      var inputFields = inputFields.copy();
      {
        fieldExprs: [for (f in inputFields) f.field => f.expr],
        inputFields: inputFields
      };

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

      var generatedFields:Array< ObjectField > = [for (f in fields) {
        final currentFieldExpression = fieldExprs.get(f.name).or(macro $v{null});

        // trace("currentFieldExpression", currentFieldExpression);
        if (currentFieldExpression == null) {
          continue;
        }
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
            {field: f.name, expr: objToTable(currentFieldExpression)};

          case TAbstract(_, _) | TFun(_, _):
            {field: f.name, expr: (currentFieldExpression)};
          case _:
            {field: f.name, expr: objToTable(currentFieldExpression)};
        }
      }];

      // We merge the generated fields, which may include fields that are not present in the code
      // (in case of optional fields, for example)
      // with the real fields so the type checking is accurate and does not allow extra fields that
      // will be silently ignored otherwise
      final obj = {expr: EObjectDecl(generatedFields), pos: ex.pos};

      final inputObj = {
        expr: EObjectDecl(uniqueValues(inputFields.concat(generatedFields), f -> f.field)),
        pos: ex.pos
      };

      // trace("\n=========\n", complexType.toString());
      // trace("fields", inputFields);
      // trace("ex", ex);
      // trace("fieldExprs", fieldExprs);
      // trace("obj", obj);

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
