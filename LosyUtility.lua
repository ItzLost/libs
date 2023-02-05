local lib = {
    Icon = "http://www.roblox.com/asset/?id=11200561129"
}

function lib:Kill(path, obj)
    local children = path:GetChildren()
    if type(path) == "table" then
        children = path
    end
    for _, v in ipairs(children) do
        if path:FindFirstChild(obj) then
            obj:Destroy()
            return(true)
        end
    end
    return(false)
end

function lib:GetPlayer(String)
    local lower = String:lower()
    for _, pl in next, game.Players:GetPlayers() do
        if pl.Name:sub(1,#String):lower() == lower or pl.DisplayName:sub(1,#String):lower() == lower then
            return(pl)
        end
    end
end

function lib:IsChar()
    local plr = game:GetService("Players").LocalPlayer
    if plr.Character then
        if plr.Character.HumanoidRootPart then
            if plr.Character.Humanoid then
                return(true)
            end
        end
    end
    return(false)
end

function lib:ServerHop()
    local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    -- Serverhop from infinite yield hub, all credits to infinite yield devs. --
    if httprequest then
        local servers = {}
        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)})
        local body = game:GetService("HttpService"):JSONDecode(req.Body)
        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
        else
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end
    ----------------------------------------------------------------------------
end

function lib:ConvertToLetter(number)
    local newnum
    local function round(num)
        return(math.floor(num * 1e3 + .5)/1e3)
    end
    if number/1e18 >= 1 then
        newnum = number/1e18
        return(round(newnum).."Qi")
    end
    if number/1e15 >= 1 then
        newnum = number/1e15
        return(round(newnum).."Qa")
    end
    if number/1e12 >= 1 then
        newnum = number/1e12
        return(round(newnum).."T")
    end
    if number/1e9 >= 1 then
        newnum = number/1e09
        return(round(newnum).."B")
    end
    if number/1e6 >= 1 then
        newnum = number/1e06
        return(round(newnum).."M")
    end
    if number/1e3 >= 1 then
        newnum = number/1e03
        return(round(newnum).."K")
    end
    return(round(number))
end

function lib:Notif(Title, Text, Time)
    local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()
    getgenv().IrisAd = true
    if Time == nil then
        Time = 7
    end
    Notification.Notify(Title, Text, lib.Icon, {Duration = Time, GradientSettings = {GradientEnabled = false, Retract = true, SolidColor = Color3.fromRGB(150, 0, 0)}, Main = {BackgroundColor3 = Color3.fromRGB(15, 0, 0)}})
end

function lib:UseTool(Tool)
    if plr.Character then
        if not plr.Character:FindFirstChild(Tool) and plr.Backpack:FindFirstChild(Tool) then
            plr.Character.Humanoid:EquipTool(plr.Backpack[Tool])
        end
    end
end

function lib:PathFindWalkTo(coords)
    local path = game:GetService("PathfindingService"):CreatePath()
    local plr = game:GetService("Players").LocalPlayer
    while wait() do
        if (plr.Character.HumanoidRootPart.Position - coords).Magnitude <= 5 then
            return(true)
        end
        local success = pcall(function()
            path:ComputeAsync(plr.Character.HumanoidRootPart.Position, coords)
        end)
        if not success then
            return(false)
        end
        if success and path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            local dist
            for _, waypoint in ipairs(waypoints) do
                local wppos = waypoint.Position
                plr.Character.Humanoid:MoveTo(wppos)
                repeat
                    dist = (wppos - plr.Character.HumanoidRootPart.Position).Magnitude
                    wait()
                until(dist <= 5)
            end
        end
    end
end
return(lib)
