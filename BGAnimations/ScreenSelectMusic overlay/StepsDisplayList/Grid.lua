-- this difficulty grid doesn't support CourseMode
-- CourseContentsList.lua should be used instead
if GAMESTATE:IsCourseMode() then return end
-- ----------------------------------------------

local GetStepsToDisplay = LoadActor("./StepsToDisplay.lua")

local t = Def.ActorFrame{
	Name="StepsDisplayList",
	InitCommand=function(self) self:xy(_screen.cx-26, _screen.cy + 67) end,

	OnCommand=function(self)                           self:queuecommand("RedrawStepsDisplay") end,
	CurrentSongChangedMessageCommand=function(self)    self:queuecommand("RedrawStepsDisplay") end,
	CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,
	CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("RedrawStepsDisplay") end,

	RedrawStepsDisplayCommand=function(self)

		local song = GAMESTATE:GetCurrentSong()

		if song then
			local steps = SongUtil.GetPlayableSteps( song )

			if steps then
				local StepsToDisplay = GetStepsToDisplay(steps)

				for i=1,5 do
					if StepsToDisplay[i] then
						-- if this particular song has a stepchart for this row, update the Meter
						-- and BlockRow coloring appropriately
						local meter = StepsToDisplay[i]:GetMeter()
						local difficulty = StepsToDisplay[i]:GetDifficulty()
						self:GetChild("Grid"):GetChild("Meter_"..i):playcommand("Set",  {Meter=meter, Difficulty=difficulty})
						self:GetChild("Grid"):GetChild("MeterBackground_"..i):playcommand("Set",  {Meter=meter, Difficulty=difficulty})
						self:GetChild("Grid"):GetChild("MeterBackground2_"..i):playcommand("Set",  {Meter=meter, Difficulty=difficulty})
					else
						-- otherwise, set the meter to an empty string and hide this particular colored BlockRow
						self:GetChild("Grid"):GetChild("Meter_"..i):playcommand("Unset")
						self:GetChild("Grid"):GetChild("MeterBackground_"..i):playcommand("Unset")
						self:GetChild("Grid"):GetChild("MeterBackground2_"..i):playcommand("Unset")
					end
				end
			end
		else
			self:playcommand("Unset")
		end
	end,
}

t[#t+1] = Def.Quad{
	Name="Background",
	InitCommand=function(self)
		self:diffuse(color("#1e282f")):zoomto(32,152)
		if ThemePrefs.Get("RainbowMode") then
			self:diffuse(Color.White):diffusealpha(0.5)
		end
		if ThemePrefs.Get("VisualStyle") == "Technique" then
			self:diffusealpha(0.5)
		end
	end
}

local Grid = Def.ActorFrame{
	Name="Grid",
	InitCommand=function(self) end,
}

for RowNumber=-2, 2 do
	Grid[#Grid+1] = Def.Quad{
		Name="MeterBackground_"..(RowNumber + 3),
		InitCommand=function(self)
			local height = 28
			local spacing = 2
			self:zoomto(height, height):y((height+spacing)*RowNumber)
		end,
		SetCommand=function(self) self:visible(true) end,
		UnsetCommand=function(self) self:visible(false) end
	}
	Grid[#Grid+1] = Def.Quad{
		Name="MeterBackground2_"..(RowNumber + 3),
		InitCommand=function(self)
			local height = 28
			local spacing = 2
			self:diffuse(color("#0f0f0f")):zoomto(height-4, height-4):y((height+spacing)*RowNumber)
			if not ThemePrefs.Get("RainbowMode") then
				self:visible(false)
			end
		end,
		SetCommand=function(self, params)
			self:visible(true):diffuse(DifficultyColor(params.Difficulty))
		end,
		UnsetCommand=function(self) self:visible(false) end
	}
	Grid[#Grid+1] = LoadFont("Slab/_slab")..{
		Name="Meter_"..(RowNumber + 3),
		InitCommand=function(self)
			local height = 28
			local spacing = 2
			self:xy(-3, (height+spacing)*RowNumber-1):zoom(0.45):maxwidth(80)
			self:shadowlength(2):shadowcolor(Color.Black)
		end,
		SetCommand=function(self, params)
			-- diffuse and set each chart's difficulty meter
			self:diffuse( lerp_color(0.66, DifficultyColor(params.Difficulty), Color.White) )
			self:settext(params.Meter)
		end,
		UnsetCommand=function(self) self:settext("") end,
	}
end

t[#t+1] = Grid

return t