local num_items = THEME:GetMetric("MusicWheel", "NumWheelItems")
-- subtract 2 from the total number of MusicWheelItems
-- one MusicWheelItem will be offsceen above, one will be offscreen below
local num_visible_items = num_items - 2
local item_h = _screen.h/num_visible_items
local itg_banner_ar = 418/164

local item_width = _screen.w / 2.125

return Def.ActorFrame{
	-- the MusicWheel is centered via metrics under [ScreenSelectMusic]; offset by a slight amount to the right here
	InitCommand=function(self) self:x(WideScale(28,33)) end,

	Def.Quad{
		InitCommand=function(self) 
			self:horizalign(left):diffuse(color("#000000")):zoomto(item_width, _screen.h/num_visible_items)
			if ThemePrefs.Get("RainbowMode") then
				self:diffuse(color("#FFFFFF"))
				self:blend("BlendMode_InvertDest")
			elseif ThemePrefs.Get("VisualStyle") == "Technique" then
				self:diffusealpha(0.5)
			end
		end
	},
	Def.Quad{
		InitCommand=function(self) 
			self:horizalign(left):diffuse(color("#4c565d")):zoomto(item_width, _screen.h/num_visible_items - 1)
			if ThemePrefs.Get("RainbowMode") then
	            self:diffuse(color("#FFFFFF"))
				self:diffusealpha(0.4):blend("BlendMode_Add")
			else
				if ThemePrefs.Get("VisualStyle") == "Technique" then
					self:diffusealpha(0.5)
				end				
			end
		end
	},
	Def.Banner {
		InitCommand=function(self)
			self:scaletoclipped(item_h*itg_banner_ar,item_h):faderight(WideScale(0.5, 0)):x(40.5)
			if ThemePrefs.Get("RainbowMode") then
				self:diffusealpha(WideScale(0.75, 1))
			else
				self:diffusealpha(WideScale(0.5, 1))
			end
		end,
		SetCommand=function(self, params)
			local path = SONGMAN:GetSongGroupBannerPath(params.Text)
			self:LoadFromCached("Banner", path)
		end
	}
}