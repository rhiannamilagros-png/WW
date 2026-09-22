--// SCOOPHUB V2 GUI LIBRARY
--// Reusable shell based on the compact ScoopHub V2 layout.
--// Keeps the header, logo, Discord pill, left sidebar, search box,
--// tab placement, theme, responsive scaling, minimize/restore, and
--// two-column card layout. No game-specific automation is included.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

--------------------------------------------------
-- THEME
--------------------------------------------------

local Theme = {
    Bg = Color3.fromRGB(9, 5, 8),
    Panel = Color3.fromRGB(22, 10, 14),
    Line = Color3.fromRGB(154, 44, 53),
    Red = Color3.fromRGB(231, 47, 59),
    RedDark = Color3.fromRGB(145, 28, 39),
    Text = Color3.fromRGB(255, 111, 120),
    Dim = Color3.fromRGB(190, 73, 84),
    White = Color3.fromRGB(246, 244, 252),
    Muted = Color3.fromRGB(199, 170, 176),
    Success = Color3.fromRGB(99, 215, 163),
    Input = Color3.fromRGB(49, 41, 49),
    Surface2 = Color3.fromRGB(37, 17, 23),
    Surface3 = Color3.fromRGB(52, 31, 37),
    Stroke = Color3.fromRGB(179, 52, 63),
    Top = Color3.fromRGB(39, 11, 17),
    Mid = Color3.fromRGB(8, 5, 8),
    Low = Color3.fromRGB(34, 8, 11),
    Font = Enum.Font.GothamBold,
    Body = Enum.Font.Gotham,
}

Library.Theme = Theme

--------------------------------------------------
-- CONSTANTS
--------------------------------------------------

local DEFAULT_WIDTH = 690
local DEFAULT_HEIGHT = 445
local HEADER_HEIGHT = 38
local SIDEBAR_WIDTH = 132
local GAP = 8

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function new(className, props, parent)
    local object = Instance.new(className)

    for property, value in pairs(props or {}) do
        object[property] = value
    end

    if parent then
        object.Parent = parent
    end

    return object
end

local function corner(object, radius)
    new("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
    }, object)

    return object
end

local function stroke(object, color, transparency, thickness)
    return new("UIStroke", {
        Color = color or Theme.Line,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, object)
end

local function tween(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.14,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()

    return animation
end

local function textLabel(parent, text, position, size, textSize, color, font, alignment)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = tostring(text or ""),
        Position = position,
        Size = size,
        TextColor3 = color or Theme.White,
        Font = font or Theme.Body,
        TextSize = textSize or 10,
        TextXAlignment = alignment or Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

local function gradient(object, a, b, rotation)
    return new("UIGradient", {
        Color = ColorSequence.new(a, b),
        Rotation = rotation or 20,
    }, object)
end

local function panel(parent, position, size, title)
    local frame = corner(new("Frame", {
        Position = position,
        Size = size,
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        ClipsDescendants = false,
    }, parent), 7)

    gradient(
        frame,
        Color3.fromRGB(43, 17, 24),
        Color3.fromRGB(18, 8, 12),
        18
    )

    stroke(frame, Theme.Line, 0.22, 1.1)

    if title then
        textLabel(
            frame,
            title,
            UDim2.new(0, 9, 0, 5),
            UDim2.new(1, -18, 0, 14),
            10,
            Theme.Text,
            Theme.Font
        )
    end

    return frame
end

local function getGuiParent()
    local guiParent

    if type(gethui) == "function" then
        pcall(function()
            guiParent = gethui()
        end)
    end

    if not guiParent then
        guiParent = LocalPlayer:WaitForChild("PlayerGui")
    end

    return guiParent
end

local function normalizeList(value)
    local output = {}

    if type(value) ~= "table" then
        if value ~= nil then
            output[1] = tostring(value)
        end

        return output
    end

    if #value > 0 then
        for _, item in ipairs(value) do
            output[#output + 1] = tostring(item)
        end
    else
        for item, enabled in pairs(value) do
            if enabled then
                output[#output + 1] = tostring(item)
            end
        end
    end

    return output
end

local function listContains(list, value)
    for _, item in ipairs(list or {}) do
        if item == value then
            return true
        end
    end

    return false
end

local function formatSelection(values, emptyText)
    values = normalizeList(values)

    if #values == 0 then
        return emptyText or "Select options..."
    end

    if #values == 1 then
        return values[1]
    end

    if #values == 2 then
        return values[1] .. ", " .. values[2]
    end

    return values[1] .. ", " .. values[2] .. " +" .. tostring(#values - 2)
end

local function makeChevron(parent)
    local root = new("Frame", {
        Name = "Chevron",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -20, 0.5, -5),
        Size = UDim2.fromOffset(14, 10),
        ZIndex = 7,
    }, parent)

    new("Frame", {
        BackgroundColor3 = Theme.Muted,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, -2, 0.5, 0),
        Size = UDim2.fromOffset(7, 2),
        Rotation = 45,
        ZIndex = 8,
    }, root)

    new("Frame", {
        BackgroundColor3 = Theme.Muted,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 2, 0.5, 0),
        Size = UDim2.fromOffset(7, 2),
        Rotation = -45,
        ZIndex = 8,
    }, root)

    return root
end

--------------------------------------------------
-- WINDOW
--------------------------------------------------

function Library:CreateWindow(config)
    config = config or {}

    local guiName = config.GuiName or "ScoopHubV2Library"
    local guiParent = getGuiParent()

    -- Only remove this library's exact GUI name.
    local old = guiParent:FindFirstChild(guiName)

    if old then
        old:Destroy()
    end

    local width = tonumber(config.Width) or DEFAULT_WIDTH
    local height = tonumber(config.Height) or DEFAULT_HEIGHT

    local screenGui = new("ScreenGui", {
        Name = guiName,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = false,
    }, guiParent)

    local holder = new("Frame", {
        Name = "Holder",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(width, height),
        BackgroundTransparency = 1,
    }, screenGui)

    local scale = new("UIScale", {
        Scale = 1,
    }, holder)

    local shadow = new("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(4, 5, 8),
        ImageTransparency = 0.38,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
    }, holder)

    local main = corner(new("Frame", {
        Name = "Main",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, shadow), 8)

    stroke(main, Theme.Stroke, 0.86, 1)

    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Top),
            ColorSequenceKeypoint.new(0.52, Theme.Mid),
            ColorSequenceKeypoint.new(1, Theme.Low),
        }),
        Rotation = 16,
    }, main)

    --------------------------------------------------
    -- RESPONSIVE SCALE
    --------------------------------------------------

    local isMobile =
        UserInputService.TouchEnabled
        and (
            not UserInputService.KeyboardEnabled
            or not UserInputService.MouseEnabled
        )

    local function resize()
        local camera = workspace.CurrentCamera

        if not camera then
            return
        end

        local viewport = camera.ViewportSize
        local baseScale = math.min(
            (viewport.X - 24) / width,
            (viewport.Y - 24) / height
        )

        if isMobile then
            scale.Scale = math.clamp(baseScale * 0.80, 0.45, 0.80)
        else
            scale.Scale = math.clamp(baseScale, 0.55, 1)
        end
    end

    resize()

    local connections = {}

    local function track(connection)
        if connection then
            connections[#connections + 1] = connection
        end

        return connection
    end

    track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize))

    task.defer(function()
        if workspace.CurrentCamera then
            track(
                workspace.CurrentCamera
                    :GetPropertyChangedSignal("ViewportSize")
                    :Connect(resize)
            )
        end
    end)

    --------------------------------------------------
    -- HEADER
    --------------------------------------------------

    local header = new("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 50,
    }, main)

    new("ImageLabel", {
        Name = "Logo",
        Image = config.Logo or "rbxassetid://90541504618217",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -12),
        Size = UDim2.fromOffset(24, 24),
    }, header)

    textLabel(
        header,
        config.Title or "SCOOPHUB",
        UDim2.new(0, 40, 0, 5),
        UDim2.fromOffset(90, 16),
        14,
        Color3.fromRGB(242, 92, 101),
        Theme.Font
    )

    textLabel(
        header,
        config.Version or "V2",
        UDim2.new(0, 106, 0, 6),
        UDim2.fromOffset(42, 13),
        11,
        Theme.Muted,
        Theme.Body
    )

    textLabel(
        header,
        config.Subtitle or "by Scoop",
        UDim2.new(0, 40, 0, 20),
        UDim2.fromOffset(100, 13),
        10,
        Color3.fromRGB(166, 174, 187),
        Theme.Body
    )

    local discordPill = corner(new("Frame", {
        Name = "DiscordPill",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.55, 0, 0.5, 0),
        Size = UDim2.fromOffset(174, 22),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, header), 11)

    stroke(discordPill, Theme.Line, 0.62, 1)

    new("ImageLabel", {
        Name = "DiscordIcon",
        Image = config.DiscordIcon or "rbxassetid://94434236999817",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 8, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
    }, discordPill)

    local discordText = config.Discord or "discord.gg/WxgqUa9Qz"

    textLabel(
        discordPill,
        discordText,
        UDim2.new(0, 27, 0, 0),
        UDim2.new(1, -32, 1, 0),
        11,
        Theme.White,
        Theme.Font
    )

    local discordButton = new("TextButton", {
        Name = "DiscordButton",
        Text = "",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        AutoButtonColor = false,
    }, discordPill)

    local minimizeButton = corner(new("TextButton", {
        Name = "Minimize",
        Text = "-",
        Position = UDim2.new(1, -62, 0.5, -12),
        Size = UDim2.fromOffset(25, 25),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 0.22,
        TextColor3 = Theme.White,
        Font = Theme.Font,
        TextSize = 16,
        BorderSizePixel = 0,
        ZIndex = 52,
        AutoButtonColor = false,
    }, header), 5)

    local closeButton = corner(new("TextButton", {
        Name = "Close",
        Text = "X",
        Position = UDim2.new(1, -31, 0.5, -12),
        Size = UDim2.fromOffset(25, 25),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 0.22,
        TextColor3 = Theme.White,
        Font = Theme.Font,
        TextSize = 14,
        BorderSizePixel = 0,
        ZIndex = 52,
        AutoButtonColor = false,
    }, header), 5)

    new("Frame", {
        Position = UDim2.new(0, 8, 0, HEADER_HEIGHT),
        Size = UDim2.new(1, -16, 0, 1),
        BackgroundColor3 = Theme.Red,
        BackgroundTransparency = 0.42,
        BorderSizePixel = 0,
    }, main)

    --------------------------------------------------
    -- BODY / SIDEBAR
    --------------------------------------------------

    local body = new("Frame", {
        Name = "Body",
        Position = UDim2.new(0, GAP, 0, HEADER_HEIGHT + GAP),
        Size = UDim2.new(1, -GAP * 2, 1, -HEADER_HEIGHT - GAP * 2),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
    }, main)

    local side = panel(
        body,
        UDim2.new(0, 0, 0, 0),
        UDim2.new(0, SIDEBAR_WIDTH, 1, 0)
    )

    local searchBox = corner(new("TextBox", {
        Name = "TabSearch",
        Position = UDim2.fromOffset(6, 7),
        Size = UDim2.new(1, -12, 0, 29),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = config.SearchPlaceholder or "Search...",
        PlaceholderColor3 = Theme.Muted,
        TextColor3 = Theme.White,
        Font = Theme.Body,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 410,
    }, side), 5)

    stroke(searchBox, Theme.Line, 0.55, 1)

    new("UIPadding", {
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 7),
    }, searchBox)

    local nav = new("ScrollingFrame", {
        Name = "Navigation",
        Position = UDim2.fromOffset(6, 42),
        Size = UDim2.new(1, -12, 1, -49),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Red,
    }, side)

    local navLayout = new("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, nav)

    local pages = {}
    local tabs = {}
    local tabOrder = {}
    local activeTab = nil
    local activeDropdown = nil

    --------------------------------------------------
    -- TAB SEARCH
    --------------------------------------------------

    local function updateNavCanvas()
        nav.CanvasSize = UDim2.new(
            0,
            0,
            0,
            navLayout.AbsoluteContentSize.Y + 4
        )
    end

    track(navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateNavCanvas))

    local function filterTabs()
        local query = string.lower(searchBox.Text or "")

        for _, name in ipairs(tabOrder) do
            local tab = tabs[name]

            if tab and tab.NavButton then
                tab.NavButton.Visible =
                    query == ""
                    or string.find(
                        string.lower(name),
                        query,
                        1,
                        true
                    ) ~= nil
            end
        end

        task.defer(updateNavCanvas)
    end

    track(searchBox:GetPropertyChangedSignal("Text"):Connect(filterTabs))

    --------------------------------------------------
    -- ACTIVE DROPDOWN
    --------------------------------------------------

    local function closeActiveDropdown()
        if activeDropdown and activeDropdown.Close then
            activeDropdown:Close()
        end

        activeDropdown = nil
    end

    --------------------------------------------------
    -- WINDOW OBJECT
    --------------------------------------------------

    local window = {
        ScreenGui = screenGui,
        Holder = holder,
        Main = main,
        Header = header,
        Body = body,
        Sidebar = side,
        SearchBox = searchBox,
        Tabs = tabs,
        Theme = Theme,
        Closed = false,
    }

    --------------------------------------------------
    -- TAB SWITCHING
    --------------------------------------------------

    local function openTab(name)
        if not pages[name] then
            return
        end

        closeActiveDropdown()
        activeTab = name

        for tabName, page in pairs(pages) do
            page.Visible = tabName == name
        end

        for tabName, tab in pairs(tabs) do
            local enabled = tabName == name

            tab.ActiveBar.Visible = enabled

            tween(tab.NavButton, {
                BackgroundTransparency = enabled and 0.28 or 1,
            })

            tween(tab.NavText, {
                TextColor3 = enabled and Theme.Text or Theme.White,
            })

            tween(tab.IconBackground, {
                BackgroundColor3 = enabled and Theme.Red or Theme.Surface2,
            })
        end
    end

    function window:SelectTab(name)
        openTab(name)
    end

    --------------------------------------------------
    -- ADD TAB
    --------------------------------------------------

    function window:AddTab(tabConfig)
        if type(tabConfig) == "string" then
            tabConfig = {
                Name = tabConfig,
            }
        else
            tabConfig = tabConfig or {}
        end

        local name = tostring(tabConfig.Name or ("Tab " .. tostring(#tabOrder + 1)))

        if tabs[name] then
            return tabs[name]
        end

        local navButton = corner(new("TextButton", {
            Name = "Nav_" .. name,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Surface2,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = #tabOrder + 1,
        }, nav), 5)

        local activeBar = corner(new("Frame", {
            Position = UDim2.new(0, 0, 0.5, -12),
            Size = UDim2.fromOffset(3, 24),
            BackgroundColor3 = Theme.Red,
            BorderSizePixel = 0,
            Visible = false,
        }, navButton), 2)

        local iconBackground = corner(new("Frame", {
            Position = UDim2.new(0, 6, 0.5, -13),
            Size = UDim2.fromOffset(27, 27),
            BackgroundColor3 = Theme.Surface2,
            BorderSizePixel = 0,
        }, navButton), 5)

        stroke(iconBackground, Theme.Stroke, 0.75, 1)

        new("ImageLabel", {
            Name = "Icon",
            Image = tabConfig.Icon or "",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ScaleType = Enum.ScaleType.Fit,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.fromOffset(17, 17),
        }, iconBackground)

        local navText = textLabel(
            navButton,
            string.upper(name),
            UDim2.new(0, 39, 0, 0),
            UDim2.new(1, -44, 1, 0),
            10,
            Theme.White,
            Theme.Font
        )

        local page = new("Frame", {
            Name = name,
            Position = UDim2.new(0, SIDEBAR_WIDTH + GAP, 0, 0),
            Size = UDim2.new(1, -SIDEBAR_WIDTH - GAP, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ClipsDescendants = false,
        }, body)

        local titleLabel = textLabel(
            page,
            string.upper(tabConfig.Title or name),
            UDim2.new(0, 8, 0, 1),
            UDim2.new(0.52, 0, 0, 20),
            11,
            Theme.Text,
            Theme.Font
        )

        local statusLabel = textLabel(
            page,
            tabConfig.Status or "",
            UDim2.new(0.52, 0, 0, 1),
            UDim2.new(0.48, -8, 0, 20),
            9,
            Theme.Success,
            Theme.Font,
            Enum.TextXAlignment.Right
        )

        local scroll = new("ScrollingFrame", {
            Name = "ContentScroll",
            Position = UDim2.new(0, 0, 0, 24),
            Size = UDim2.new(1, -4, 1, -24),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Red,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ClipsDescendants = false,
        }, page)

        local leftColumn = new("Frame", {
            Name = "LeftColumn",
            Position = UDim2.new(0, 4, 0, 4),
            Size = UDim2.new(0.5, -8, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
        }, scroll)

        local rightColumn = new("Frame", {
            Name = "RightColumn",
            Position = UDim2.new(0.5, 4, 0, 4),
            Size = UDim2.new(0.5, -8, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
        }, scroll)

        local leftLayout = new("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, leftColumn)

        local rightLayout = new("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, rightColumn)

        local tab = {
            Name = name,
            Page = page,
            Scroll = scroll,
            LeftColumn = leftColumn,
            RightColumn = rightColumn,
            LeftLayout = leftLayout,
            RightLayout = rightLayout,
            TitleLabel = titleLabel,
            StatusLabel = statusLabel,
            NavButton = navButton,
            ActiveBar = activeBar,
            IconBackground = iconBackground,
            NavText = navText,
            SectionCount = 0,
            LeftSectionCount = 0,
            RightSectionCount = 0,
        }

        pages[name] = page
        tabs[name] = tab
        tabOrder[#tabOrder + 1] = name

        local function updateCanvas()
            local leftHeight = leftLayout.AbsoluteContentSize.Y
            local rightHeight = rightLayout.AbsoluteContentSize.Y

            scroll.CanvasSize = UDim2.new(
                0,
                0,
                0,
                math.max(leftHeight, rightHeight) + 12
            )
        end

        track(leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas))
        track(rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas))

        function tab:SetStatus(text, mode)
            statusLabel.Text = tostring(text or "")

            if mode == "Success" or mode == true then
                statusLabel.TextColor3 = Theme.Success
            elseif mode == "Error" or mode == false then
                statusLabel.TextColor3 = Theme.Red
            else
                statusLabel.TextColor3 = Theme.Muted
            end
        end

        function tab:SetTitle(text)
            titleLabel.Text = string.upper(tostring(text or name))
        end

        --------------------------------------------------
        -- ADD SECTION / CARD
        --------------------------------------------------

        function tab:AddSection(sectionConfig, column)
            if type(sectionConfig) == "string" then
                sectionConfig = {
                    Title = sectionConfig,
                    Column = column,
                }
            else
                sectionConfig = sectionConfig or {}
            end

            self.SectionCount += 1

            local selectedColumn = sectionConfig.Column

            if selectedColumn == nil then
                selectedColumn =
                    self.LeftLayout.AbsoluteContentSize.Y
                        <= self.RightLayout.AbsoluteContentSize.Y
                    and 1
                    or 2
            end

            if selectedColumn == "Left" or selectedColumn == "left" then
                selectedColumn = 1
            elseif selectedColumn == "Right" or selectedColumn == "right" then
                selectedColumn = 2
            end

            local parentColumn =
                selectedColumn == 2
                and self.RightColumn
                or self.LeftColumn

            if selectedColumn == 2 then
                self.RightSectionCount += 1
            else
                self.LeftSectionCount += 1
            end

            local card = panel(
                parentColumn,
                UDim2.new(),
                UDim2.new(1, 0, 0, 42),
                string.upper(tostring(sectionConfig.Title or "SECTION"))
            )

            card.LayoutOrder =
                selectedColumn == 2
                and self.RightSectionCount
                or self.LeftSectionCount

            if sectionConfig.Badge then
                local badge = corner(new("Frame", {
                    BackgroundColor3 = sectionConfig.BadgeColor or Theme.RedDark,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -88, 0, 6),
                    Size = UDim2.fromOffset(78, 15),
                }, card), 999)

                stroke(
                    badge,
                    sectionConfig.BadgeColor or Theme.Line,
                    0.45,
                    1
                )

                textLabel(
                    badge,
                    tostring(sectionConfig.Badge),
                    UDim2.new(),
                    UDim2.fromScale(1, 1),
                    8,
                    Theme.White,
                    Theme.Font,
                    Enum.TextXAlignment.Center
                )
            end

            new("Frame", {
                BackgroundColor3 = Theme.Line,
                BackgroundTransparency = 0.55,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 22),
                Size = UDim2.new(1, -20, 0, 1),
            }, card)

            local content = new("Frame", {
                Name = "Content",
                Position = UDim2.new(0, 10, 0, 29),
                Size = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
            }, card)

            local contentLayout = new("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, content)

            local section = {
                Card = card,
                Content = content,
                Layout = contentLayout,
                RowCount = 0,
            }

            local function updateCardHeight()
                card.Size = UDim2.new(
                    1,
                    0,
                    0,
                    contentLayout.AbsoluteContentSize.Y + 38
                )

                task.defer(updateCanvas)
            end

            track(
                contentLayout
                    :GetPropertyChangedSignal("AbsoluteContentSize")
                    :Connect(updateCardHeight)
            )

            local function createRow(height)
                section.RowCount += 1

                return new("Frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, height),
                    LayoutOrder = section.RowCount,
                }, content)
            end

            local function addTitleSubtitle(row, title, subtitle, reserveRight)
                local right = reserveRight or 0

                textLabel(
                    row,
                    title or "",
                    UDim2.new(0, 0, 0, 0),
                    UDim2.new(1, -right, 0, 16),
                    11,
                    Theme.White,
                    Theme.Font
                )

                if subtitle and subtitle ~= "" then
                    textLabel(
                        row,
                        subtitle,
                        UDim2.new(0, 0, 0, 16),
                        UDim2.new(1, -right, 0, 14),
                        9,
                        Theme.Muted,
                        Theme.Body
                    )
                end
            end

            --------------------------------------------------
            -- SUB SECTION
            --------------------------------------------------

            function section:AddSubSection(text)
                local row = createRow(18)

                textLabel(
                    row,
                    string.upper(tostring(text or "")),
                    UDim2.new(),
                    UDim2.fromScale(1, 1),
                    9,
                    Theme.Text,
                    Theme.Font
                )

                return row
            end

            --------------------------------------------------
            -- TOGGLE
            --------------------------------------------------

            function section:AddToggle(controlConfig)
                controlConfig = controlConfig or {}

                local row = createRow(34)

                addTitleSubtitle(
                    row,
                    controlConfig.Title or "Toggle",
                    controlConfig.Content or controlConfig.Subtitle,
                    62
                )

                local state = controlConfig.Default == true

                local button = corner(new("TextButton", {
                    Text = "",
                    BackgroundColor3 = state and Theme.Success or Theme.RedDark,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Position = UDim2.new(1, -48, 0, 5),
                    Size = UDim2.fromOffset(44, 22),
                }, row), 10)

                local knob = corner(new("Frame", {
                    BackgroundColor3 = Theme.White,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position =
                        state
                        and UDim2.new(1, -19, 0.5, 0)
                        or UDim2.new(0, 3, 0.5, 0),
                    Size = UDim2.fromOffset(16, 16),
                }, button), 8)

                local api = {}

                function api:Set(value, fireCallback)
                    state = value == true

                    button.BackgroundColor3 =
                        state
                        and Theme.Success
                        or Theme.RedDark

                    tween(knob, {
                        Position =
                            state
                            and UDim2.new(1, -19, 0.5, 0)
                            or UDim2.new(0, 3, 0.5, 0),
                    }, 0.12)

                    if fireCallback ~= false
                        and type(controlConfig.Callback) == "function"
                    then
                        controlConfig.Callback(state)
                    end
                end

                function api:Get()
                    return state
                end

                track(button.Activated:Connect(function()
                    api:Set(not state, true)
                end))

                return api
            end

            --------------------------------------------------
            -- INPUT
            --------------------------------------------------

            function section:AddInput(controlConfig)
                controlConfig = controlConfig or {}

                local row = createRow(50)

                textLabel(
                    row,
                    controlConfig.Title or "Input",
                    UDim2.new(),
                    UDim2.new(1, 0, 0, 14),
                    10,
                    Theme.Muted,
                    Theme.Font
                )

                local box = corner(new("TextBox", {
                    Text = tostring(controlConfig.Default or ""),
                    PlaceholderText = controlConfig.Placeholder or "Input value",
                    ClearTextOnFocus = false,
                    Font = Theme.Font,
                    TextSize = 11,
                    TextColor3 = Theme.White,
                    PlaceholderColor3 = Theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Theme.Input,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 18),
                    Size = UDim2.new(1, 0, 0, 29),
                }, row), 5)

                new("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                }, box)

                stroke(box, Theme.Stroke, 0.75, 1)

                local api = {}

                function api:Set(value, fireCallback)
                    box.Text = tostring(value or "")

                    if fireCallback == true
                        and type(controlConfig.Callback) == "function"
                    then
                        controlConfig.Callback(box.Text, box)
                    end
                end

                function api:Get()
                    return box.Text
                end

                track(box.FocusLost:Connect(function(enterPressed)
                    if type(controlConfig.Callback) == "function" then
                        controlConfig.Callback(
                            box.Text,
                            box,
                            enterPressed
                        )
                    end
                end))

                return api
            end

            --------------------------------------------------
            -- BUTTON
            --------------------------------------------------

            function section:AddButton(controlConfig)
                if type(controlConfig) == "string" then
                    controlConfig = {
                        Title = controlConfig,
                    }
                else
                    controlConfig = controlConfig or {}
                end

                local row = createRow(
                    controlConfig.Content and 45 or 32
                )

                if controlConfig.Content then
                    addTitleSubtitle(
                        row,
                        controlConfig.Title or "Button",
                        controlConfig.Content,
                        110
                    )
                end

                local button

                if controlConfig.Content then
                    button = corner(new("TextButton", {
                        Text = controlConfig.ButtonText or "RUN",
                        Font = Theme.Font,
                        TextSize = 10,
                        TextColor3 = Theme.White,
                        BackgroundColor3 = controlConfig.Color or Theme.RedDark,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        Position = UDim2.new(1, -100, 0, 5),
                        Size = UDim2.fromOffset(96, 27),
                    }, row), 5)
                else
                    button = corner(new("TextButton", {
                        Text = controlConfig.ButtonText or controlConfig.Title or "BUTTON",
                        Font = Theme.Font,
                        TextSize = 10,
                        TextColor3 = Theme.White,
                        BackgroundColor3 = controlConfig.Color or Theme.RedDark,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        Size = UDim2.new(1, 0, 0, 29),
                    }, row), 5)
                end

                stroke(button, Theme.Line, 0.55, 1)

                track(button.Activated:Connect(function()
                    if type(controlConfig.Callback) == "function" then
                        controlConfig.Callback()
                    end
                end))

                local api = {}

                function api:SetText(value)
                    button.Text = tostring(value or "")
                end

                api.Button = button

                return api
            end

            --------------------------------------------------
            -- PARAGRAPH / INFO
            --------------------------------------------------

            function section:AddParagraph(controlConfig)
                controlConfig = controlConfig or {}

                local lines =
                    math.max(
                        1,
                        select(
                            2,
                            tostring(controlConfig.Content or ""):gsub("\n", "\n")
                        ) + 1
                    )

                local row = createRow(20 + lines * 14)

                local title = textLabel(
                    row,
                    controlConfig.Title or "",
                    UDim2.new(),
                    UDim2.new(1, 0, 0, 15),
                    10,
                    Theme.Text,
                    Theme.Font
                )

                local contentLabel = textLabel(
                    row,
                    controlConfig.Content or "",
                    UDim2.new(0, 0, 0, 17),
                    UDim2.new(1, 0, 0, lines * 14),
                    9,
                    Theme.Muted,
                    Theme.Body
                )

                contentLabel.TextWrapped = true
                contentLabel.TextYAlignment = Enum.TextYAlignment.Top

                local api = {}

                function api:Set(value)
                    if type(value) == "table" then
                        if value.Title ~= nil then
                            title.Text = tostring(value.Title)
                        end

                        if value.Content ~= nil then
                            contentLabel.Text = tostring(value.Content)
                        end
                    else
                        contentLabel.Text = tostring(value or "")
                    end
                end

                return api
            end

            --------------------------------------------------
            -- DROPDOWN
            --------------------------------------------------

            function section:AddDropdown(controlConfig)
                controlConfig = controlConfig or {}

                local row = createRow(50)

                textLabel(
                    row,
                    controlConfig.Title or "Dropdown",
                    UDim2.new(),
                    UDim2.new(1, 0, 0, 14),
                    10,
                    Theme.Muted,
                    Theme.Font
                )

                local selector = corner(new("TextButton", {
                    Text = "",
                    BackgroundColor3 = Theme.Input,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 0, 0, 18),
                    Size = UDim2.new(1, 0, 0, 29),
                    ClipsDescendants = true,
                }, row), 5)

                stroke(selector, Theme.Stroke, 0.75, 1)

                local selectorText = textLabel(
                    selector,
                    controlConfig.EmptyText or controlConfig.Placeholder or "Select options...",
                    UDim2.new(0, 8, 0, 0),
                    UDim2.new(1, -30, 1, 0),
                    11,
                    Theme.White,
                    Theme.Body
                )

                local chevron = makeChevron(selector)

                local multi = controlConfig.Multi == true
                local options = normalizeList(controlConfig.Options or {})
                local selected = normalizeList(controlConfig.Default or {})

                if not multi and #selected > 1 then
                    selected = { selected[1] }
                end

                local popup = corner(new("Frame", {
                    Name = "DropdownPopup",
                    Visible = false,
                    BackgroundColor3 = Theme.Surface2,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Size = UDim2.fromOffset(220, 220),
                    ZIndex = 800,
                }, page), 6)

                stroke(popup, Theme.Red, 0, 1.4)

                local popupSearch = corner(new("TextBox", {
                    Name = "DropdownSearch",
                    Text = "",
                    PlaceholderText = controlConfig.SearchPlaceholder or "Search...",
                    Font = Theme.Body,
                    TextSize = 12,
                    TextColor3 = Theme.White,
                    PlaceholderColor3 = Theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Theme.Surface3,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    Position = UDim2.new(0, 4, 0, 4),
                    Size = UDim2.new(1, -8, 0, 26),
                    ZIndex = 801,
                }, popup), 5)

                new("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                }, popupSearch)

                local actions = new("Frame", {
                    Name = "Actions",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 4, 0, 34),
                    Size = UDim2.new(1, -8, 0, 26),
                    Visible = multi,
                    ZIndex = 801,
                }, popup)

                local selectAll = corner(new("TextButton", {
                    Text = "SELECT ALL",
                    Font = Theme.Font,
                    TextSize = 10,
                    TextColor3 = Theme.White,
                    BackgroundColor3 = Theme.RedDark,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0.5, -2, 1, 0),
                    ZIndex = 802,
                }, actions), 4)

                local clearAll = corner(new("TextButton", {
                    Text = "CLEAR ALL",
                    Font = Theme.Font,
                    TextSize = 10,
                    TextColor3 = Theme.White,
                    BackgroundColor3 = Theme.Surface3,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Position = UDim2.new(0.5, 2, 0, 0),
                    Size = UDim2.new(0.5, -2, 1, 0),
                    ZIndex = 802,
                }, actions), 4)

                local optionScroll = new("ScrollingFrame", {
                    Name = "Options",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 4, 0, multi and 64 or 34),
                    Size = UDim2.new(1, -8, 1, multi and -68 or -38),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Theme.Red,
                    ZIndex = 801,
                }, popup)

                local optionLayout = new("UIListLayout", {
                    Padding = UDim.new(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }, optionScroll)

                local dropdownApi = {
                    Popup = popup,
                }

                local function updateSelectorText()
                    selectorText.Text =
                        formatSelection(
                            selected,
                            controlConfig.EmptyText
                                or controlConfig.Placeholder
                                or "Select options..."
                        )
                end

                local function fireCallback()
                    if type(controlConfig.Callback) == "function" then
                        if multi then
                            controlConfig.Callback(normalizeList(selected))
                        else
                            controlConfig.Callback(selected[1])
                        end
                    end
                end

                local function rebuildOptions()
                    for _, child in ipairs(optionScroll:GetChildren()) do
                        if not child:IsA("UIListLayout") then
                            child:Destroy()
                        end
                    end

                    local query =
                        string.lower(
                            tostring(popupSearch.Text or "")
                        )

                    local count = 0

                    for _, option in ipairs(options) do
                        if query == ""
                            or string.find(
                                string.lower(option),
                                query,
                                1,
                                true
                            )
                        then
                            count += 1

                            local isSelected =
                                listContains(selected, option)

                            local optionButton = corner(new("TextButton", {
                                Text = "",
                                BackgroundColor3 =
                                    isSelected
                                    and Color3.fromRGB(56, 25, 32)
                                    or Theme.Surface3,
                                BorderSizePixel = 0,
                                AutoButtonColor = false,
                                Size = UDim2.new(1, -3, 0, 28),
                                LayoutOrder = count,
                                ZIndex = 802,
                            }, optionScroll), 4)

                            local check = textLabel(
                                optionButton,
                                isSelected and "✓" or "",
                                UDim2.new(0, 7, 0, 0),
                                UDim2.fromOffset(18, 28),
                                12,
                                Theme.Success,
                                Theme.Font,
                                Enum.TextXAlignment.Center
                            )

                            check.ZIndex = 803

                            local optionText = textLabel(
                                optionButton,
                                option,
                                UDim2.new(0, 30, 0, 0),
                                UDim2.new(1, -35, 1, 0),
                                10,
                                Theme.White,
                                Theme.Body
                            )

                            optionText.ZIndex = 803

                            track(optionButton.Activated:Connect(function()
                                if multi then
                                    if listContains(selected, option) then
                                        local replacement = {}

                                        for _, value in ipairs(selected) do
                                            if value ~= option then
                                                replacement[#replacement + 1] = value
                                            end
                                        end

                                        selected = replacement
                                    else
                                        selected[#selected + 1] = option
                                    end

                                    updateSelectorText()
                                    rebuildOptions()
                                    fireCallback()
                                else
                                    selected = { option }
                                    updateSelectorText()
                                    fireCallback()
                                    dropdownApi:Close()
                                end
                            end))
                        end
                    end

                    optionScroll.CanvasSize =
                        UDim2.new(
                            0,
                            0,
                            0,
                            optionLayout.AbsoluteContentSize.Y + 4
                        )
                end

                function dropdownApi:Close()
                    popup.Visible = false
                    tween(chevron, {
                        Rotation = 0,
                    }, 0.14)

                    if activeDropdown == self then
                        activeDropdown = nil
                    end
                end

                function dropdownApi:Open()
                    if activeDropdown
                        and activeDropdown ~= self
                        and activeDropdown.Close
                    then
                        activeDropdown:Close()
                    end

                    activeDropdown = self

                    local selectorPosition = selector.AbsolutePosition
                    local pagePosition = page.AbsolutePosition

                    local relativeX =
                        selectorPosition.X - pagePosition.X

                    local relativeY =
                        selectorPosition.Y - pagePosition.Y
                        + selector.AbsoluteSize.Y
                        + 4

                    local popupWidth =
                        math.max(
                            180,
                            selector.AbsoluteSize.X
                        )

                    local popupHeight =
                        math.min(
                            230,
                            (multi and 68 or 38)
                                + math.max(
                                    32,
                                    math.min(#options, 6) * 31
                                )
                        )

                    popup.Position =
                        UDim2.fromOffset(
                            relativeX,
                            relativeY
                        )

                    popup.Size =
                        UDim2.fromOffset(
                            popupWidth,
                            popupHeight
                        )

                    popupSearch.Text = ""
                    rebuildOptions()
                    popup.Visible = true

                    tween(chevron, {
                        Rotation = 180,
                    }, 0.14)
                end

                function dropdownApi:Set(value, fire)
                    selected = normalizeList(value)

                    if not multi and #selected > 1 then
                        selected = { selected[1] }
                    end

                    updateSelectorText()

                    if popup.Visible then
                        rebuildOptions()
                    end

                    if fire == true then
                        fireCallback()
                    end
                end

                function dropdownApi:Get()
                    if multi then
                        return normalizeList(selected)
                    end

                    return selected[1]
                end

                function dropdownApi:SetOptions(newOptions, preserveSelection)
                    options = normalizeList(newOptions)

                    if preserveSelection ~= true then
                        selected = {}
                    else
                        local filtered = {}

                        for _, value in ipairs(selected) do
                            if listContains(options, value) then
                                filtered[#filtered + 1] = value
                            end
                        end

                        selected = filtered
                    end

                    updateSelectorText()

                    if popup.Visible then
                        rebuildOptions()
                    end
                end

                function dropdownApi:Refresh(newOptions, newSelection)
                    if newOptions ~= nil then
                        options = normalizeList(newOptions)
                    end

                    if newSelection ~= nil then
                        selected = normalizeList(newSelection)
                    end

                    if not multi and #selected > 1 then
                        selected = { selected[1] }
                    end

                    updateSelectorText()

                    if popup.Visible then
                        rebuildOptions()
                    end
                end

                track(selector.Activated:Connect(function()
                    if popup.Visible then
                        dropdownApi:Close()
                    else
                        dropdownApi:Open()
                    end
                end))

                track(popupSearch:GetPropertyChangedSignal("Text"):Connect(rebuildOptions))

                track(selectAll.Activated:Connect(function()
                    if multi then
                        selected = normalizeList(options)
                        updateSelectorText()
                        rebuildOptions()
                        fireCallback()
                    end
                end))

                track(clearAll.Activated:Connect(function()
                    selected = {}
                    updateSelectorText()
                    rebuildOptions()
                    fireCallback()
                end))

                updateSelectorText()

                return dropdownApi
            end

            updateCardHeight()

            return section
        end

        tab.AddCard = tab.AddSection

        track(navButton.Activated:Connect(function()
            openTab(name)
        end))

        if not activeTab then
            openTab(name)
        end

        updateNavCanvas()

        return tab
    end

    --------------------------------------------------
    -- DISCORD BUTTON
    --------------------------------------------------

    track(discordButton.Activated:Connect(function()
        if type(setclipboard) == "function" then
            pcall(function()
                setclipboard(discordText)
            end)
        end

        if type(config.OnDiscordClick) == "function" then
            config.OnDiscordClick(discordText)
        end
    end))

    --------------------------------------------------
    -- MINIMIZE / RESTORE
    --------------------------------------------------

    local minimized = false
    local expandedPosition = holder.Position
    local miniPosition = nil

    local miniLauncher = corner(new("TextButton", {
        Name = "MiniLauncher",
        Visible = false,
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = holder.Position,
        Size = UDim2.fromOffset(48, 48),
        BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.03,
        BorderSizePixel = 0,
        ZIndex = 500,
    }, screenGui), 12)

    stroke(miniLauncher, Theme.Red, 0.35, 1)

    new("ImageLabel", {
        Name = "MiniLauncherLogo",
        Image = config.Logo or "rbxassetid://90541504618217",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(36, 36),
        ZIndex = 501,
    }, miniLauncher)

    local function minimizedPosition()
        local camera = workspace.CurrentCamera

        if not camera then
            return expandedPosition
        end

        local viewport = camera.ViewportSize
        local pos = minimizeButton.AbsolutePosition
        local size = minimizeButton.AbsoluteSize

        return UDim2.fromOffset(
            math.clamp(
                pos.X + size.X / 2,
                28,
                viewport.X - 28
            ),
            math.clamp(
                pos.Y + size.Y / 2,
                28,
                viewport.Y - 28
            )
        )
    end

    local function setMinimized(value)
        minimized = value == true
        closeActiveDropdown()

        if minimized then
            expandedPosition = holder.Position

            if not miniPosition then
                miniPosition = minimizedPosition()
            end

            miniLauncher.Position = miniPosition
            miniLauncher.Visible = true
            holder.Visible = false
        else
            miniPosition = miniLauncher.Position
            holder.Position = expandedPosition
            holder.Visible = true
            miniLauncher.Visible = false
        end
    end

    track(minimizeButton.Activated:Connect(function()
        setMinimized(not minimized)
    end))

    --------------------------------------------------
    -- DRAGGING
    --------------------------------------------------

    local function makeDraggable(handle, frame, onMoved)
        local dragging = false
        local dragStart
        local startPosition
        local touchInput

        track(handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                dragging = true
                dragStart = input.Position
                startPosition = frame.Position

                if input.UserInputType == Enum.UserInputType.Touch then
                    touchInput = input
                else
                    touchInput = nil
                end
            end
        end))

        track(UserInputService.InputEnded:Connect(function(input)
            local mouseEnded =
                input.UserInputType == Enum.UserInputType.MouseButton1
                and touchInput == nil

            local touchEnded =
                input.UserInputType == Enum.UserInputType.Touch
                and input == touchInput

            if mouseEnded or touchEnded then
                dragging = false
                touchInput = nil
            end
        end))

        track(UserInputService.InputChanged:Connect(function(input)
            if not dragging
                or not dragStart
                or not startPosition
            then
                return
            end

            local mouseMove =
                input.UserInputType == Enum.UserInputType.MouseMovement
                and touchInput == nil

            local touchMove =
                input.UserInputType == Enum.UserInputType.Touch
                and input == touchInput

            if not mouseMove and not touchMove then
                return
            end

            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )

            if onMoved then
                onMoved(frame.Position)
            end
        end))
    end

    makeDraggable(header, holder, function(position)
        expandedPosition = position
    end)

    makeDraggable(miniLauncher, miniLauncher, function(position)
        miniPosition = position
    end)

    track(miniLauncher.Activated:Connect(function()
        setMinimized(false)
    end))

    --------------------------------------------------
    -- CLOSE / DESTROY
    --------------------------------------------------

    function window:Destroy()
        if self.Closed then
            return
        end

        self.Closed = true
        closeActiveDropdown()

        for index = #connections, 1, -1 do
            local connection = connections[index]

            pcall(function()
                connection:Disconnect()
            end)

            connections[index] = nil
        end

        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end

    track(closeButton.Activated:Connect(function()
        if type(config.OnClose) == "function" then
            pcall(config.OnClose)
        end

        window:Destroy()
    end))

    return window
end

return setmetatable({}, Library)
