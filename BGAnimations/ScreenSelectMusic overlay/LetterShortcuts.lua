local LetterShortcutsCallback = function(event)
    if not (event and event.button and event.type == "InputEventType_FirstPress") then
        return false
    end
    
    -- note: assume player 1 since these events are playerless

    -- search
    if event.DeviceInput.button == "DeviceButton_s" and not GAMESTATE:IsCourseMode() then
        SCREENMAN:GetTopScreen():GetChild("Overlay"):queuecommand("DirectInputToEngineForSongSearch")
    -- leaderboard
    elseif event.DeviceInput.button == "DeviceButton_l" then
        SCREENMAN:GetTopScreen():GetChild("Overlay"):queuecommand("DirectInputToLeaderboard")
    -- favorite
    -- TODO: figure out why this doesn't add/remove the bubble until you move away
    elseif event.DeviceInput.button == "DeviceButton_f" then
        addOrRemoveFavorite(PLAYER_1)
    -- title
    elseif event.DeviceInput.button == "DeviceButton_t" then
		MESSAGEMAN:Broadcast('Sort', { order = "Title" })
		MESSAGEMAN:Broadcast('ResetHeaderText')
    -- group
    elseif event.DeviceInput.button == "DeviceButton_g" then
		MESSAGEMAN:Broadcast('Sort', { order = "Group" })
		MESSAGEMAN:Broadcast('ResetHeaderText')
    -- mixtape
    elseif event.DeviceInput.button == "DeviceButton_m" then
		SONGMAN:SetPreferredSongs(getFavoritesPath(PLAYER_1), --[[isAbsolute=]]true);
		SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort("SortOrder_Preferred")
    end
end

local af = Def.ActorFrame{
    Name="LetterShortcuts",
    OnCommand=function(self)
        if ThemePrefs.Get("KeyboardFeatures") then
            SCREENMAN:GetTopScreen():AddInputCallback(LetterShortcutsCallback)
        end
    end
}

return af