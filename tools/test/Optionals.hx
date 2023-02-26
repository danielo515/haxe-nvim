package tools.test;

import TableWrapper;

typedef X = TableWrapper< {
  test:Bool,
  ?optionalField:Bool,
} >;

function test(x:X) {
  return x;
}

// All these should compile and lead to the same compiled output

@:keep
final a = test({test: true,});

@:keep
final b = test({test: true, optionalField: true});

@:keep
final c = test({test: true, optionalField: null});

// This should all fail!!

@:keep
// final d = test({test: true, optionalField: "null"});
@:keep
final e = test({test: true, weirdField: "null"});
