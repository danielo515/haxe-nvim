local _hx_hidden = {__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true, __fields__=true, __name__=true}

_hx_array_mt = {
    __newindex = function(t,k,v)
        local len = t.length
        t.length =  k >= len and (k + 1) or len
        rawset(t,k,v)
    end
}

function _hx_is_array(o)
    return type(o) == "table"
        and o.__enum__ == nil
        and getmetatable(o) == _hx_array_mt
end



function _hx_tab_array(tab, length)
    tab.length = length
    return setmetatable(tab, _hx_array_mt)
end



function _hx_print_class(obj, depth)
    local first = true
    local result = ''
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            if first then
                first = false
            else
                result = result .. ', '
            end
            if _hx_hidden[k] == nil then
                result = result .. k .. ':' .. _hx_tostring(v, depth+1)
            end
        end
    end
    return '{ ' .. result .. ' }'
end

function _hx_print_enum(o, depth)
    if o.length == 2 then
        return o[0]
    else
        local str = o[0] .. "("
        for i = 2, (o.length-1) do
            if i ~= 2 then
                str = str .. "," .. _hx_tostring(o[i], depth+1)
            else
                str = str .. _hx_tostring(o[i], depth+1)
            end
        end
        return str .. ")"
    end
end

function _hx_tostring(obj, depth)
    if depth == nil then
        depth = 0
    elseif depth > 5 then
        return "<...>"
    end

    local tstr = _G.type(obj)
    if tstr == "string" then return obj
    elseif tstr == "nil" then return "null"
    elseif tstr == "number" then
        if obj == _G.math.POSITIVE_INFINITY then return "Infinity"
        elseif obj == _G.math.NEGATIVE_INFINITY then return "-Infinity"
        elseif obj == 0 then return "0"
        elseif obj ~= obj then return "NaN"
        else return _G.tostring(obj)
        end
    elseif tstr == "boolean" then return _G.tostring(obj)
    elseif tstr == "userdata" then
        local mt = _G.getmetatable(obj)
        if mt ~= nil and mt.__tostring ~= nil then
            return _G.tostring(obj)
        else
            return "<userdata>"
        end
    elseif tstr == "function" then return "<function>"
    elseif tstr == "thread" then return "<thread>"
    elseif tstr == "table" then
        if obj.__enum__ ~= nil then
            return _hx_print_enum(obj, depth)
        elseif obj.toString ~= nil and not _hx_is_array(obj) then return obj:toString()
        elseif _hx_is_array(obj) then
            if obj.length > 5 then
                return "[...]"
            else
                local str = ""
                for i=0, (obj.length-1) do
                    if i == 0 then
                        str = str .. _hx_tostring(obj[i], depth+1)
                    else
                        str = str .. "," .. _hx_tostring(obj[i], depth+1)
                    end
                end
                return "[" .. str .. "]"
            end
        elseif obj.__class__ ~= nil then
            return _hx_print_class(obj, depth)
        else
            local buffer = {}
            local ref = obj
            if obj.__fields__ ~= nil then
                ref = obj.__fields__
            end
            for k,v in pairs(ref) do
                if _hx_hidden[k] == nil then
                    _G.table.insert(buffer, _hx_tostring(k, depth+1) .. ' : ' .. _hx_tostring(obj[k], depth+1))
                end
            end

            return "{ " .. table.concat(buffer, ", ") .. " }"
        end
    else
        _G.error("Unknown Lua type", 0)
        return ""
    end
end

function _hx_error(obj)
    if obj.value then
        _G.print("runtime error:\n " .. _hx_tostring(obj.value));
    else
        _G.print("runtime error:\n " .. tostring(obj));
    end

    if _G.debug and _G.debug.traceback then
        _G.print(debug.traceback());
    end
end


local function _hx_obj_newindex(t,k,v)
    t.__fields__[k] = true
    rawset(t,k,v)
end

local _hx_obj_mt = {__newindex=_hx_obj_newindex, __tostring=_hx_tostring}

local function _hx_a(...)
  local __fields__ = {};
  local ret = {__fields__ = __fields__};
  local max = select('#',...);
  local tab = {...};
  local cur = 1;
  while cur < max do
    local v = tab[cur];
    __fields__[v] = true;
    ret[v] = tab[cur+1];
    cur = cur + 2
  end
  return setmetatable(ret, _hx_obj_mt)
end

local function _hx_e()
  return setmetatable({__fields__ = {}}, _hx_obj_mt)
end

local function _hx_o(obj)
  return setmetatable(obj, _hx_obj_mt)
end

local function _hx_new(prototype)
  return setmetatable({__fields__ = {}}, {__newindex=_hx_obj_newindex, __index=prototype, __tostring=_hx_tostring})
end

function _hx_field_arr(obj)
    res = {}
    idx = 0
    if obj.__fields__ ~= nil then
        obj = obj.__fields__
    end
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            res[idx] = k
            idx = idx + 1
        end
    end
    return _hx_tab_array(res, idx)
end

local _hxClasses = {}
local Int = _hx_e();
local Dynamic = _hx_e();
local Float = _hx_e();
local Bool = _hx_e();
local Class = _hx_e();
local Enum = _hx_e();

local _hx_exports = _hx_exports or {}
local Array = _hx_e()
local Lambda = _hx_e()
___Main_Main_Fields_ = _hx_e()
local Math = _hx_e()
local String = _hx_e()
local Std = _hx_e()
local StringTools = _hx_e()
local Test = _hx_e()
__haxe_Log = _hx_e()
__haxe_ds_Option = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()
__lua_PairTools = _hx_e()
__lua_StringMap = _hx_e()
__packer__Packer_Packer_Fields_ = _hx_e()
__plenary_Job = _G.require("plenary.job")
__vim__TableTools_TableTools_Fields_ = _hx_e()
__vim_FunctionOrString = _hx_e()
__vim__VimTypes_LuaArray_Impl_ = _hx_e()
local vimx = _hx_e()
__vim__Vimx_Vimx_Fields_ = _hx_e()

local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw
local _hx_pcall_default = {};
local _hx_pcall_break = {};

Array.new = function() 
  local self = _hx_new(Array.prototype)
  Array.super(self)
  return self
end
Array.super = function(self) 
  _hx_tab_array(self, 0);
end
Array.prototype = _hx_e();
Array.prototype.concat = function(self,a) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  local _g1 = 0;
  while (_g1 < a.length) do 
    local i = a[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.join = function(self,sep) 
  local tbl = ({});
  local _g_current = 0;
  while (_g_current < self.length) do 
    _g_current = _g_current + 1;
    _G.table.insert(tbl, Std.string(self[_g_current - 1]));
  end;
  do return _G.table.concat(tbl, sep) end
end
Array.prototype.pop = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[self.length - 1];
  self[self.length - 1] = nil;
  self.length = self.length - 1;
  do return ret end
end
Array.prototype.push = function(self,x) 
  self[self.length] = x;
  do return self.length end
end
Array.prototype.reverse = function(self) 
  local tmp;
  local i = 0;
  while (i < Std.int(self.length / 2)) do 
    tmp = self[i];
    self[i] = self[(self.length - i) - 1];
    self[(self.length - i) - 1] = tmp;
    i = i + 1;
  end;
end
Array.prototype.shift = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[0];
  if (self.length == 1) then 
    self[0] = nil;
  else
    if (self.length > 1) then 
      self[0] = self[1];
      _G.table.remove(self, 1);
    end;
  end;
  local tmp = self;
  tmp.length = tmp.length - 1;
  do return ret end
end
Array.prototype.slice = function(self,pos,_end) 
  if ((_end == nil) or (_end > self.length)) then 
    _end = self.length;
  else
    if (_end < 0) then 
      _end = _G.math.fmod((self.length - (_G.math.fmod(-_end, self.length))), self.length);
    end;
  end;
  if (pos < 0) then 
    pos = _G.math.fmod((self.length - (_G.math.fmod(-pos, self.length))), self.length);
  end;
  if ((pos > _end) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  end;
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = _end;
  while (_g < _g1) do 
    _g = _g + 1;
    ret:push(self[_g - 1]);
  end;
  do return ret end
end
Array.prototype.sort = function(self,f) 
  local i = 0;
  local l = self.length;
  while (i < l) do 
    local swap = false;
    local j = 0;
    local max = (l - i) - 1;
    while (j < max) do 
      if (f(self[j], self[j + 1]) > 0) then 
        local tmp = self[j + 1];
        self[j + 1] = self[j];
        self[j] = tmp;
        swap = true;
      end;
      j = j + 1;
    end;
    if (not swap) then 
      break;
    end;
    i = i + 1;
  end;
end
Array.prototype.splice = function(self,pos,len) 
  if ((len < 0) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  else
    if (pos < 0) then 
      pos = self.length - (_G.math.fmod(-pos, self.length));
    end;
  end;
  len = Math.min(len, self.length - pos);
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = pos + len;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    ret:push(self[i]);
    self[i] = self[i + len];
  end;
  local _g = pos + len;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    self[i] = self[i + len];
  end;
  self.length = self.length - len;
  do return ret end
end
Array.prototype.toString = function(self) 
  local tbl = ({});
  _G.table.insert(tbl, "[");
  _G.table.insert(tbl, self:join(","));
  _G.table.insert(tbl, "]");
  do return _G.table.concat(tbl, "") end
end
Array.prototype.unshift = function(self,x) 
  local len = self.length;
  local _g = 0;
  while (_g < len) do 
    _g = _g + 1;
    local i = _g - 1;
    self[len - i] = self[(len - i) - 1];
  end;
  self[0] = x;
end
Array.prototype.insert = function(self,pos,x) 
  if (pos > self.length) then 
    pos = self.length;
  end;
  if (pos < 0) then 
    pos = self.length + pos;
    if (pos < 0) then 
      pos = 0;
    end;
  end;
  local cur_len = self.length;
  while (cur_len > pos) do 
    self[cur_len] = self[cur_len - 1];
    cur_len = cur_len - 1;
  end;
  self[pos] = x;
end
Array.prototype.remove = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self[i] == x) then 
      local _g = i;
      local _g1 = self.length - 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local j = _g - 1;
        self[j] = self[j + 1];
      end;
      self[self.length - 1] = nil;
      self.length = self.length - 1;
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.contains = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    if (self[_g - 1] == x) then 
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.indexOf = function(self,x,fromIndex) 
  local _end = self.length;
  if (fromIndex == nil) then 
    fromIndex = 0;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        fromIndex = 0;
      end;
    end;
  end;
  local _g = fromIndex;
  while (_g < _end) do 
    _g = _g + 1;
    local i = _g - 1;
    if (x == self[i]) then 
      do return i end;
    end;
  end;
  do return -1 end
end
Array.prototype.lastIndexOf = function(self,x,fromIndex) 
  if ((fromIndex == nil) or (fromIndex >= self.length)) then 
    fromIndex = self.length - 1;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        do return -1 end;
      end;
    end;
  end;
  local i = fromIndex;
  while (i >= 0) do 
    if (self[i] == x) then 
      do return i end;
    else
      i = i - 1;
    end;
  end;
  do return -1 end
end
Array.prototype.copy = function(self) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.map = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(f(i));
  end;
  do return _g end
end
Array.prototype.filter = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    if (f(i)) then 
      _g:push(i);
    end;
  end;
  do return _g end
end
Array.prototype.iterator = function(self) 
  do return __haxe_iterators_ArrayIterator.new(self) end
end
Array.prototype.keyValueIterator = function(self) 
  do return __haxe_iterators_ArrayKeyValueIterator.new(self) end
end
Array.prototype.resize = function(self,len) 
  if (self.length < len) then 
    self.length = len;
  else
    if (self.length > len) then 
      local _g = len;
      local _g1 = self.length;
      while (_g < _g1) do 
        _g = _g + 1;
        self[_g - 1] = nil;
      end;
      self.length = len;
    end;
  end;
end

Lambda.new = {}
Lambda.find = function(it,f) 
  local v = it:iterator();
  while (v:hasNext()) do 
    local v = v:next();
    if (f(v)) then 
      do return v end;
    end;
  end;
  do return nil end;
end

___Main_Main_Fields_.new = {}
___Main_Main_Fields_.createSiblingFile = function() 
  local path = vim.fn.expand(_G.string.format("%s%s", "%", ":h"));
  vim.fn.expand(_G.string.format("%s%s", "%", ":t"));
  vim.ui.input(({completion = nil, prompt = "newFileName"}), function(filename) 
    vim.cmd(Std.string(Std.string(Std.string("e ") .. Std.string(path)) .. Std.string("/")) .. Std.string(filename));
  end);
end
___Main_Main_Fields_.add_missing_derive = function(toAdd) 
  local length = nil;
  local tab = __lua_PairTools.copy(vim.api.nvim_buf_get_lines(0, 0, -1, false));
  local length = length;
  local lines;
  if (length == nil) then 
    length = _hx_table.maxn(tab);
    if (length > 0) then 
      local head = tab[1];
      _G.table.remove(tab, 1);
      tab[0] = head;
      lines = _hx_tab_array(tab, length);
    else
      lines = _hx_tab_array({}, 0);
    end;
  else
    lines = _hx_tab_array(tab, length);
  end;
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = lines;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    local startIndex = nil;
    if (startIndex == nil) then 
      startIndex = 1;
    else
      startIndex = startIndex + 1;
    end;
    local r = _G.string.find(i, "#[derive(", startIndex, true);
    if ((function() 
      local _hx_1
      if ((r ~= nil) and (r > 0)) then 
      _hx_1 = r - 1; else 
      _hx_1 = -1; end
      return _hx_1
    end )() ~= -1) then 
      _g:push(i);
    end;
  end;
  local deriveLines = _g;
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < deriveLines.length) do 
    local line = deriveLines[_g1];
    _g1 = _g1 + 1;
    local idx = 1;
    local ret = _hx_tab_array({}, 0);
    while (idx ~= nil) do 
      local newidx = 0;
      if (#"derive(" > 0) then 
        newidx = _G.string.find(line, "derive(", idx, true);
      else
        if (idx >= #line) then 
          newidx = nil;
        else
          newidx = idx + 1;
        end;
      end;
      if (newidx ~= nil) then 
        ret:push(_G.string.sub(line, idx, newidx - 1));
        idx = newidx + #"derive(";
      else
        ret:push(_G.string.sub(line, idx, #line));
        idx = nil;
      end;
    end;
    local _this = ret[1];
    local idx = 1;
    local ret = _hx_tab_array({}, 0);
    while (idx ~= nil) do 
      local newidx = 0;
      if (#")" > 0) then 
        newidx = _G.string.find(_this, ")", idx, true);
      else
        if (idx >= #_this) then 
          newidx = nil;
        else
          newidx = idx + 1;
        end;
      end;
      if (newidx ~= nil) then 
        ret:push(_G.string.sub(_this, idx, newidx - 1));
        idx = newidx + #")";
      else
        ret:push(_G.string.sub(_this, idx, #_this));
        idx = nil;
      end;
    end;
    local content = ret[0];
    local idx = 1;
    local ret = _hx_tab_array({}, 0);
    while (idx ~= nil) do 
      local newidx = 0;
      if (#"," > 0) then 
        newidx = _G.string.find(content, ",", idx, true);
      else
        if (idx >= #content) then 
          newidx = nil;
        else
          newidx = idx + 1;
        end;
      end;
      if (newidx ~= nil) then 
        ret:push(_G.string.sub(content, idx, newidx - 1));
        idx = newidx + #",";
      else
        ret:push(_G.string.sub(content, idx, #content));
        idx = nil;
      end;
    end;
    local _g1 = _hx_tab_array({}, 0);
    local _g2 = 0;
    local _g3 = ret;
    while (_g2 < _g3.length) do 
      local i = _g3[_g2];
      _g2 = _g2 + 1;
      _g1:push(StringTools.trim(i));
    end;
    _g:push(_hx_o({__fields__={line=true,elements=true},line=line,elements=_g1}));
  end;
  local derives = _g;
  __haxe_Log.trace(derives, _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/Main.hx",lineNumber=46,className="_Main.Main_Fields_",methodName="add_missing_derive"}));
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = derives;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    if (not i.elements:contains(toAdd)) then 
      _g:push(i);
    end;
  end;
  local _g1 = _hx_tab_array({}, 0);
  local _g2 = 0;
  local _g = _g;
  while (_g2 < _g.length) do 
    local i = _g[_g2];
    _g2 = _g2 + 1;
    _g1:push(_hx_o({__fields__={line=true,elements=true},line=i.line,elements=i.elements:concat(_hx_tab_array({[0]=toAdd}, 1))}));
  end;
  local newDeriveList = _g1;
  __haxe_Log.trace(newDeriveList, _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/Main.hx",lineNumber=53,className="_Main.Main_Fields_",methodName="add_missing_derive"}));
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = lines;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    local x = _hx_tab_array({[0]=i}, 1);
    local match = Lambda.find(newDeriveList, (function(x) 
      do return function(y) 
        do return y.line == x[0] end;
      end end;
    end)(x));
    local tmp;
    if (match ~= nil) then 
      local newDerive = Std.string(Std.string("#[derive(") .. Std.string(match.elements:join(", "))) .. Std.string(")]");
      __haxe_Log.trace(newDerive, _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/Main.hx",lineNumber=58,className="_Main.Main_Fields_",methodName="add_missing_derive"}));
      tmp = newDerive;
    else
      tmp = x[0];
    end;
    _g:push(tmp);
  end;
  local newLines = _g;
  local ret = ({});
  local _g = 0;
  local _g1 = newLines.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local idx = _g - 1;
    ret[idx + 1] = newLines[idx];
  end;
  vim.api.nvim_buf_set_lines(0, 0, -1, false, ret);
end
___Main_Main_Fields_.main = function() 
  vim.api.nvim_create_user_command("HaxeCmd", function(args) 
    vim.pretty_print(args);
    vim.pretty_print(vim.spell.check("Hello bru! Hau are you?")[1][1]);
    vim.ui.select(({"a"}), ({prompt = "Pick one sexy option"}), function(choice,_) 
      vim.pretty_print(choice);
    end);
  end, ({bang = true, complete = Std.string("customlist,v:lua.") .. Std.string("require'packer'.plugin_complete"), desc = "Testing from haxe", force = true, nargs = 1, range = "%"}));
  vim.api.nvim_create_user_command("HaxeCmdCompletion", function(args) 
    vim.pretty_print(args);
    vim.pretty_print(vim.spell.check("Hello bru! Hau are you?")[1][1]);
    vim.ui.select(({"a"}), ({prompt = "Pick one sexy option"}), function(choice,_) 
      vim.pretty_print(choice);
    end);
  end, ({bang = true, complete = function(lead,full,x) 
    vim.pretty_print(lead, full, x);
    do return ({"afa","bea",Std.string(lead) .. Std.string("bro")}) end;
  end, desc = "Testing from haxe for completion callback", force = true, nargs = "*", range = "%"}));
  local tmp = __vim_FunctionOrString.Cb(function() 
    vim.pretty_print("Hello from axe", vim.fn.expand(_G.string.format("%s%s", "%", ":p")));
    do return true end;
  end);
  vimx.acmd("HaxeEvent", __vim__VimTypes_LuaArray_Impl_.from(_hx_tab_array({[0]="BufWritePost"}, 1)), "*.hx", "Created from haxe", tmp);
  local nargs = nil;
  vim.api.nvim_create_user_command("OpenInGh", function(args) 
    local _g = args.range;
    local tmp;
    if (_g) == 1 then 
      tmp = Std.string(":") .. Std.string(args.line1);
    elseif (_g) == 2 then 
      tmp = Std.string(Std.string(Std.string(":") .. Std.string(args.line1)) .. Std.string("-")) .. Std.string(args.line2);else
    tmp = ""; end;
    ___Main_Main_Fields_.openInGh(tmp);
  end, ({bang = false, complete = nil, desc = "Open the current file in github", force = true, nargs = nargs, range = true}));
  local nargs = nil;
  vim.api.nvim_create_user_command("CopyGhUrl", function(args) 
    local _g = args.range;
    local tmp;
    if (_g) == 1 then 
      tmp = Std.string(":") .. Std.string(args.line1);
    elseif (_g) == 2 then 
      tmp = Std.string(Std.string(Std.string(":") .. Std.string(args.line1)) .. Std.string("-")) .. Std.string(args.line2);else
    tmp = ""; end;
    ___Main_Main_Fields_.copyGhUrl(tmp);
  end, ({bang = false, complete = nil, desc = "Copy current file github URL", force = true, nargs = nargs, range = true}));
  vim.api.nvim_create_user_command("CopyMessagesToClipboard", function(args) 
    ___Main_Main_Fields_.copy_messages_to_clipboard(args.args);
  end, ({bang = false, complete = nil, desc = "Copy the n number of messages to clipboard", force = true, nargs = 1, range = true}));
  vim.api.nvim_create_user_command("AddMissingDerive", function(args) 
    ___Main_Main_Fields_.add_missing_derive(args.args);
  end, ({bang = false, complete = nil, desc = "Add a missing derive to the current file", force = true, nargs = 1, range = true}));
  vim.api.nvim_create_user_command("CreateSiblingFile", function(_) 
    ___Main_Main_Fields_.createSiblingFile();
  end, ({bang = false, complete = nil, desc = "Create a file next to the current one", force = true, nargs = 0, range = true}));
  vim.api.nvim_create_user_command("GetPluginVersion", function(args) 
    local version = __packer__Packer_Packer_Fields_.get_plugin_version(args.args);
    vim.pretty_print(version);
    vimx.copyToClipboard(version);
  end, ({bang = false, complete = nil, desc = "Gets the git version of a installed packer plugin", force = true, nargs = 1, range = true}));
  local nargs = nil;
  vim.api.nvim_create_user_command("Replace", function(_) 
    vim.cmd("normal! GVggP");
  end, ({bang = false, complete = nil, desc = "Replace the current buffer with the contents of the clipboard", force = true, nargs = nargs, range = true}));
  local nargs = nil;
  vim.api.nvim_create_user_command("Scratch", function(_) 
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(false, true));
  end, ({bang = false, complete = nil, desc = "creates a scratch buffer", force = true, nargs = nargs, range = true}));
  vim.keymap.set("n", "tl", ___Main_Main_Fields_.nexTab, ({desc = "Go to next tab", expr = false, silent = true}));
  vim.keymap.set("n", "<C-G>", function() 
    local _hx_1_outcome_status, _hx_1_outcome_value = _G.pcall(vim.cmd, "cnext");
    if (((function() 
      local _hx_2
      if (_hx_1_outcome_status) then 
      _hx_2 = __haxe_ds_Option.Some(_hx_1_outcome_value); else 
      _hx_2 = __haxe_ds_Option.None; end
      return _hx_2
    end )())[1] == 1) then 
      _hx_box_mr(_hx_table.pack(_G.pcall(vim.cmd, "cfirst")), {"status", "value"});
    end;
  end, ({desc = "Next error or go to first", expr = false, silent = true}));
  vim.keymap.set("n", "<C-S-G>", function() 
    local _hx_3_outcome_status, _hx_3_outcome_value = _G.pcall(vim.cmd, "cprev");
    if (((function() 
      local _hx_4
      if (_hx_3_outcome_status) then 
      _hx_4 = __haxe_ds_Option.Some(_hx_3_outcome_value); else 
      _hx_4 = __haxe_ds_Option.None; end
      return _hx_4
    end )())[1] == 1) then 
      _hx_box_mr(_hx_table.pack(_G.pcall(vim.cmd, "clast")), {"status", "value"});
    end;
  end, ({desc = "Prev error or go wrap to last", expr = false, silent = true}));
  vim.keymap.set("c", "<C-A>", "<Home>", ({desc = "Home in cmd", expr = false, silent = true}));
  vim.keymap.set("n", "<c-m-f>", ":FzfLua lines<cr>", ({desc = "Search in open files", expr = false, silent = true}));
  vim.keymap.set("n", "<leader>sl", ":FzfLua lines<cr>", ({desc = "Search [l]ines in open files", expr = false, silent = true}));
  vim.keymap.set("n", "<C-s>", ":%s/\\v", ({desc = "Search and replace whole file", expr = false, silent = true}));
  vim.keymap.set("n", "<M-Tab>", ":b#<cr>", ({desc = "Alternate file", expr = false, silent = true}));
  vim.o.inccommand = "split";
end
___Main_Main_Fields_.runGh = function(args) 
  if (vim.fn.executable("gh") ~= 1) then 
    do return nil end;
  end;
  local args = ({command = "gh", args = args, on_stderr = function(args,return_val) 
    vim.pretty_print("Job got stderr", args, return_val);
  end});
  do return __plenary_Job:new(args):sync() end;
end
___Main_Main_Fields_.openInGh = function(line) 
  ___Main_Main_Fields_.runGh(__vim__VimTypes_LuaArray_Impl_.from(_hx_tab_array({[0]="browse", Std.string(vim.fn.expand("%")) .. Std.string(line), "--branch", ___Main_Main_Fields_.get_branch()[1]}, 4)));
end
___Main_Main_Fields_.get_branch = function() 
  local args = ({command = "git", args = ({"rev-parse","--abbrev-ref","HEAD"}), on_stderr = function(args,return_val) 
    vim.pretty_print("Something may have  failed", args, return_val);
  end});
  do return __plenary_Job:new(args):sync() end;
end
___Main_Main_Fields_.copy_messages_to_clipboard = function(number) 
  vim.cmd(_G.string.format("let @* = execute('%smessages')", Test["or"](number, "")));
  vim.notify(Std.string(Std.string("") .. Std.string(number)) .. Std.string(" :messages copied to the clipboard"), "info");
end
___Main_Main_Fields_.nexTab = function() 
  local pages = vim.api.nvim_list_tabpages();
  local currentTab = vim.api.nvim_get_current_tabpage();
  vim.api.nvim_set_current_tabpage(Test["or"](__vim__TableTools_TableTools_Fields_.findNext(pages, function(id) 
    do return id == currentTab end;
  end), pages[1]));
end
___Main_Main_Fields_.copyGhUrl = function(line) 
  local lines = ___Main_Main_Fields_.runGh(__vim__VimTypes_LuaArray_Impl_.from(_hx_tab_array({[0]="browse", Std.string(vim.fn.expand(_G.string.format("%s%s", "%", ":."))) .. Std.string(line), "--no-browser", "--branch", ___Main_Main_Fields_.get_branch()[1]}, 5)));
  if (lines == nil) then 
    vim.pretty_print("No URL");
  else
    vim.pretty_print(lines[1]);
    vimx.copyToClipboard(lines[1]);
  end;
end
___Main_Main_Fields_.setup = function() 
  ___Main_Main_Fields_.main();
  vim.pretty_print("ran setup");
end
_hx_exports["setup"] = ___Main_Main_Fields_.setup

Math.new = {}
Math.isNaN = function(f) 
  do return f ~= f end;
end
Math.isFinite = function(f) 
  if (f > -_G.math.huge) then 
    do return f < _G.math.huge end;
  else
    do return false end;
  end;
end
Math.min = function(a,b) 
  if (Math.isNaN(a) or Math.isNaN(b)) then 
    do return (0/0) end;
  else
    do return _G.math.min(a, b) end;
  end;
end

String.new = function(string) 
  local self = _hx_new(String.prototype)
  String.super(self,string)
  self = string
  return self
end
String.super = function(self,string) 
end
String.__index = function(s,k) 
  if (k == "length") then 
    do return _G.string.len(s) end;
  else
    local o = String.prototype;
    local field = k;
    if ((function() 
      local _hx_1
      if ((_G.type(o) == "string") and ((String.prototype[field] ~= nil) or (field == "length"))) then 
      _hx_1 = true; elseif (o.__fields__ ~= nil) then 
      _hx_1 = o.__fields__[field] ~= nil; else 
      _hx_1 = o[field] ~= nil; end
      return _hx_1
    end )()) then 
      do return String.prototype[k] end;
    else
      if (String.__oldindex ~= nil) then 
        if (_G.type(String.__oldindex) == "function") then 
          do return String.__oldindex(s, k) end;
        else
          if (_G.type(String.__oldindex) == "table") then 
            do return String.__oldindex[k] end;
          end;
        end;
        do return nil end;
      else
        do return nil end;
      end;
    end;
  end;
end
String.indexOfEmpty = function(s,startIndex) 
  local length = _G.string.len(s);
  if (startIndex < 0) then 
    startIndex = length + startIndex;
    if (startIndex < 0) then 
      startIndex = 0;
    end;
  end;
  if (startIndex > length) then 
    do return length end;
  else
    do return startIndex end;
  end;
end
String.fromCharCode = function(code) 
  do return _G.string.char(code) end;
end
String.prototype = _hx_e();
String.prototype.toUpperCase = function(self) 
  do return _G.string.upper(self) end
end
String.prototype.toLowerCase = function(self) 
  do return _G.string.lower(self) end
end
String.prototype.indexOf = function(self,str,startIndex) 
  if (startIndex == nil) then 
    startIndex = 1;
  else
    startIndex = startIndex + 1;
  end;
  if (str == "") then 
    do return String.indexOfEmpty(self, startIndex - 1) end;
  end;
  local r = _G.string.find(self, str, startIndex, true);
  if ((r ~= nil) and (r > 0)) then 
    do return r - 1 end;
  else
    do return -1 end;
  end;
end
String.prototype.lastIndexOf = function(self,str,startIndex) 
  local ret = -1;
  if (startIndex == nil) then 
    startIndex = #self;
  end;
  while (true) do 
    local startIndex1 = ret + 1;
    if (startIndex1 == nil) then 
      startIndex1 = 1;
    else
      startIndex1 = startIndex1 + 1;
    end;
    local p;
    if (str == "") then 
      p = String.indexOfEmpty(self, startIndex1 - 1);
    else
      local r = _G.string.find(self, str, startIndex1, true);
      p = (function() 
        local _hx_1
        if ((r ~= nil) and (r > 0)) then 
        _hx_1 = r - 1; else 
        _hx_1 = -1; end
        return _hx_1
      end )();
    end;
    if (((p == -1) or (p > startIndex)) or (p == ret)) then 
      break;
    end;
    ret = p;
  end;
  do return ret end
end
String.prototype.split = function(self,delimiter) 
  local idx = 1;
  local ret = _hx_tab_array({}, 0);
  while (idx ~= nil) do 
    local newidx = 0;
    if (#delimiter > 0) then 
      newidx = _G.string.find(self, delimiter, idx, true);
    else
      if (idx >= #self) then 
        newidx = nil;
      else
        newidx = idx + 1;
      end;
    end;
    if (newidx ~= nil) then 
      ret:push(_G.string.sub(self, idx, newidx - 1));
      idx = newidx + #delimiter;
    else
      ret:push(_G.string.sub(self, idx, #self));
      idx = nil;
    end;
  end;
  do return ret end
end
String.prototype.toString = function(self) 
  do return self end
end
String.prototype.substring = function(self,startIndex,endIndex) 
  if (endIndex == nil) then 
    endIndex = #self;
  end;
  if (endIndex < 0) then 
    endIndex = 0;
  end;
  if (startIndex < 0) then 
    startIndex = 0;
  end;
  if (endIndex < startIndex) then 
    do return _G.string.sub(self, endIndex + 1, startIndex) end;
  else
    do return _G.string.sub(self, startIndex + 1, endIndex) end;
  end;
end
String.prototype.charAt = function(self,index) 
  do return _G.string.sub(self, index + 1, index + 1) end
end
String.prototype.charCodeAt = function(self,index) 
  do return _G.string.byte(self, index + 1) end
end
String.prototype.substr = function(self,pos,len) 
  if ((len == nil) or (len > (pos + #self))) then 
    len = #self;
  else
    if (len < 0) then 
      len = #self + len;
    end;
  end;
  if (pos < 0) then 
    pos = #self + pos;
  end;
  if (pos < 0) then 
    pos = 0;
  end;
  do return _G.string.sub(self, pos + 1, pos + len) end
end

Std.new = {}
Std.string = function(s) 
  do return _hx_tostring(s, 0) end;
end
Std.int = function(x) 
  if (not Math.isFinite(x) or Math.isNaN(x)) then 
    do return 0 end;
  else
    do return _hx_bit_clamp(x) end;
  end;
end

StringTools.new = {}
StringTools.isSpace = function(s,pos) 
  if (((#s == 0) or (pos < 0)) or (pos >= #s)) then 
    do return false end;
  end;
  local c = _G.string.byte(s, pos + 1);
  if (not ((c > 8) and (c < 14))) then 
    do return c == 32 end;
  else
    do return true end;
  end;
end
StringTools.ltrim = function(s) 
  local l = #s;
  local r = 0;
  while ((r < l) and StringTools.isSpace(s, r)) do 
    r = r + 1;
  end;
  if (r > 0) then 
    local pos = r;
    local len = l - r;
    if ((len == nil) or (len > (pos + #s))) then 
      len = #s;
    else
      if (len < 0) then 
        len = #s + len;
      end;
    end;
    if (pos < 0) then 
      pos = #s + pos;
    end;
    if (pos < 0) then 
      pos = 0;
    end;
    do return _G.string.sub(s, pos + 1, pos + len) end;
  else
    do return s end;
  end;
end
StringTools.rtrim = function(s) 
  local l = #s;
  local r = 0;
  while ((r < l) and StringTools.isSpace(s, (l - r) - 1)) do 
    r = r + 1;
  end;
  if (r > 0) then 
    local len = l - r;
    if ((len == nil) or (len > #s)) then 
      len = #s;
    else
      if (len < 0) then 
        len = #s + len;
      end;
    end;
    do return _G.string.sub(s, 1, len) end;
  else
    do return s end;
  end;
end
StringTools.trim = function(s) 
  do return StringTools.ltrim(StringTools.rtrim(s)) end;
end

Test.new = {}
Test["or"] = function(v,fallback) 
  if (v ~= nil) then 
    do return v end;
  else
    do return fallback end;
  end;
end

__haxe_Log.new = {}
__haxe_Log.formatOutput = function(v,infos) 
  local str = Std.string(v);
  if (infos == nil) then 
    do return str end;
  end;
  local pstr = Std.string(Std.string(infos.fileName) .. Std.string(":")) .. Std.string(infos.lineNumber);
  if (infos.customParams ~= nil) then 
    local _g = 0;
    local _g1 = infos.customParams;
    while (_g < _g1.length) do 
      local v = _g1[_g];
      _g = _g + 1;
      str = Std.string(str) .. Std.string((Std.string(", ") .. Std.string(Std.string(v))));
    end;
  end;
  do return Std.string(Std.string(pstr) .. Std.string(": ")) .. Std.string(str) end;
end
__haxe_Log.trace = function(v,infos) 
  local str = __haxe_Log.formatOutput(v, infos);
  _hx_print(str);
end

__haxe_ds_Option.Some = function(v) local _x = _hx_tab_array({[0]="Some",0,v,__enum__=__haxe_ds_Option}, 3); return _x; end 
__haxe_ds_Option.None = _hx_tab_array({[0]="None",1,__enum__ = __haxe_ds_Option},2)


__haxe_iterators_ArrayIterator.new = function(array) 
  local self = _hx_new(__haxe_iterators_ArrayIterator.prototype)
  __haxe_iterators_ArrayIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayIterator.super = function(self,array) 
  self.current = 0;
  self.array = array;
end
__haxe_iterators_ArrayIterator.prototype = _hx_e();
__haxe_iterators_ArrayIterator.prototype.hasNext = function(self) 
  do return self.current < self.array.length end
end
__haxe_iterators_ArrayIterator.prototype.next = function(self) 
  do return self.array[(function() 
  local _hx_obj = self;
  local _hx_fld = 'current';
  local _ = _hx_obj[_hx_fld];
  _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
   return _;
   end)()] end
end

__haxe_iterators_ArrayKeyValueIterator.new = function(array) 
  local self = _hx_new()
  __haxe_iterators_ArrayKeyValueIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayKeyValueIterator.super = function(self,array) 
  self.array = array;
end

__lua_PairTools.new = {}
__lua_PairTools.copy = function(table1) 
  local ret = ({});
  for k,v in _G.pairs(table1) do ret[k] = v end;
  do return ret end;
end

__lua_StringMap.new = function() 
  local self = _hx_new(__lua_StringMap.prototype)
  __lua_StringMap.super(self)
  return self
end
__lua_StringMap.super = function(self) 
  self.h = ({});
end
__lua_StringMap.prototype = _hx_e();
__lua_StringMap.prototype.set = function(self,key,value) 
  if (value == nil) then 
    self.h[key] = __lua_StringMap.tnull;
  else
    self.h[key] = value;
  end;
end
__lua_StringMap.prototype.get = function(self,key) 
  local ret = self.h[key];
  if (ret == __lua_StringMap.tnull) then 
    do return nil end;
  end;
  do return ret end
end

__packer__Packer_Packer_Fields_.new = {}
__packer__Packer_Packer_Fields_.get_plugin_version = function(name) 
  if (_G.packer_plugins ~= nil) then 
    local args = ({command = "git", cwd = _G.packer_plugins[name].path, args = ({"rev-parse","--short","HEAD"}), on_stderr = function(args,return_val) 
      vim.pretty_print("Job got stderr", args, return_val);
    end});
    do return __plenary_Job:new(args):sync()[1] end;
  else
    do return "unknown" end;
  end;
end

__vim__TableTools_TableTools_Fields_.new = {}
__vim__TableTools_TableTools_Fields_.findNext = function(table,fn) 
  local _hx_1_p_next, _hx_1_p_table, _hx_1_p_index = _G.ipairs(table);
  local next = _hx_1_p_next;
  local t = _hx_1_p_table;
  local loop = nil;
  loop = function(next,table,nextP) 
    local _hx_continue_1 = false;
    while (true) do repeat 
      if (fn(nextP.value)) then 
        do return _G.select(2, next(table, nextP.index)) end;
      else
        nextP = _hx_box_mr(_hx_table.pack(next(table, nextP.index)), {"index", "value"});
        break;
      end;until true
      if _hx_continue_1 then 
      _hx_continue_1 = false;
      break;
      end;
      
    end;
  end;
  do return loop(next, t, _hx_box_mr(_hx_table.pack(next(t, _hx_1_p_index)), {"index", "value"})) end;
end

__vim_FunctionOrString.Cb = function(cb) local _x = _hx_tab_array({[0]="Cb",0,cb,__enum__=__vim_FunctionOrString}, 3); return _x; end 
__vim_FunctionOrString.Str = function(cmd) local _x = _hx_tab_array({[0]="Str",1,cmd,__enum__=__vim_FunctionOrString}, 3); return _x; end 

__vim__VimTypes_LuaArray_Impl_.new = {}
__vim__VimTypes_LuaArray_Impl_.from = function(arr) 
  local ret = ({});
  local _g = 0;
  local _g1 = arr.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local idx = _g - 1;
    ret[idx + 1] = arr[idx];
  end;
  do return ret end;
end

vimx.new = {}
_hx_exports["vimx"] = vimx
vimx.acmd = function(groupName,events,pattern,description,cb) 
  local group;
  local _g = vimx.autogroups:get(groupName);
  if (_g == nil) then 
    group = vim.api.nvim_create_augroup(groupName, ({clear = true}));
    vimx.autogroups:set(groupName, group);
  else
    group = _g;
  end;
  local this1 = ({pattern = pattern, group = group, desc = (function() 
    local _hx_1
    if (description == nil) then 
    _hx_1 = Std.string(Std.string(Std.string(Std.string("") .. Std.string(groupName)) .. Std.string(":[")) .. Std.string(pattern)) .. Std.string("]"); else 
    _hx_1 = description; end
    return _hx_1
  end )(), once = false, nested = false});
  local tmp = cb[1];
  if (tmp) == 0 then 
    this1.callback = cb[2];
  elseif (tmp) == 1 then 
    this1.command = cb[2]; end;
  vim.api.nvim_create_autocmd(events, this1);
end
vimx.autocmd = function(groupName,events,pattern,description,cb) 
  vimx.acmd(groupName, events, pattern, description, __vim_FunctionOrString.Cb(cb));
end
vimx.autocmdStr = function(groupName,events,pattern,description,command) 
  vimx.acmd(groupName, events, pattern, description, __vim_FunctionOrString.Str(command));
end
vimx.copyToClipboard = function(str) 
  vim.cmd(Std.string(Std.string("let @* = \"") .. Std.string(str)) .. Std.string("\""));
  vim.notify("Copied to clipboard", "info");
end
vimx.linesInCurrentWindow = function() 
  do return vim.fn.line("$", 0) end;
end
vimx.firstLineVisibleCurrentWindow = function() 
  do return vim.fn.line("w0", 0) end;
end
vimx.lastLineVisibleCurrentWindow = function() 
  do return vim.fn.line("w$", 0) end;
end
vimx.join_paths = function(paths) 
  do return paths:join(__vim__Vimx_Vimx_Fields_.pathSeparator) end;
end
vimx.file_exists = function(path) 
  if (vim.fn.filereadable(path) == 1) then 
    do return true end;
  else
    do return false end;
  end;
end
vimx.read_json_file = function(path) 
  if (vimx.file_exists(path)) then 
    do return vim.fn.json_decode(_G.table.concat(vim.fn.readfile(path))) end;
  else
    do return nil end;
  end;
end
vimx.cmd = function(command) 
  local _hx_1_outcome_status, _hx_1_outcome_value = _G.pcall(vim.cmd, command);
  if (_hx_1_outcome_status) then 
    do return __haxe_ds_Option.Some(_hx_1_outcome_value) end;
  else
    do return __haxe_ds_Option.None end;
  end;
end
vimx.safeRequire = function(name) 
  local _hx_1_module_status, _hx_1_module_value = _G.pcall(_G.require, name);
  if (_hx_1_module_status) then 
    do return _hx_1_module_value end;
  else
    do return nil end;
  end;
end

__vim__Vimx_Vimx_Fields_.new = {}
if _hx_bit_raw then
    _hx_bit_clamp = function(v)
    if v <= 2147483647 and v >= -2147483648 then
        if v > 0 then return _G.math.floor(v)
        else return _G.math.ceil(v)
        end
    end
    if v > 2251798999999999 then v = v*2 end;
    if (v ~= v or math.abs(v) == _G.math.huge) then return nil end
    return _hx_bit_raw.band(v, 2147483647 ) - math.abs(_hx_bit_raw.band(v, 2147483648))
    end
else
    _hx_bit_clamp = function(v)
        if v < -2147483648 then
            return -2147483648
        elseif v > 2147483647 then
            return 2147483647
        elseif v > 0 then
            return _G.math.floor(v)
        else
            return _G.math.ceil(v)
        end
    end
end;



_hx_array_mt.__index = Array.prototype

local _hx_static_init = function()
  __lua_StringMap.tnull = ({});
  
  vimx.autogroups = __lua_StringMap.new();
  
  __vim__Vimx_Vimx_Fields_.pathSeparator = (function() 
    local _hx_1
    if (vim.loop.os_uname().sysname == "Windows") then 
    _hx_1 = "\\"; else 
    _hx_1 = "/"; end
    return _hx_1
  end )();
  
  
end

_hx_print = print or (function() end)

_hx_box_mr = function(x,nt)
    res = _hx_o({__fields__={}})
    for i,v in ipairs(nt) do
      res[v] = x[i]
    end
    return res
end

_hx_table = {}
_hx_table.pack = _G.table.pack or function(...)
    return {...}
end
_hx_table.unpack = _G.table.unpack or _G.unpack
_hx_table.maxn = _G.table.maxn or function(t)
  local maxn=0;
  for i in pairs(t) do
    maxn=type(i)=='number'and i>maxn and i or maxn
  end
  return maxn
end;

_hx_static_init();
_G.xpcall(___Main_Main_Fields_.main, _hx_error)
return _hx_exports
