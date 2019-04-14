script_name('RouletteClicker')
script_author('James Hawk')

local xCoord = 310
local yCoord = 415
local fRlt = true
local fOpen = false
local flag = false
wTime=1800000

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
		state = string.match(arg, "(%d+)")
		if tonumber(state) == 1 then
			flag = true
			--sampAddChatMessage(string.format("[%s]: Timer will be activated", thisScript().name), 0xFFE4B5)
		elseif tonumber(state) == 0 then
			flag = false
			--sampAddChatMessage(string.format("[%s]: Timer will be deactivated", thisScript().name), 0xFFE4B5)
		end
		return {arg}
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
			wait(2500) 
			if sampTextdrawIsExists(2112) then
				sampSendClickTextdraw(2112)
				wait(1400)
				if sampTextdrawIsExists(2197) and sampTextdrawIsExists(2199) then
					sampSendClickTextdraw(2197)
				end
			end
			wait(400)
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
			local seconds = remainingTime % 60
			local minutes = math.floor(remainingTime / 60)
			if flag then
				if seconds >= 10 then
					sampTextdrawCreate(16, "rlt " .. minutes .. ":" .. seconds, xCoord, yCoord)
				else
					sampTextdrawCreate(16, "rlt " ..  minutes .. ":0" .. seconds, xCoord, yCoord)
				end
			end
			if seconds <= 0 and minutes <= 0 then
				fRlt = false
				fOpen = true
			end
			wait(100)
		end
		fRlt = true
		if flag then sampTextdrawDelete(16) end
	end)
end
