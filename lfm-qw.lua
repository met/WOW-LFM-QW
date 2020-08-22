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

-- true if unitName is in group/party together with current player
function NS.isUnitInPlayerGroup(unitName)

	for i = 1, GetNumGroupMembers() do -- probably can end with GetNumGroupMembers()-1. Looks UnitName("party"..i) do not involve current player
									   -- so last member here is nil
									   -- need to study this more. but if we check for nil, nothing bad can happen here
		local groupMemberName = UnitName("party"..i);

		if groupMemberName ~= nil and groupMemberName == unitName then
			return true;
		end
	end

	return false;
end
