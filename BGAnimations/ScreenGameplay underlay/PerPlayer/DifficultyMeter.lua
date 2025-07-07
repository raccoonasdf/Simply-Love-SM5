local player = ...

local _x = _screen.cx + (player==PLAYER_1 and -1 or 1) * SL_WideScale(292.5, 342.5)
if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
	_x = _x + SL_WideScale(36, 86)
end

return Def.ActorFrame{
	InitCommand=function(self)
		self:xy(_x, 56)
	end,

	JudgmentMessageCommand=function(self, params)
		if params.Player == player and params.Notes then
			self:zoomy(1.15):decelerate(0.1):zoomy(1)
		end
	end,

	-- colored background for player's chart's difficulty meter
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(30, 30):shadowlength(2):diffuse(Color.White)
		end
	},
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(26, 26):diffuse(Color.Black)
		end,
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Begin") end,
		BeginCommand=function(self)
			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				local currentDifficulty = currentSteps:GetDifficulty()
				self:diffuse(DifficultyColor(currentDifficulty))
			end
		end
	},
	-- player's chart's difficulty meter
	LoadFont("Slab/_slab")..{
		InitCommand=function(self)
			--self:diffuse( Color.Black )
			self:xy(-3.5, -1):shadowlength(2):shadowcolor(Color.Black)
			self:zoom( 0.45 ):zoomx(0.5):maxwidth(80)
		end,
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Begin") end,
		BeginCommand=function(self)
			local steps = GAMESTATE:GetCurrentSteps(player)
			local meter = steps:GetMeter()

			if meter then
				self:diffuse(lerp_color(0.66, DifficultyColor(steps:GetDifficulty()), Color.White)):settext(meter)
			end
		end
	}
}