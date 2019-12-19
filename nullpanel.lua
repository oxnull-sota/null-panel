--[[
   Author: Ox Null
   Please feel free to modify or use this code how you see fit.
   Current version is not organized or optimized with more features beeing add in future version.
]]--

moveAble = false
moveAbleX = false
moveMenu = false
showMenu = true
totalWeight = 0.0
y = 0
x = 0
init = false
showAttun = true
multiColor = true
time = os.time()
text = ""
sync = false
screenW = 0
screenH = 0
charName = ""

function ShroudOnStart()
   ShroudConsoleLog("[ff0000]Null Panel:[-]")      
   ShroudConsoleLog("[00e600]----------")   
   ShroudConsoleLog("Thank you for using Null Panel [b]>:D[/b]")
   ShroudConsoleLog("Here are a few commands:[-]")
   ShroudConsoleLog("[ff3333]!np[-] (brings up menu), [ff3333]!list[-] (lists all stats greater than 0), [ff3333]!add #[-] (adds stat number to panel list), [ff3333]!remove #[-](remove stat in slot #)")
   ShroudConsoleLog("[00e600]More to come in future versions.")
   ShroudConsoleLog("----------[-]")      
end

function ShroudOnConsoleInput(type, source, message)
   if type == 'Local' and source == charName then
      if (string.match(message, "!np") or string.match(message, "!nullpanel") or string.match(message, "!config")) then
	 if showMenu then
	    showMenu = false
	 else
	    showMenu = true
	 end

      elseif string.match(message, "!list") or string.match(message, "!show") or string.match(message, "!stats") then
	 showStats()

      elseif string.match(message, "%d+") and string.match(message, "!add") then
	 local value = tonumber(string.match(message, "%d+"))
	 addList(panelList, (value))	 

      elseif string.match(message, "%d+") and (string.match(message, "!remove") or string.match(message, "!delete")) then
	 local value = tonumber(string.match(message, "%d+"))
	 removeList(panelList, (value))	 

      elseif string.match(message, "!help") or string.match(message, "!?") then
	 ShroudConsoleLog("[ff0000]Null Panel:[-]")      	 
      	 ShroudConsoleLog("[00e600]----------[-]")   	 
      	 ShroudConsoleLog("[00e600]Here are a few commands: [-][ff3333]!np[-] (brings up menu), [ff3333]!list[-] (lists all stats greater than 0) [ff3333]!add #[-] (adds stat number to panel list), [ff3333]!remove #[-](remove stat in slot #)")
      	 ShroudConsoleLog("[00e600]More to come in future versions.")
      	 ShroudConsoleLog("----------[-]")      	 
      end                  
   end
end

function ShroudOnUpdate()
   local localTime = os.time()
   if not init then
      if not ShroudServerTime then return end
      init = true
      setAssets()
      attunList = {}
      -- default panel stats, change if you want your own defaults upon reload
      panelList = {500,501,14,27,8,16,17,22,46,32}
      setAttunList()
      totalWeight = getInvetoryWeight()
      screenW = ShroudGetScreenX()
      screeeH = ShroudGetScreenY()
      charName = ShroudGetPlayerName()
   end
   if (localTime - time) > 1 and init then
      time = localTime
      sync = not sync
      text = makeStringFromList(panelList)
      setAttunList()
      totalWeight = getInvetoryWeight()
      screenW = ShroudGetScreenX()
      screeeH = ShroudGetScreenY()            
   end

   if ShroudGetOnKeyDown("Mouse0") and (moveAble) then
      moveAble = false
      y = ShroudMouseY
      x = ShroudMouseX
   else if ShroudGetOnKeyDown("Mouse0") and moveAbleX then
	 moveAbleX = false
	 width = ShroudMouseX - x
	end
   end
end

function ShroudOnGUI()
   local localTime = os.time()
   if moveAble then
      y0 = ShroudMouseY
      x0 = ShroudMouseX      
   else
      y0 = y
      x0 = x      
   end

   if moveAbleX then
      width0 = ShroudMouseX - x0
   else
      width0 = width 
   end

   if init then
      drawPanel()      
      if showMenu then
	 drawMenu()
	 drawMoveButtons()
      end
   end
end

function setAssets()
   bgTexture = ShroudLoadTexture("nullpanel/bg.png")
   borderTexture = ShroudLoadTexture("nullpanel/border.png")
   buttonTexture = ShroudLoadTexture("nullpanel/button.png")
   airAttun = ShroudLoadTexture("nullpanel/airattunement.png")
   chaosAttun = ShroudLoadTexture("nullpanel/chaosattunement.png")
   deathAttun = ShroudLoadTexture("nullpanel/deathattunement.png")
   earthAttun = ShroudLoadTexture("nullpanel/earthattunement.png")
   fireAttun = ShroudLoadTexture("nullpanel/fireattunement.png")
   lifeAttun = ShroudLoadTexture("nullpanel/lifeattunement.png")
   sunAttun = ShroudLoadTexture("nullpanel/sunattunement.png")
   waterAttun = ShroudLoadTexture("nullpanl/waterattunement.png")
   moonAttun = ShroudLoadTexture("nullpanel/lunarattunement.png")  
   undeadIcon = ShroudLoadTexture("nullpanel/undeadmastery.png")    
   width = ShroudGetScreenX() - 4
end

function setAttunList()
   if multiColor then
      attunList.AirAttun = string.format("<color=#ffff66>%.1f</color>", ShroudGetStatValueByNumber(160))
      attunList.AirRes = string.format("<color=#ffff66>%.1f</color>", ShroudGetStatValueByNumber(332))   
      attunList.SunAttun = string.format("<color=#ffa31a>%.1f</color>", ShroudGetStatValueByNumber(161))
      attunList.SunRes = string.format("<color=#ffa31a>%.1f</color>", ShroudGetStatValueByNumber(333))   
      attunList.LifeAttun = string.format("%.1f", ShroudGetStatValueByNumber(155))
      attunList.LifeRes = string.format("%.1f", ShroudGetStatValueByNumber(327))      
      attunList.FireAttun = string.format("<color=#ff3333>%.1f</color>", ShroudGetStatValueByNumber(157))
      attunList.FireRes = string.format("<color=#ff3333>%.1f</color>", ShroudGetStatValueByNumber(329))
      attunList.EarthAttun = string.format("<color=#00b300>%.1f</color>", ShroudGetStatValueByNumber(159))      
      attunList.EarthRes = string.format("<color=#00b300>%.1f</color>", ShroudGetStatValueByNumber(331))
      attunList.DeathAttun = string.format("<color=#666699>%.1f</color>", ShroudGetStatValueByNumber(156))   
      attunList.DeathRes = string.format("<color=#666699>%.1f</color>", ShroudGetStatValueByNumber(328))
      attunList.ChaosAttun = string.format("<color=#999966>%.1f</color>", ShroudGetStatValueByNumber(163))   
      attunList.ChaosRes = string.format("<color=#999966>%.1f</color>", ShroudGetStatValueByNumber(335))
      attunList.WaterAttun = string.format("<color=#0066ff>%.1f</color>", ShroudGetStatValueByNumber(158))
      attunList.WaterRes = string.format("<color=#0066ff>%.1f</color>", ShroudGetStatValueByNumber(330))
      attunList.MoonAttun = string.format("<color=#b800e6>%.1f</color>", ShroudGetStatValueByNumber(162))   
      attunList.MoonRes = string.format("<color=#b800e6>%.1f</color>", ShroudGetStatValueByNumber(334))
   else
      attunList.AirAttun = string.format("%.1f", ShroudGetStatValueByNumber(160))
      attunList.AirRes = string.format("%.1f", ShroudGetStatValueByNumber(332))   
      attunList.SunAttun = string.format("%.1f", ShroudGetStatValueByNumber(161))
      attunList.SunRes = string.format("%.1f", ShroudGetStatValueByNumber(333))   
      attunList.LifeAttun = string.format("%.1f", ShroudGetStatValueByNumber(155))
      attunList.FireAttun = string.format("%.1f", ShroudGetStatValueByNumber(157))
      attunList.FireRes = string.format("%.1f", ShroudGetStatValueByNumber(329))
      attunList.LifeRes = string.format("%.1f", ShroudGetStatValueByNumber(327))
      attunList.EarthAttun = string.format("%.1f", ShroudGetStatValueByNumber(159))      
      attunList.EarthRes = string.format("%.1f", ShroudGetStatValueByNumber(331))
      attunList.DeathAttun = string.format("%.1f", ShroudGetStatValueByNumber(156))   
      attunList.DeathRes = string.format("%.1f", ShroudGetStatValueByNumber(328))
      attunList.ChaosAttun = string.format("%.1f", ShroudGetStatValueByNumber(163))   
      attunList.ChaosRes = string.format("%.1f", ShroudGetStatValueByNumber(335))
      attunList.WaterAttun = string.format("%.1f", ShroudGetStatValueByNumber(158))
      attunList.WaterRes = string.format("%.1f", ShroudGetStatValueByNumber(330))
      attunList.MoonAttun = string.format("%.1f", ShroudGetStatValueByNumber(162))   
      attunList.MoonRes = string.format("%.1f", ShroudGetStatValueByNumber(334))	 
   end
end

function getInvetoryWeight()
   local localWeight = 0.0
   for _, item in ipairs(ShroudGetInventory()) do
      local name, durability, primaryDurability, maxDurability, weight, quantity, value = item
      localWeight = localWeight + weight      
   end
   return localWeight
end

function drawMenu()
   local width = 655
   local height = 195
   local border = 2
   local x = (screenW / 2) - (width * .5)
   local y = (screenH / 2) + (width * .5)
   --background
   ShroudDrawTexture(x, y, width, height, bgTexture)
   --left border
   ShroudDrawTexture(x, y , border, height, borderTexture)
   --right border
   ShroudDrawTexture(x + width, y, border, height, borderTexture)   
   --top border
   ShroudDrawTexture(x, y, width, border, borderTexture)
   --bottom border
   ShroudDrawTexture(x, y + height, width + border, border, borderTexture)
   
   ShroudGUILabel(x + width - 193, y + height - 20 ,200,20, "Mail all inquiries to Ox Null, v0.1")

   if showAttun then
      if ShroudButton(x + 5, y + 5, 60, 40, buttonTexture, "Attun[-]", "Menu") then
	 showAttun = false
      end
   else
      if ShroudButton(x + 5, y + 5, 60, 40, buttonTexture, "Attun[+]", "Menu") then
	 showAttun = true
      end	 
   end
   
   if multiColor then
      if ShroudButton(x + 65, y + 5, 100, 40, buttonTexture, "Multi Color[-]", "Menu") then
	 multiColor = false
      end
   else
      if ShroudButton(x + 65, y + 5, 100, 40, buttonTexture, "Multi Color[+]", "Menu") then
	 multiColor = true
      end	 
   end
   
   if ShroudButton(x + width, y, 60, 40, undeadIcon, "X", "Close")then
      showMenu = false
   end
   
   local yoffset = 0      
   for i, value in pairs(panelList) do
      if i < 11 then
	 yoffset = 0
      end
      if i % 11 == 0 then
	 yoffset = yoffset + 65
      end
      if ShroudButton(x + 5 + ((i-1)% 10) * 65, y + 65 + (yoffset), 60, 40, buttonTexture, string.format("Slot %d", i), string.format("button %d", i)) then
	 removeList(panelList, i)
	 if (i - 1) % 11 == 0  then
	    yoffset = yoffset - 65
	 end
      end	 
   end
   
end

function drawPanel()
   local height = 28
   local border = 2
   local offset = 36
   local iconOffset = 28
   local tabOffset = 8
   local padding = 4
   local iconWidth = 28 * 11.75   
   --backgrounnd
   ShroudDrawTexture(x0 + border, y0 + border, width0, height, bgTexture)
   --left border
   ShroudDrawTexture(x0, y0 + border, border, height, borderTexture)
   --right border
   ShroudDrawTexture(x0 + width0 + border, y0 + border, border, height, borderTexture)   
   --top border
   ShroudDrawTexture(x0, y0, width0 + border * 2, border, borderTexture)
   --bottom border
   ShroudDrawTexture(x0, y0 + height + border, width0 + border * 2, border, borderTexture)
   --   ShroudDrawTexture(screenW - 50,2 ,28,28, airAttun )
   
   if showAttun then
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 15 + tabOffset * 8 - padding, y0 + 2 ,28,28, airAttun )            
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 13 + tabOffset * 7 - padding, y0 + 2 ,28,28, moonAttun )      
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 11 + tabOffset * 6 - padding, y0 + 2 ,28,28, waterAttun )
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 9 + tabOffset * 5 - padding, y0 + 2 ,28,28, sunAttun )
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 7 + tabOffset * 4 - padding, y0 + 2 ,28,28, lifeAttun )   
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 5 + tabOffset * 3 - padding, y0 + 2 ,28,28, fireAttun )
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset * 3 + tabOffset * 2 - padding, y0 + 2 ,28,28, earthAttun )
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 + iconOffset + tabOffset - padding, y0 + 2 ,28,28, deathAttun )
      ShroudDrawTexture(x0 + width0 - iconWidth - offset * 6 - iconOffset - padding, y0 + 2 ,28,28, chaosAttun )
      ShroudGUILabel(x0 + width0 - iconWidth - offset * 6, y0, screenW - (x0 + width0 - iconWidth - offset * 6),20, string.format(
      			"<size=11><color=#ccf2ff>%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s</color></size>",
      			attunList.ChaosAttun,
      			attunList.DeathAttun,
      			attunList.EarthAttun,
      			attunList.FireAttun,
      			attunList.LifeAttun,
      			attunList.SunAttun,
      			attunList.WaterAttun,
      			attunList.MoonAttun,
      			attunList.AirAttun			
			
      ))
      ShroudGUILabel(x0 + width0 - iconWidth - offset * 6 ,y0 + 10, screenW - (x0 + width0 - iconWidth - offset * 6),20, string.format(
      			"<size=11><color=#ccf2ff>%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s</color></size>",
      			attunList.ChaosRes,
      			attunList.DeathRes,
      			attunList.EarthRes,
      			attunList.FireRes,
      			attunList.LifeRes,
      			attunList.SunRes,
      			attunList.WaterRes,
      			attunList.MoonRes,
      			attunList.AirRes						
      ))
   end
   ShroudGUILabel(x0 + 14,y0 + 4,width0,20, string.format("<color=#ccf2ff>%s</color>", text))
end

function drawMoveButtons()
   if not moveAble then
      if ShroudButton(x0 + 5 ,y0 - 2 ,24,24, buttonTexture, ">") then
	 ConsoleLog("Enabled Move")
	 moveAble = true
      end                     
   else
      if ShroudButton(x0 + 5,y0 -2 ,24,24, buttonTexture, ">") then
	 ConsoleLog("Disabled Move")
	 moveAble = false
      end
   end
   
   if not moveAbleX then
      if ShroudButton(x0 + 30,y0 - 2 ,24,24, buttonTexture, "w") then
	 ConsoleLog("Enabled Move")
	 moveAbleX = true

      end                     
   else
      if ShroudButton(x0 + 30,y0 - 2,24,24, buttonTexture, "w") then
	 ConsoleLog("Disabled Move")
	 moveAbleX = false
      end
   end
end

function addList(list, value)
   if #list < 20 then
      table.insert(list, value)
      ShroudConsoleLog("[ff0000]Null Panel:[-]")            
      ShroudConsoleLog("[00e600]----------")   	                
      ShroudConsoleLog(string.format("Added Stat #%d %s, %.4f", value, ShroudGetStatNameByNumber(value), ShroudGetStatValueByNumber(value)))
      ShroudConsoleLog("----------[-]")   	                      
   end
end

function removeList(list, value)
   local removed = table.remove(list, value)
   if removed then
      ShroudConsoleLog("[ff0000]Null Panel:[-]")            
      ShroudConsoleLog("[00e600]----------")   	          
      ShroudConsoleLog(string.format("Removed Slot %d, Stat #%d %s, %.4f", value, removed, ShroudGetStatNameByNumber(removed), ShroudGetStatValueByNumber(removed)))
      ShroudConsoleLog("----------[-]")   	                
   end
end

function makeStringFromList(list)
   local context  = ""
   for i = 1, #list do
      -- if special stat value, calculate their custom format
      if list[i] == 500 then
	 context = string.format("%s [Adv XP: %d]" ,context, ShroudGetPooledAdventurerExperience())
      elseif list[i] == 501 then
	 context = string.format("%s [Prod XP: %d]" ,context, ShroudGetPooledProducerExperience())
      elseif list[i] == 14 or list[i] == 30 or list[i] == 97 or list[i] == 11 then
	 if sync and ShroudGetStatValueByNumber(97) > 0 then
	    context = string.format("%s [HP %d/%d <color=#e6f9ff>+%.1f</color>/%.1f]" ,context, ShroudGetStatValueByNumber(14), ShroudGetStatValueByNumber(30), ShroudGetStatValueByNumber(97), ShroudGetStatValueByNumber(11))
	 else
	    context = string.format("%s [HP %d/%d +%.1f/%.1f]" ,context, ShroudGetStatValueByNumber(14), ShroudGetStatValueByNumber(30), ShroudGetStatValueByNumber(97), ShroudGetStatValueByNumber(11))
	 end
      elseif list[i] == 13 or list[i] == 27 or list[i] == 98 or list[i] == 10 then
	 if sync and ShroudGetStatValueByNumber(98) > 0 then	 
	    context = string.format("%s [Focus %d/%d <color=e6f9ff>+%.1f</color>/%.1f]" ,context, ShroudGetStatValueByNumber(13), ShroudGetStatValueByNumber(27), ShroudGetStatValueByNumber(98), ShroudGetStatValueByNumber(10))
	 else
	    context = string.format("%s [Focus %d/%d +%.1f/%.1f]" ,context, ShroudGetStatValueByNumber(13), ShroudGetStatValueByNumber(27), ShroudGetStatValueByNumber(98), ShroudGetStatValueByNumber(10))	    
	 end
      elseif list[i] == 8 then
	 context = string.format("%s [%s %.1f/%.1f]" ,context, ShroudGetStatNameByNumber(8), totalWeight, ShroudGetStatValueByNumber(8))
      -- else return default format.
      else
	 context = string.format("%s [%s: %.1f]" ,context, ShroudGetStatNameByNumber(list[i]), ShroudGetStatValueByNumber(list[i]))	      
      end
   end
   return context
end

function showStats()
   local count = 0
   ShroudConsoleLog("[ff0000]Null Panel:[-]")         
   ShroudConsoleLog("[00e600]----------[-]")   	    
   for i=1, ShroudGetStatCount() do
      if ShroudGetStatValueByNumber(i) > 0 then
	 count = count + 1
	 ShroudConsoleLog(string.format("Stat #%d %s, %.4f", i, ShroudGetStatNameByNumber(i), ShroudGetStatValueByNumber(i)))
      end
   end
   ShroudConsoleLog(string.format("Stat #%d - %s, %.2f", 500, "Pooled Adventure XP", ShroudGetPooledAdventurerExperience()))
   ShroudConsoleLog(string.format("Stat #%d - %s, %.2f", 501, "Pooled Producer XP", ShroudGetPooledProducerExperience()))
   ShroudConsoleLog("Total stats: " .. count + 2)
   ShroudConsoleLog("[00e600]----------[-]")      
end
