script_name('RouletteClicker')
script_author('James Hawk')
script_version("2.0")

local sampev = require "lib.samp.events"

local xCoord = 310
local yCoord = 415
local fRlt = true
local fOpen = false
local flag = false
local wTime=1800000

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand("rlt", function(arg)
		enabled = not enabled
		if enabled then
			sampAddChatMessage(string.format("[%s]: Activated", thisScript().name), 0x40FF40)
			fRlt = true
			fOpen = true
		else
			sampAddChatMessage(string.format("[%s]: Deactivated", thisScript().name), 0xFF4040)
			fRlt = false
			fOpen = false
		end
		local state = string.match(arg, "(%d+)")
		if tonumber(state) == 1 then
			flag = true
		elseif tonumber(state) == 0 then
			flag = false
		end
	end)
	
	sampRegisterChatCommand("rlt_r", function()
		sampAddChatMessage(string.format("[%s]: RELOADING",thisScript().name), 0x0000FF)
		thisScript():reload()
	end)
	
	while true do
		wait(0)
		if enabled and fOpen then
			wait(50)
			sampAddChatMessage(string.format("[%s]: Openning roulette", thisScript().name), 0xFFE4B5)
			sampSendChat("/invent")
			wait(3000) 
			if sampTextdrawIsExists(2112) then
				sampSendClickTextdraw(2112)
				wait(1400)
				if sampTextdrawIsExists(2201) and sampTextdrawIsExists(2203) then
					sampSendClickTextdraw(2201)
				end
			end
			wait(1000)
			if sampTextdrawIsExists(2113) then
				local data_td = sampTextdrawGetString(2113)
				if data_td ~= nil then
					wTime = string.match(data_td, "(%d+)%s+")
					wTime = tonumber(wTime)--+1
					wTime = wTime*60000
				else
					wTime = 7200000
				end				
			end
			wait(200)
			if sampTextdrawIsExists(2186) then
				sampSendClickTextdraw(2186)
			end
			fOpen = false
			rltTimer()
		end	
	end
end

function rltTimer()
	lua_thread.create(function()
		local rltTimer = os.clock()*1000 + wTime
		while fRlt and not fOpen do
			local remainingTime = math.floor((rltTimer - os.clock()*1000)/1000)
			local seconds = remainingTime%60
			local minutes = math.floor(remainingTime/60)%60
			local hours = math.floor(remainingTime/3600)%60
			if flag then
				if seconds >= 10 and minutes >= 10 then
					sampTextdrawCreate(45, "rlt "..hours..":"..minutes..":"..seconds, xCoord, yCoord)
				elseif seconds < 10 and minutes >= 10 then
					sampTextdrawCreate(45, "rlt "..hours..":"..minutes..":0"..seconds, xCoord, yCoord)
				elseif seconds < 10 and minutes < 10 then
					sampTextdrawCreate(45, "rlt "..hours..":0"..minutes..":0"..seconds, xCoord, yCoord)
				end
			end
			if seconds <= 0 and minutes <= 0 and hours <=0 then
				fRlt = false
				fOpen = true
			end
			wait(100)
		end
		fRlt = true
		if flag then sampTextdrawDelete(45) end
	end)
end
