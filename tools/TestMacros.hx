import TableWrapper;

typedef X = {
  doX:Int,
  test:Bool,
  nest:{a:{renest:Int, b:{c:{meganest:Int}}}},
  objWithArr:{x:Array< {y:String} >},
  arrWithObjs:Array< {x:String} >
};

typedef W = TableWrapper< X >;
extern function testMethod(x:W):Void;

function doY() {
  testMethod({
    doX: 99,
    test: true,
    objWithArr: {x: [{y: "obj -> array -> obj "}, {y: "second obj -> array -> obj "}]},
    nest: {a: {renest: 99, b: {c: {meganest: 88}}}},
    arrWithObjs: [{x: "inside array -> obj "}, {x: "second array -> obj "}],
  });
}
