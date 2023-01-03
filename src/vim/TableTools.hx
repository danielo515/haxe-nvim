package vim;

import vim.VimTypes.LuaArray;
import lua.Table;

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
