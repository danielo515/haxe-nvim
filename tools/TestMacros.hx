import TableWrapper;

typedef X = {
  doX:Int,
  test:Bool,
  nest:{a:{renest:Int, b:{c:{meganest:Int}}}},
  objWithArr:{x:Array< {y:String} >},
  arrWithObjs:Array< {x:String} >,
  ?optionalField:Bool,
};

typedef WithLambdas = TableWrapper< {
  lambda1:(name:String, age:Int) -> Void,
  nestedLambda:{lambda2:(Int, Int) -> Int}
} >

extern function log(arg:Dynamic):Void;
typedef W = TableWrapper< X >;
extern function testMethod(x:W):Void;
extern function testlambdas(x:WithLambdas):Void;

function lotOfNesting() {
  testMethod({
    doX: 99,
    test: true,
    objWithArr: {x: [{y: "obj -> array -> obj "}, {y: "second obj -> array -> obj "}]},
    nest: {a: {renest: 99, b: {c: {meganest: 88}}}},
    arrWithObjs: [{x: "inside array -> obj "}, {x: "second array -> obj "}],
    optionalField: true,
  });
}

function objectWithLambdas() {
  testlambdas({
    lambda1: (name:String, age:Int) -> {
      Sys.println('Hello $name, good age $age');
    },
    nestedLambda: {lambda2: (a, b) -> (a + b)}
  });
}
