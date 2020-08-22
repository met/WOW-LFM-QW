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

local frame = CreateFrame("FRAME");
local events = {};

local function setDefaultSettings(setts)
	setts.debug = false;
end

function events.ADDON_LOADED(...)
	local arg1 = select(1, ...);

	-- ADDON_LOADED event is raised for every running addon,
	-- 1st argument contains that addon name
	-- we response only for our addon call and ignore the others
	if arg1 ~= addonName then
		return;
	end

	print(NS.msgPrefix.."version "..GetAddOnMetadata(addonName, "version")..". Use "..NS.mainSlashCmd.." for help");

	if LFMQWSharedData == nil then LFMQWSharedData = {} end;
	if LFMQWData       == nil then LFMQWData       = {} end;
	if LFMQWSettings   == nil then LFMQWSettings   = {}; setDefaultSettings(LFMQWSettings); end;

	NS.sharedData = LFMQWSharedData;
	NS.data       = LFMQWData;
	NS.settings   = LFMQWSettings;


	-- checking chat messages
	frame:RegisterEvent("CHAT_MSG_CHANNEL");
	-- checking quest log changes
	frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
	frame:RegisterEvent("QUEST_LOG_UPDATE");	
end


-- Call event handlers or log error for unknow events
function frame:OnEvent(event, ...)
	if events[event] ~= nil then
		events[event](...);
	else
		NS.logError("Received unhandled event:", event, ...);
	end
end

frame:SetScript("OnEvent", frame.OnEvent);
frame:RegisterEvent("ADDON_LOADED");

-- Event for all messages in all chat channels. https://wow.gamepedia.com/CHAT_MSG_CHANNEL
-- But not for other msg sources, not for guild chats, not for party chat, not for yelling etc.
-- There are many others CHAT_MSG_* like CHAT_MSG_SAY, CHAT_MSG_YELL, CHAT_MSG_WHISPER, CHAT_MSG_MONSTER_SAY, CHAT_MSG_PARTY etc
function events.CHAT_MSG_CHANNEL(...)
	local text, _, _, channelName, playerName = ...;
	text = string.lower(text); -- lowecase message, we store all questnames lowecased for better matching

	-- now check text for names of my quests
	for i, questName in ipairs(NS.questNames) do
		local found = string.find(text, questName);  -- what about special characters in questName? Can we detect them, escape them?
		local ignore = false;

		-- Check is message is not from current player, ignore such messages
		if playerName ~= nill and playerName == UnitName("player") then
			ignore = true;
		end
		-- TODO should check playerName if it is not someone from his party or someone on ignore list?
		                                           
		if found and not ignore then
			print(C.Green1, "===================================");
			print(C.Red,    "===================================");
			print(C.Red, "Someone is looking for group for quest in your quest log", questName);
			print(channelName, ":", playerName, ":", text);
			PlaySound(3338); -- BullWhip, TODO can find some better sound later, or make setting for player to change this
			                 -- sound list https://classic.wowhead.com/sounds 
			                 -- SOUNDKIT.* sound constants

			NS.updateBrokerText(playerName);
		end
	end
end


NS.questNames = {};

-- update quest names from quest log
function events.UNIT_QUEST_LOG_CHANGED(...)
	NS.questNames = NS.getQuestLogNames();
end

function events.QUEST_LOG_UPDATE(...)
	NS.questNames = NS.getQuestLogNames();
end

-- get names of all quests in quest log
function NS.getQuestLogNames()
	local questNames = {};
	for i = 1, GetNumQuestLogEntries() do
			-- https://wow.gamepedia.com/API_GetQuestLogTitle
			local questTitle, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(i);
			if isHeader == false then
				-- Quest in Quest Log
				table.insert(questNames, string.lower(questTitle));
				--print(i, questTitle, questID);
			end
	end

	return questNames;
end
