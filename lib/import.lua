

local originalIncludePath = package.path

local clearBlacklist = {
  ["_G"] = true,
  ["bit32"] = true,
  ["coroutine"] = true,
  ["math"] = true,
  ["os"] = true,
  ["package"] = true,
  ["string"] = true,
  ["table"] = true,
  buffer = true,
  colors = true,
  internet = true,
  io = true,
  keyboard = true,
  note = true,
  pipe = true,
  process = true,
  rc = true,
  serialization = true,
  sh = true,
  shell = true,
  sides = true,
  term = true,
  text = true,
  transforms = true,
  tty = true,
  uuid = true,
  vt100 = true,
  event = true,
  unicode = true,
  component = true,
  thread = true,
  import = true
}


local clearable = {};

local Import = {};


function Import.__load(module)
  if module:sub(1, 1) == "." then
    local fs = require("filesystem")
    local lvl = 1;
    local found = nil;

    while not found do
      local source = debug.getinfo(lvl).source
      lvl = lvl + 1;
      if source == "=/usr/lib/import.lua" then
        found = debug.getinfo(lvl).source
      end
    end
    local basePath = fs.path(debug.getinfo(lvl).source:sub(2))
    module = fs.concat(basePath, module)
  end

  local preventClear = clearBlacklist[module];
  local imported;
  if module:sub(1, 1) == "/" then
    package.path = "?.lua"
    imported = require(module)
    package.path = originalIncludePath
  else
    package.path = originalIncludePath
    imported = require(module)
  end
  if not preventClear then
    clearable[module] = true
  end
  return imported;
end

function Import.clearCache()
  for k, _ in pairs(clearable) do
    package.loaded[k] = nil;
  end
end

setmetatable(Import, {
    __call = function(self, module)
      return self.__load(module);
    end
});

_G.import = Import;

return Import

--[[

  do
    _G.importDevMode = {
      enabled = false
    };
  end
  local oPath = package.path;
  
  function import(module)
    package.path = oPath;
    if module:sub(1, 1) == "." then
      local fs = require("filesystem")
      local basePath = fs.path(debug.getinfo(3).source:sub(2))
      module = fs.concat(basePath, module)
    end
    local imported;
    if module:sub(1, 1) == "/" then
      package.path = "?.lua"
      imported = require(module);
      if importDevMode.enabled then
        package.loaded[module] = nil
      end
    else
      imported = require(module)
    end
    
    package.path = oPath;
    return imported
  end
  ]]