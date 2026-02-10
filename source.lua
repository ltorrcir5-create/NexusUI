-- GrokUI v2.0 - THE BEST Roblox UI Lib (by Grok/xAI)
-- Load: loadstring(game:HttpGet("raw.github..."))()

local GrokUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 24),
        Foreground = Color3.fromRGB(32, 32, 38),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 190),
        Border = Color3.fromRGB(50, 50, 56),
        SliderBg = Color3.fromRGB(55, 55, 62)
    },
    Light = {
        Background = Color3.fromRGB(248, 248, 250),
        Foreground = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(40, 40, 50),
        TextDark = Color3.fromRGB(110, 120, 140),
        Border = Color3.fromRGB(220, 220, 230),
        SliderBg = Color3.fromRGB(230, 230, 240)
    }
}

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function addHover(btn, normal, hover)
    btn.MouseEnter:Connect(function()
        Tween(btn, 0.2, {BackgroundColor3 = hover})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, 0.2, {BackgroundColor3 = normal})
    end)
end

function GrokUI:CreateWindow(opts)
    opts = opts or {}
    opts.Title = opts.Title or "GrokUI v2.0"
    opts.Size = opts.Size or UDim2.new(0, 650, 0, 500)
    local themeName = opts.Theme or "Dark"
    local Theme = Themes[themeName]

    local Screen = Create("ScreenGui", {
        Name = "GrokUI_" .. HttpService:GenerateGUID(false),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Main = Create("Frame", {
        Parent = Screen,
        BackgroundColor3 = Theme.Background,
        Size = opts.Size,
        Position = UDim2.new(0.5, -325, 0.5, -250),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 12)})
    local MainGrad = Create("UIGradient", {
        Parent = Main,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Background),
            ColorSequenceKeypoint.new(1, Theme.Foreground)
        },
        Rotation = 90
    })

    -- TitleBar
    local TitleBar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Foreground,
        Size = UDim2.new(1, 0, 0, 46),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = TitleBar, CornerRadius = UDim.new(0, 12)})

    local Title = Create("TextLabel", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 18, 0, 0),
        Text = opts.Title,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 16
    })

    -- Minimize
    local MinimizeBtn = Create("TextButton", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -100, 0.5, -16),
        Text = "−",
        TextColor3 = Theme.TextDark,
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })
    addHover(MinimizeBtn, Theme.TextDark, Theme.Accent)

    -- Close
    local CloseBtn = Create("TextButton", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -60, 0.5, -16),
        Text = "✕",
        TextColor3 = Color3.fromRGB(240, 90, 90),
        Font = Enum.Font.GothamBold,
        TextSize = 18
    })
    addHover(CloseBtn, Color3.fromRGB(240,90,90), Color3.fromRGB(255,70,70))

    CloseBtn.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    -- Dragging
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            Tween(TitleBar, 0.2, {BackgroundColor3 = Theme.Accent})
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            Tween(TitleBar, 0.2, {BackgroundColor3 = Theme.Foreground})
        end
    end)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Foreground,
        Size = UDim2.new(0, 160, 1, -46),
        Position = UDim2.new(0, 0, 0, 46),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 12)})

    local TabList = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    TabList.ScrollBarImageTransparency = 0.7
    local TabLayout = Create("UIListLayout", {
        Parent = TabList,
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)

    -- Content
    local Content = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -160, 1, -46),
        Position = UDim2.new(0, 160, 0, 46)
    })

    -- Window object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Flags = {},
        Elements = {},
        Main = Main,
        Screen = Screen,
        Content = Content,
        Sidebar = Sidebar,
        Theme = Theme,
        Minimized = false,
        NotifFolder = Create("Folder", {Parent = Screen, Name = "Notifications"}),
        fpsConn = nil,
        frameCount = 0,
        fpsTime = 0
    }

    -- Watermark
    local Watermark = Create("Frame", {
        Parent = Screen,
        BackgroundColor3 = Theme.Foreground,
        Size = UDim2.new(0, 0, 0, 36),
        Position = UDim2.new(0, 20, 0, 20),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 8)})
    Create("UIGradient", {
        Parent = Watermark,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Accent, 0),
            ColorSequenceKeypoint.new(1, Theme.Foreground, 0)
        },
        Rotation = 45
    })
    local WMText = Create("TextLabel", {
        Parent = Watermark,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Text = "GrokUI v2.0 | FPS: --",
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14
    })
    Watermark.AutomaticSize = Enum.AutomaticSize.XY
    Window.Watermark = Watermark
    Window.fpsConn = RunService.Heartbeat:Connect(function(delta)
        Window.frameCount = Window.frameCount + 1
        Window.fpsTime = Window.fpsTime + delta
        if Window.fpsTime >= 1 then
            WMText.Text = string.format("GrokUI v2.0 | FPS: %d", Window.frameCount)
            Window.frameCount = 0
            Window.fpsTime = 0
        end
    end)

    -- Minimize func
    function Window:Minimize(toggle)
        self.Minimized = toggle ~= false and not self.Minimized or toggle
        local targetSize = self.Minimized and UDim2.new(0, Main.Size.X.Offset, 0, 46) or opts.Size
        Tween(Main, 0.3, {Size = targetSize})
        self.Content.Visible = not self.Minimized
        self.Sidebar.Visible = not self.Minimized
        MinimizeBtn.Text = self.Minimized and "＋" or "−"
        MinimizeBtn.TextColor3 = self.Minimized and self.Theme.Accent or self.Theme.TextDark
    end

    function Window:Toggle()
        local vis = not self.Main.Visible
        self.Main.Visible = vis
        self.Watermark.Visible = vis
    end

    function Window:Destroy()
        if self.fpsConn then self.fpsConn:Disconnect() end
        self.Screen:Destroy()
    end

    function Window:Notify(text, duration)
        duration = duration or 3
        local notifs = self.NotifFolder:GetChildren()
        local yOffset = #notifs * 72
        local Notif = Create("Frame", {
            Parent = self.NotifFolder,
            BackgroundColor3 = self.Theme.Foreground,
            Size = UDim2.new(0, 300, 0, 65),
            Position = UDim2.new(1, -320, 1, -90 - yOffset),
            BorderSizePixel = 0
        })
        Create("UICorner", {Parent = Notif, CornerRadius = UDim.new(0, 10)})
        Create("UIGradient", {
            Parent = Notif,
            Color = ColorSequence.new(Theme.Accent, Theme.Foreground),
            Rotation = 90
        })
        Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -6),
            Position = UDim2.new(0, 12, 0, 3),
            Text = text,
            TextColor3 = self.Theme.Text,
            TextWrapped = true,
            Font = Enum.Font.Gotham,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Tween(Notif, 0.4, {Position = UDim2.new(1, -320, 1, -90 - yOffset)})
        task.delay(duration, function()
            Tween(Notif, 0.4, {Position = UDim2.new(1, 20, 1, -90 - yOffset)})
            task.wait(0.4)
            Notif:Destroy()
        end)
    end

    function Window:SaveConfig()
        local config = HttpService:JSONEncode(self.Flags)
        if setclipboard then
            setclipboard(config)
        end
        self:Notify("Config saved to clipboard! 📋", 2.5)
        return config
    end

    function Window:LoadConfig(jsonStr)
        local success, config = pcall(HttpService.JSONDecode, HttpService, jsonStr)
        if success then
            for flag, value in pairs(config) do
                if self.Elements[flag] then
                    self.Elements[flag]:Set(value)
                end
            end
            self:Notify("Config loaded! ✅", 2)
        else
            self:Notify("Invalid config JSON! ❌", 2)
        end
    end

    -- Tab creation
    function Window:NewTab(name)
        local TabBtn = Create("TextButton", {
            Parent = TabList,
            BackgroundColor3 = self.Theme.Foreground,
            Size = UDim2.new(1, -12, 0, 42),
            Text = "   " .. name,
            TextColor3 = self.Theme.TextDark,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            BorderSizePixel = 0
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        addHover(TabBtn, self.Theme.Foreground, self.Theme.SliderBg)

        local TabPage = Create("ScrollingFrame", {
            Parent = self.Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -12, 1, -12),
            Position = UDim2.new(0, 6, 0, 6),
            Visible = false,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = self.Theme.Accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        TabPage.ScrollBarImageTransparency = 0.7
        local PageLayout = Create("UIListLayout", {
            Parent = TabPage,
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
        end)

        local Tab = {Page = TabPage, Button = TabBtn, Name = name}

        TabBtn.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                self.CurrentTab.Page.Visible = false
                Tween(self.CurrentTab.Button, 0.2, {TextColor3 = self.Theme.TextDark, BackgroundColor3 = self.Theme.Foreground})
            end
            TabPage.Visible = true
            Tween(TabBtn, 0.2, {TextColor3 = self.Theme.Text, BackgroundColor3 = self.Theme.Accent})
            self.CurrentTab = Tab
        end)

        if not self.CurrentTab then
            TabPage.Visible = true
            TabBtn.TextColor3 = self.Theme.Text
            TabBtn.BackgroundColor3 = self.Theme.Accent
            self.CurrentTab = Tab
        end

        table.insert(self.Tabs, Tab)
        return Tab
    end

    -- Section creation (returns section funcs)
    function Window:NewSection(tab, title)  -- tab:NewSection(title)
        local SecFrame = Create("Frame", {
            Parent = tab.Page,
            BackgroundColor3 = self.Theme.Foreground,
            Size = UDim2.new(1, -24, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0
        })
        Create("UICorner", {Parent = SecFrame, CornerRadius = UDim.new(0, 10)})

        Create("TextLabel", {
            Parent = SecFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "   " .. title,
            TextColor3 = self.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamBold,
            TextSize = 16
        })

        local ContFrame = Create("Frame", {
            Parent = SecFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 36),
            Size = UDim2.new(1, -24, 1, -36),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        local ContLayout = Create("UIListLayout", {
            Parent = ContFrame,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local Section = {Name = title, Tab = tab, ContFrame = ContFrame}
        Section.Elements = {}  -- temp? No, global Window.Elements

        -- Helper to gen flag path
        local function getFlagPath(elemName)
            return Section.Tab.Name .. "/" .. Section.Name .. "/" .. elemName:lower():gsub("[^%w]", "_")
        end

        -- Button
        function Section:NewButton(text, callback)
            local Btn = Create("TextButton", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Accent,
                Size = UDim2.new(1, 0, 0, 44),
                Text = text,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamSemibold,
                TextSize = 15,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 8)})
            addHover(Btn, self.Theme.Accent, self.Theme.Accent:lerp(Color3.new(1,1,1), 0.2))
            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, 0.1, {Size = UDim2.new(1, -4, 0, 40)})
                task.delay(0.1, function()
                    Tween(Btn, 0.2, {Size = UDim2.new(1, 0, 0, 44)})
                end)
                task.spawn(callback)
            end)
            ContLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabPage.CanvasSize = UDim2.new(0,0,0,PageLayout.AbsoluteContentSize.Y)
            end)
            return Btn
        end

        -- Toggle
        function Section:NewToggle(text, default, callback)
            local flag = getFlagPath(text)
            default = self.Flags[flag] or default or false
            local ToggleFrame = Create("Frame", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Foreground,
                Size = UDim2.new(1, 0, 0, 44),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 8)})

            local TLabel = Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -90, 1, 0),
                Text = text,
                TextColor3 = self.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })

            local SwitchBg = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = default and self.Theme.Accent or self.Theme.SliderBg,
                Size = UDim2.new(0, 56, 0, 28),
                Position = UDim2.new(1, -70, 0.5, -14),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SwitchBg, CornerRadius = UDim.new(0, 14)})
            local SwitchCircle = Create("Frame", {
                Parent = SwitchBg,
                BackgroundColor3 = Color3.new(1,1,1),
                Size = UDim2.new(0, 24, 0, 24),
                Position = default and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12),
                BorderSizePixel = 0,
                ZIndex = 10
            })
            Create("UICorner", {Parent = SwitchCircle, CornerRadius = UDim.new(0, 12)})

            local state = default
            local animConn
            local function updateState(newState)
                state = newState
                self.Flags[flag] = state
                Tween(SwitchBg, 0.2, {BackgroundColor3 = state and self.Theme.Accent or self.Theme.SliderBg})
                Tween(SwitchCircle, 0.2, {Position = state and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)})
                task.spawn(function() callback(state) end)
            end

            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    updateState(not state)
                end
            end)
            addHover(ToggleFrame, self.Theme.Foreground, self.Theme.SliderBg)

            local toggleObj = {
                Set = function(_, v)
                    updateState(v)
                end
            }
            self.Elements[flag] = toggleObj

            return toggleObj
        end

        -- Slider
        function Section:NewSlider(text, minVal, maxVal, default, callback, suffix)
            suffix = suffix or ""
            local flag = getFlagPath(text)
            default = math.clamp(self.Flags[flag] or default or minVal, minVal, maxVal)
            local SliderFrame = Create("Frame", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Foreground,
                Size = UDim2.new(1, 0, 0, 58),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 8)})

            local SLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22),
                Text = text,
                TextColor3 = self.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 70, 0, 22),
                Position = UDim2.new(1, -85, 0, 22),
                Text = tostring(default) .. suffix,
                TextColor3 = self.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Right,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })

            local SliderBar = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = self.Theme.SliderBg,
                Size = UDim2.new(1, -20, 0, 8),
                Position = UDim2.new(0, 10, 1, -20),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

            local SliderFill = Create("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = self.Theme.Accent,
                Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderFill, CornerRadius = UDim.new(1, 0)})

            local value = default
            local sliderData = {dragging = false, mouseConn = nil}

            local function updateSlider(newVal)
                value = math.clamp(math.floor(newVal + 0.5), minVal, maxVal)
                local percent = (value - minVal) / (maxVal - minVal)
                Tween(SliderFill, 0.15, {Size = UDim2.new(percent, 0, 1, 0)})
                ValueLabel.Text = tostring(value) .. suffix
                self.Flags[flag] = value
                task.spawn(function() callback(value) end)
            end

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                sliderData.dragging = true
                sliderData.mouseConn = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                    local mousePos = UserInputService:GetMouseLocation()
                    local barAbsPos = SliderBar.AbsolutePosition.X
                    local barAbsSize = SliderBar.AbsoluteSize.X
                    local relPos = math.clamp((mousePos.X - barAbsPos) / barAbsSize, 0, 1)
                    updateSlider(minVal + (maxVal - minVal) * relPos)
                end)
            end)

            local endConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliderData.dragging = false
                    if sliderData.mouseConn then
                        sliderData.mouseConn:Disconnect()
                        sliderData.mouseConn = nil
                    end
                    endConn:Disconnect()
                end
            end)

            addHover(SliderBar, self.Theme.SliderBg, self.Theme.Accent)

            local sliderObj = {
                Set = function(_, v)
                    updateSlider(v)
                end
            }
            self.Elements[flag] = sliderObj
            updateSlider(default)

            return sliderObj
        end

        -- Dropdown
        function Section:NewDropdown(text, options, default, callback, multi)
            multi = multi or false
            local flag = getFlagPath(text)
            local selected = self.Flags[flag] or (multi and {} or default or options[1] or "None")
            local DropFrame = Create("Frame", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Foreground,
                Size = UDim2.new(1, 0, 0, multi and 50 or 44),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 8)})

            local DLabel = Create("TextLabel", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -90, 1, 0),
                Text = text,
                TextColor3 = self.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })

            local DropBtn = Create("TextButton", {
                Parent = DropFrame,
                BackgroundColor3 = self.Theme.SliderBg,
                Size = UDim2.new(0, 72, 0, 32),
                Position = UDim2.new(1, -80, 0.5, -16),
                Text = multi and (#selected > 0 and tostring(#selected).." selected" or "None") or (selected or "None"),
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = DropBtn, CornerRadius = UDim.new(0, 6)})
            addHover(DropBtn, self.Theme.SliderBg, self.Theme.Accent)

            local ListFrame = Create("ScrollingFrame", {
                Parent = DropFrame,
                BackgroundColor3 = self.Theme.Foreground,
                Size = UDim2.new(1, -12, 0, 140),
                Position = UDim2.new(0, 6, 1, 6),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = self.Theme.Accent,
                BorderSizePixel = 0,
                Visible = false,
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = ListFrame, CornerRadius = UDim.new(0, 8)})
            local ListLayout = Create("UIListLayout", {
                Parent = ListFrame,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            end)

            local isOpen = false
            local function toggleList()
                isOpen = not isOpen
                ListFrame.Visible = isOpen
                Tween(DropFrame, 0.2, {Size = UDim2.new(1, 0, 0, isOpen and 190 or (multi and 50 or 44))})
                DropBtn.Text = "..."
                if not isOpen then
                    local display = multi and (#selected > 0 and tostring(#selected).." selected" or "None") or (selected or "None")
                    Tween(DropBtn, 0.2, {TextColor3 = self.Theme.Text})
                    DropBtn.Text = display
                end
            end

            DropBtn.MouseButton1Click:Connect(toggleList)

            local function rebuildList()
                for _, child in ListFrame:GetChildren() do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, opt in ipairs(options) do
                    local OptBtn = Create("TextButton", {
                        Parent = ListFrame,
                        BackgroundColor3 = self.Theme.Foreground,
                        Size = UDim2.new(1, 0, 0, 36),
                        Text = "  " .. opt,
                        TextColor3 = self.Theme.TextDark,
                        Font = Enum.Font.Gotham,
                        TextSize = 14,
                        BorderSizePixel = 0
                    })
                    Create("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 6)})
                    addHover(OptBtn, self.Theme.Foreground, self.Theme.SliderBg)

                    local isSel = multi and selected[opt] or selected == opt
                    local CheckIcon = Create("TextLabel", {
                        Parent = OptBtn,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 24, 1, 0),
                        Position = UDim2.new(1, -28, 0, 0),
                        Text = isSel and "✓" or "",
                        TextColor3 = self.Theme.Accent,
                        Font = Enum.Font.GothamBold,
                        TextSize = 16
                    })

                    OptBtn.MouseButton1Click:Connect(function()
                        if multi then
                            selected[opt] = not selected[opt]
                            CheckIcon.Text = selected[opt] and "✓" or ""
                        else
                            selected = opt
                            for _, btn in ListFrame:GetChildren() do
                                if btn:IsA("TextButton") then
                                    btn:FindFirstChildOfClass("TextLabel").Text = ""
                                end
                            end
                            CheckIcon.Text = "✓"
                        end
                        self.Flags[flag] = selected
                        task.spawn(callback, selected)
                        toggleList()
                    end)
                end
            end
            rebuildList()

            -- Close on outside click (simple)
            UserInputService.InputBegan:Connect(function(input)
                if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local pos = input.Position
                    if not DropFrame.AbsolutePosition:ExpandToPoint(DropFrame.AbsoluteSize):2DContainsPoint(pos) then
                        toggleList()
                    end
                end
            end)

            local dropObj = {
                Set = function(_, v)
                    selected = v
                    rebuildList()  -- Refresh checks
                end
            }
            self.Elements[flag] = dropObj
            return dropObj
        end

        -- Keybind
        function Section:NewKeybind(text, defaultKey, callback)
            local flag = getFlagPath(text)
            local currentKey = self.Flags[flag] or defaultKey or Enum.KeyCode.Unknown
            local KeyFrame = Create("Frame", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Foreground,
                Size = UDim2.new(1, 0, 0, 44),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = KeyFrame, CornerRadius = UDim.new(0, 8)})

            local KLabel = Create("TextLabel", {
                Parent = KeyFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -90, 1, 0),
                Text = text,
                TextColor3 = self.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })

            local KeyBtn = Create("TextButton", {
                Parent = KeyFrame,
                BackgroundColor3 = self.Theme.SliderBg,
                Size = UDim2.new(0, 72, 0, 32),
                Position = UDim2.new(1, -80, 0.5, -16),
                Text = currentKey.Name ~= "Unknown" and currentKey.Name or "NONE",
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = KeyBtn, CornerRadius = UDim.new(0, 6)})
            addHover(KeyBtn, self.Theme.SliderBg, self.Theme.Accent)

            local listening = false
            KeyBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                KeyBtn.Text = "..."
                Tween(KeyBtn, 0.2, {BackgroundColor3 = self.Theme.Accent})
                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    local key = input.KeyCode
                    if key == Enum.KeyCode.Unknown or key == Enum.KeyCode.Escape then
                        KeyBtn.Text = "NONE"
                        currentKey = Enum.KeyCode.Unknown
                    else
                        KeyBtn.Text = key.Name
                        currentKey = key
                    end
                    Tween(KeyBtn, 0.2, {BackgroundColor3 = self.Theme.SliderBg})
                    self.Flags[flag] = currentKey
                    task.spawn(callback, currentKey)
                    conn:Disconnect()
                    listening = false
                end)
            end)

            local keyObj = {
                Set = function(_, key)
                    currentKey = key
                    KeyBtn.Text = key.Name ~= "Unknown" and key.Name or "NONE"
                end
            }
            self.Elements[flag] = keyObj
            return keyObj
        end

        -- Colorpicker
        function Section:NewColorpicker(text, defaultColor, callback)
            defaultColor = defaultColor or Color3.fromRGB(255,255,255)
            local flag = getFlagPath(text)
            local color = self.Flags[flag] or {defaultColor.R * 255, defaultColor.G * 255, defaultColor.B * 255}
            local CPFrame = Create("Frame", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Foreground,
                Size = UDim2.new(1, 0, 0, 130),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = CPFrame, CornerRadius = UDim.new(0, 8)})

            local CPLabel = Create("TextLabel", {
                Parent = CPFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22),
                Text = text,
                TextColor3 = self.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })

            local Preview = Create("Frame", {
                Parent = CPFrame,
                BackgroundColor3 = Color3.fromRGB(color[1], color[2], color[3]),
                Size = UDim2.new(0, 40, 0, 32),
                Position = UDim2.new(0, 12, 0, 30),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Preview, CornerRadius = UDim.new(0, 6)})

            local RGBLabels = {}
            local RGBSliders = {}
            local rgbNames = {"R", "G", "B"}
            for i = 1, 3 do
                Create("TextLabel", {
                    Parent = CPFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 15, 0, 20),
                    Position = UDim2.new(0, 60 + (i-1)*80, 0, 38),
                    Text = rgbNames[i],
                    TextColor3 = self.Theme.TextDark,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14
                })
                local rgbValLabel = Create("TextLabel", {
                    Parent = CPFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(0, 140 + (i-1)*80, 0, 38),
                    Text = tostring(math.floor(color[i])),
                    TextColor3 = self.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.Gotham,
                    TextSize = 14
                })
                RGBLabels[i] = rgbValLabel

                local rgbBar = Create("Frame", {
                    Parent = CPFrame,
                    BackgroundColor3 = self.Theme.SliderBg,
                    Size = UDim2.new(0, 70, 0, 6),
                    Position = UDim2.new(0, 60 + (i-1)*80, 0, 62),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = rgbBar, CornerRadius = UDim.new(1, 0)})

                local rgbFill = Create("Frame", {
                    Parent = rgbBar,
                    BackgroundColor3 = Color3.fromRGB(i==1 and 255 or 0, i==2 and 255 or 0, i==3 and 255 or 0),
                    Size = UDim2.new(color[i]/255, 0, 1, 0),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = rgbFill, CornerRadius = UDim.new(1, 0)})
                RGBSliders[i] = {bar = rgbBar, fill = rgbFill}

                -- Slider logic (same as main slider)
                (function(barIndex)
                    local sData = {dragging = false, mouseConn = nil}
                    rgbBar.InputBegan:Connect(function(input)
                        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                        sData.dragging = true
                        sData.mouseConn = UserInputService.InputChanged:Connect(function(input)
                            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                            local mousePos = UserInputService:GetMouseLocation()
                            local barAbs = rgbBar.AbsolutePosition.X
                            local barSize = rgbBar.AbsoluteSize.X
                            local rel = math.clamp((mousePos.X - barAbs) / barSize, 0, 1)
                            color[barIndex] = math.floor(rel * 255 + 0.5)
                            updateColor()
                        end)
                    end)
                    local eConn = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sData.dragging = false
                            if sData.mouseConn then sData.mouseConn:Disconnect() sData.mouseConn = nil end
                            eConn:Disconnect()
                        end
                    end)
                end)(i)
            end

            local function updateColor()
                local c3 = Color3.fromRGB(color[1], color[2], color[3])
                Tween(Preview, 0.2, {BackgroundColor3 = c3})
                for i = 1, 3 do
                    local percent = color[i] / 255
                    Tween(RGBSliders[i].fill, 0.15, {Size = UDim2.new(percent, 0, 1, 0)})
                    RGBLabels[i].Text = tostring(color[i])
                end
                self.Flags[flag] = color
                task.spawn(callback, c3)
            end

            local cpObj = {
                Set = function(_, c3)
                    color = {c3.R * 255, c3.G * 255, c3.B * 255}
                    updateColor()
                end
            }
            self.Elements[flag] = cpObj
            updateColor()

            return cpObj
        end

        -- Label
        function Section:NewLabel(text)
            Create("TextLabel", {
                Parent = ContFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                Text = text,
                TextColor3 = self.Theme.TextDark,
                TextWrapped = true,
                Font = Enum.Font.Gotham,
                TextSize = 14
            })
        end

        -- Paragraph
        function Section:NewParagraph(text)
            Create("TextLabel", {
                Parent = ContFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 44),
                Text = text,
                TextColor3 = self.Theme.Text,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                Font = Enum.Font.Gotham,
                TextSize = 15
            })
        end

        -- Separator
        function Section:NewSeparator()
            local Sep = Create("Frame", {
                Parent = ContFrame,
                BackgroundColor3 = self.Theme.Border,
                Size = UDim2.new(1, 0, 0, 2),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Sep, CornerRadius = UDim.new(1, 0)})
        end

        ContLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SecFrame.Size = UDim2.new(1, -24, 0, ContLayout.AbsoluteContentSize.Y + 36)
        end)

        return Section
    end

    MinimizeBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

    Window:Notify("GrokUI v2.0 loaded! The best ever. 🚀", 3)

    return Window
end

return GrokUI