--[[
MIT License

Copyright (c) 2020 Martin Hassman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local addonName, NS = ...;
local C = NS.C;


SLASH_LFMQW1 = "/lfmqw";
SLASH_LFMQW2 = "/lfmq";
NS.mainSlashCmd = SLASH_LFMQW1;

SlashCmdList["LFMQW"] = function(msg)
	local msg = string.lower(msg);

	if msg == "" or msg =="help" then
		NS.printUsage();
	elseif msg == "debug" then
		NS.settings.debug = true;
		print(NS.msgPrefix, "Debug is on.");
	elseif msg == "nodebug" then
		NS.settings.debug = false;
		print(NS.msgPrefix, "Debug is off.");
	elseif msg == "debug?" then
		print(NS.msgPrefix, "debug=", NS.settings.debug);
	elseif msg == "clear" then
		NS.clear();
		print(NS.msgPrefix, "Cleared.");		
	else
		print("Unknown parameter:", msg);
	end
end


function NS.printUsage()
		print(C.Yellow, addonName, "usage:");
		print(C.Yellow, NS.mainSlashCmd, "help -- this message");
		print(C.Yellow, NS.mainSlashCmd, "debug -- set debug on");
		print(C.Yellow, NS.mainSlashCmd, "nodebug -- set debug off");
		print(C.Yellow, NS.mainSlashCmd, "debug? -- show current debug state");
		print(C.Yellow, NS.mainSlashCmd, "clear -- clear data broker ouput");
end

function NS.clear()
		NS.updateBrokerText("");
end