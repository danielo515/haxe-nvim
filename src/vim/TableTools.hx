package vim;

import vim.VimTypes.LuaArray;
import lua.Table;
import lua.Lua;

/**
  This is a collection of helpers to work with lua tables
  in a more comfortable way.
  This functions has a more functional focus, avoiding mutating the 
  tables whenever possible.
  It is designed to be used as a static extensions module
 */
/**
  Joins all the values of a table with the provided separator.
  This is an alias for the less obvious concat of plain lua
 */
final join = lua.Table.concat;

/**
  Concatenates two tables creating a new table that contains the values of both
 */
function concat< T >(tableA:LuaArray< T >, tableB:LuaArray< T >):LuaArray< T > {
  final result = Vim.list_extend(Table.create(), tableA);
  return Vim.list_extend(result, tableB);
}

inline function pairs< T >(table:LuaArray< T >) {
  return lua.PairTools.ipairsIterator(table);
}

function findNext< T >(table:LuaArray< T >, fn:T -> Bool):Null< T > {
  final p = Lua.ipairs(table);
  final next = p.next;
  final t = p.table;
  function loop(next, table, nextP:NextResult< Int, T >) {
    return if (fn(
      nextP.value
    ))next(table, nextP.index).value else loop(next, table, next(table, nextP.index));
  }
  return loop(next, t, next(t, p.index));
}
