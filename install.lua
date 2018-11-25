local shell = require("shell");

local args = {...};
local installDir = "";
if args[1] then
    installDir = args[1];
end


shell.execute('rm ' .. installDir .. '/usr/lib/import.lua');
shell.execute('cp -r ./lib/* ' .. installDir .. '/usr/lib/');

shell.execute('rm ' .. installDir .. '/boot/04_import.lua');
shell.execute('cp -r ./boot/* ' .. installDir .. '/boot/');