local shell = require("shell");
shell.execute('rm /usr/lib/import.lua');
shell.execute('cp -r ./lib/* /usr/lib/');

shell.execute('rm /boot/04_import.lua');
shell.execute('cp -r ./boot/* /boot/');