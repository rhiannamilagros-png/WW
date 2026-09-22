-- ScoopHub V2.2 exact-source GUI library (fixed red)
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local TeleportService=game:GetService("TeleportService")
local HttpService=game:GetService("HttpService")
local LP=Players.LocalPlayer

local Library={Unloaded=false,Build="SCOOPHUB_V2_2_STABLE_SECRET_INPUT_FIX"}

local T={
 Bg=Color3.fromRGB(9,5,8),Panel=Color3.fromRGB(22,10,14),
 Line=Color3.fromRGB(154,44,53),Red=Color3.fromRGB(231,47,59),
 RedDark=Color3.fromRGB(145,28,39),Text=Color3.fromRGB(255,111,120),
 Dim=Color3.fromRGB(190,73,84),White=Color3.fromRGB(246,244,252),
 Muted=Color3.fromRGB(199,170,176),Success=Color3.fromRGB(99,215,163),
 Input=Color3.fromRGB(49,41,49),Surface2=Color3.fromRGB(37,17,23),
 Surface3=Color3.fromRGB(52,31,37),Stroke=Color3.fromRGB(179,52,63),
 Top=Color3.fromRGB(39,11,17),Mid=Color3.fromRGB(8,5,8),
 Low=Color3.fromRGB(34,8,11),Tab=Color3.fromRGB(35,16,22),
 Font=Enum.Font.GothamBold,Body=Enum.Font.Gotham
}
Library.Theme=T

local W,H=690,445
local HEADER,SIDE,GAP=38,132,8
local USER_SOFT=Color3.fromRGB(92,67,72)
local USER_BUTTON=Color3.fromRGB(50,14,18)
local USER_BUTTON_HOVER=Color3.fromRGB(74,18,24)

local function N(c,p,par)
 local x=Instance.new(c)
 for k,v in pairs(p or {}) do x[k]=v end
 x.Parent=par
 return x
end
local function C(x,r) N("UICorner",{CornerRadius=UDim.new(0,r or 6)},x) return x end
local function S(x,col,tr,th) return N("UIStroke",{Color=col or T.Line,Transparency=tr or 0,Thickness=th or 1},x) end
local function tw(x,p,t) local z=TS:Create(x,TweenInfo.new(t or .14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p);z:Play();return z end
local function label(par,text,pos,size,ts,col,font,align)
 return N("TextLabel",{BackgroundTransparency=1,Text=tostring(text or ""),Position=pos,Size=size,
  TextColor3=col or T.White,Font=font or T.Body,TextSize=ts or 10,
  TextXAlignment=align or Enum.TextXAlignment.Left},par)
end
local function gradient(x,a,b,rot) N("UIGradient",{Color=ColorSequence.new(a,b),Rotation=rot or 20},x) end
local function panel(par,pos,size,title)
 local f=C(N("Frame",{Position=pos,Size=size,BackgroundColor3=T.Panel,BackgroundTransparency=.12,
  BorderSizePixel=0,ClipsDescendants=true},par),7)
 gradient(f,Color3.fromRGB(43,17,24),Color3.fromRGB(18,8,12))
 S(f,T.Line,.22,1.1)
 if title then label(f,title,UDim2.new(0,9,0,5),UDim2.new(1,-18,0,14),10,T.Text,T.Font) end
 return f
end
local function btn(par,text,pos,size,col)
 return C(N("TextButton",{Text=text,Position=pos,Size=size,BackgroundColor3=col or T.Red,
  TextColor3=T.White,Font=T.Font,TextSize=10,BorderSizePixel=0,AutoButtonColor=false},par),5)
end
local function parent()
 local ok,h=pcall(function() return gethui and gethui() end)
 return ok and h or LP:WaitForChild("PlayerGui")
end
local function norm(v)
 local r={}
 if type(v)~="table" then if v~=nil then r[1]=tostring(v) end return r end
 if #v>0 then for _,x in ipairs(v) do r[#r+1]=tostring(x) end
 else for x,on in pairs(v) do if on then r[#r+1]=tostring(x) end end end
 return r
end
local function has(t,v) for _,x in ipairs(t or {}) do if x==v then return true end end return false end
local function fmt(t,e)
 t=norm(t)
 if #t==0 then return e or "Select options..." end
 if #t==1 then return t[1] end
 if #t==2 then return t[1]..", "..t[2] end
 return t[1]..", "..t[2].." +"..tostring(#t-2)
end

function Library:CreateWindow(cfg)
 cfg=cfg or {}
 Library.Unloaded=false
 local GP=parent()
 local guiName=tostring(cfg.GuiName or "ScoopHubV22Exact")
 local old=GP:FindFirstChild(guiName); if old then old:Destroy() end
 local conns={}
 local function own(c) if c then conns[#conns+1]=c end return c end

 local SG=N("ScreenGui",{Name=guiName,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},GP)
 local Holder=N("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
  Size=UDim2.fromOffset(W,H),BackgroundTransparency=1},SG)
 local Scale=N("UIScale",{Scale=1},Holder)
 local Shadow=N("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="rbxassetid://6015897843",
  ImageColor3=Color3.fromRGB(4,5,8),ImageTransparency=.38,ScaleType=Enum.ScaleType.Slice,
  SliceCenter=Rect.new(49,49,450,450)},Holder)
 local Main=C(N("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=T.Bg,BackgroundTransparency=.04,
  BorderSizePixel=0,ClipsDescendants=true},Shadow),8)
 S(Main,T.Stroke,.86)
 N("UIGradient",{Color=ColorSequence.new({
  ColorSequenceKeypoint.new(0,T.Top),ColorSequenceKeypoint.new(.52,T.Mid),ColorSequenceKeypoint.new(1,T.Low)
 }),Rotation=16},Main)

 local mobile=UIS.TouchEnabled and (not UIS.KeyboardEnabled or not UIS.MouseEnabled)
 local function resize()
  local cam=workspace.CurrentCamera;if not cam then return end
  local v=cam.ViewportSize;local b=math.min((v.X-24)/W,(v.Y-24)/H)
  Scale.Scale=mobile and math.clamp(b*.80,.45,.80) or math.clamp(b,.55,1)
 end
 resize()
 own(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize))
 task.defer(function() if workspace.CurrentCamera then own(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)) end end)

 -- exact 80-star background from V2.2
 local stars=N("Frame",{Name="ScoopHubDecorativeStars",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},Main)
 local rnd=Random.new(LP.UserId)
 local sc={Color3.fromRGB(255,218,218),Color3.fromRGB(246,141,151),Color3.fromRGB(255,205,156)}
 for i=1,80 do
  local d=rnd:NextNumber()>.8 and 2 or 1
  C(N("Frame",{Name="MainStar",Position=UDim2.fromScale(rnd:NextNumber(.01,.99),rnd:NextNumber(.02,.98)),
   Size=UDim2.fromOffset(d,d),BackgroundColor3=sc[rnd:NextInteger(1,#sc)],
   BackgroundTransparency=rnd:NextNumber(.45,.78),BorderSizePixel=0},stars),20)
 end

 -- exact header geometry
 local Header=N("Frame",{Size=UDim2.new(1,0,0,HEADER),BackgroundTransparency=1,Active=true,ZIndex=50},Main)
 N("ImageLabel",{Image=cfg.Logo or "rbxassetid://90541504618217",BackgroundTransparency=1,
  Position=UDim2.new(0,10,.5,-12),Size=UDim2.fromOffset(24,24)},Header)
 label(Header,cfg.Title or "SCOOPHUB",UDim2.new(0,40,0,5),UDim2.fromOffset(82,16),14,Color3.fromRGB(242,92,101),T.Font)
 label(Header,"    "..tostring(cfg.Version or "V2.2"),UDim2.new(0,105,0,6),UDim2.fromOffset(35,13),11,T.Muted,T.Body)
 label(Header,cfg.Subtitle or "by Scoop",UDim2.new(0,40,0,20),UDim2.fromOffset(100,13),10,Color3.fromRGB(166,174,187))

 local invite=tostring(cfg.Discord or "discord.gg/WxgqUa9Qz")
 local DiscordPill=C(N("Frame",{Name="DiscordPill",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.55,0,.5,0),
  Size=UDim2.fromOffset(174,22),BackgroundColor3=T.Surface3,BackgroundTransparency=.08,
  BorderSizePixel=0,ClipsDescendants=true},Header),11)
 S(DiscordPill,T.Line,.62)
 N("ImageLabel",{Name="DiscordIcon",Image=cfg.DiscordIcon or "rbxassetid://94434236999817",
  ImageColor3=Color3.fromRGB(255,255,255),ScaleType=Enum.ScaleType.Fit,BackgroundTransparency=1,
  BorderSizePixel=0,AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,8,.5,0),Size=UDim2.fromOffset(14,14)},DiscordPill)
 label(DiscordPill,invite,UDim2.new(0,27,0,0),UDim2.new(1,-32,1,0),11,T.White,T.Font)
 local Discord=N("TextButton",{Text="",BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),AutoButtonColor=false},DiscordPill)
 local Min=C(N("TextButton",{Text="-",Position=UDim2.new(1,-62,.5,-12),Size=UDim2.fromOffset(25,25),
  BackgroundColor3=T.Surface2,BackgroundTransparency=.22,TextColor3=T.White,Font=T.Font,TextSize=16,BorderSizePixel=0,ZIndex=52},Header),5)
 local Close=C(N("TextButton",{Text="X",Position=UDim2.new(1,-31,.5,-12),Size=UDim2.fromOffset(25,25),
  BackgroundColor3=T.Surface2,BackgroundTransparency=.22,TextColor3=T.White,Font=T.Font,TextSize=14,BorderSizePixel=0,ZIndex=52},Header),5)
 N("Frame",{Position=UDim2.new(0,8,0,HEADER),Size=UDim2.new(1,-16,0,1),BackgroundColor3=T.Red,BackgroundTransparency=.42,BorderSizePixel=0},Main)

 local Body=N("Frame",{Position=UDim2.new(0,GAP,0,HEADER+GAP),Size=UDim2.new(1,-GAP*2,1,-HEADER-GAP*2),BackgroundTransparency=1},Main)
 local Side=panel(Body,UDim2.new(0,0,0,0),UDim2.new(0,SIDE,1,0))
 local Nav=N("Frame",{Position=UDim2.fromOffset(6,42),Size=UDim2.new(1,-12,1,-49),BackgroundTransparency=1},Side)
 N("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},Nav)

 local Pages,NavData,Tabs,Order={},{},{},{}
 local active=nil
 local window={ScreenGui=SG,Holder=Holder,Main=Main,Header=Header,Body=Body,Side=Side,Stars=stars,
  Pages=Pages,Tabs=Tabs,Closed=false,NotificationsEnabled=true,TooltipsEnabled=false}
 Library._LastWindow=window

 local function page(name)
  local p=N("Frame",{Name=name,Position=UDim2.new(0,SIDE+GAP,0,0),Size=UDim2.new(1,-SIDE-GAP,1,0),
   BackgroundTransparency=1,Visible=false},Body)
  Pages[name]=p;return p
 end
 local function open(name)
  active=name
  for n,p in pairs(Pages) do p.Visible=n==name end
  for n,d in pairs(NavData) do
   local on=n==name;d.bar.Visible=on
   tw(d.b,{BackgroundTransparency=on and .28 or 1})
   tw(d.t,{TextColor3=on and T.Text or T.White})
   tw(d.icon,{BackgroundColor3=on and T.Red or T.Surface2})
  end
 end
 function window:SelectTab(name) open(name) end

 local ReferenceNavOrder={
  User=10,
  Automation=20,
  Garden=30,
  Shop=40,
  Mail=50,
  ["Auto Buy Pet"]=60,
  Inventory=70,
  Config=80,
  Misc=90,
 }

 local function nav(name,iconImage,requestedOrder)
  local stableOrder=
   tonumber(requestedOrder)
   or ReferenceNavOrder[name]
   or ((#Order+1)*10)

  local safeName=tostring(name):gsub("[^%w_]","_")

  local b=C(N("TextButton",{
   Name="Nav_"..safeName,
   Size=UDim2.new(1,0,0,35),
   BackgroundColor3=T.Surface2,
   BackgroundTransparency=1,
   BorderSizePixel=0,
   Text="",
   AutoButtonColor=false,
   LayoutOrder=stableOrder
  },Nav),5)
  local bar=C(N("Frame",{Position=UDim2.new(0,0,.5,-12),Size=UDim2.fromOffset(3,24),BackgroundColor3=T.Red,BorderSizePixel=0,Visible=false},b),2)
  local ib=C(N("Frame",{Position=UDim2.new(0,6,.5,-13),Size=UDim2.fromOffset(27,27),BackgroundColor3=T.Surface2,BorderSizePixel=0},b),5)
  S(ib,T.Stroke,.75)
  N("ImageLabel",{Name="Icon",Image=iconImage or "",ImageColor3=Color3.fromRGB(255,255,255),ScaleType=Enum.ScaleType.Fit,
   BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.fromOffset(5,5),Size=UDim2.fromOffset(17,17)},ib)
  local tx=label(b,string.upper(name),UDim2.new(0,39,0,0),UDim2.new(1,-44,1,0),10,T.White,T.Font)
  NavData[name]={b=b,bar=bar,icon=ib,t=tx}
  own(b.Activated:Connect(function() open(name) end))
 end

 function window:AddTab(c)
  if type(c)=="string" then c={Name=c} else c=c or {} end
  local name=tostring(c.Name or ("Tab "..tostring(#Order+1)))
  if Tabs[name] then return Tabs[name] end
  local P=page(name)
  nav(name,c.Icon,c.Order)

  Order[#Order+1]=name
  table.sort(Order,function(a,b)
   local da=NavData[a]
   local db=NavData[b]
   local ao=da and da.b and da.b.LayoutOrder or math.huge
   local bo=db and db.b and db.b.LayoutOrder or math.huge

   if ao==bo then
    return tostring(a)<tostring(b)
   end

   return ao<bo
  end)

  local tab={Name=name,Page=P,Title=c.Title or string.upper(name),Status=c.Status or "",Built=false,Sections={},Y={Left=0,Right=0},SearchItems={}}
  Tabs[name]=tab

  function tab:SetStatus(text,good)
   self.Status=tostring(text or "")
   if self.StatusLabel then self.StatusLabel.Text=self.Status
    self.StatusLabel.TextColor3=good==true and T.Success or good==false and T.Red or T.Muted end
  end

  function tab:_build()
   if self.Built then return end;self.Built=true
   self.TitleLabel=label(P,self.Title,UDim2.new(0,8,0,1),UDim2.new(.5,0,0,20),11,T.Text,T.Font)
   self.StatusLabel=label(P,self.Status,UDim2.new(.5,0,0,1),UDim2.new(.5,-8,0,20),10,T.Success,T.Font,Enum.TextXAlignment.Right)
   self.Scroll=N("ScrollingFrame",{Name=name.."Scroll",Position=UDim2.new(0,0,0,24),Size=UDim2.new(1,-8,1,-24),
    BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),ScrollBarThickness=4,ScrollBarImageColor3=T.Red,
    VerticalScrollBarPosition=Enum.VerticalScrollBarPosition.Right,
    ClipsDescendants=true},P)
  end
  function tab:_reflow()
   if not self.Built then return end
   local y={Left=0,Right=0}
   for _,s in ipairs(self.Sections) do
    local right=s.Column=="Right";local py=y[s.Column]
    if right then
     -- Reserve 12px on the right for the scrollbar + breathing room.
     -- Right edge becomes ScrollWidth - 12px.
     s.Card.Position=UDim2.new(.5,-2,0,py)
     s.Card.Size=UDim2.new(.5,-10,0,s.Height)
    else
     -- Keep both columns nearly the same width while preserving
     -- an 8px center gap.
     s.Card.Position=UDim2.new(0,1,0,py)
     s.Card.Size=UDim2.new(.5,-11,0,s.Height)
    end
    y[s.Column]=py+s.Height+10
   end
   self.Y=y;self.Scroll.CanvasSize=UDim2.new(0,0,0,math.max(y.Left,y.Right)+2)
  end

  function tab:AddSection(sc)
   self:_build();if type(sc)=="string" then sc={Title=sc} else sc=sc or {} end
   local col=string.lower(tostring(sc.Column or (self.Y.Left<=self.Y.Right and "Left" or "Right")))=="right" and "Right" or "Left"
   local card=panel(self.Scroll,UDim2.new(),UDim2.new(.5,-5,0,60),string.upper(tostring(sc.Title or "SECTION")))
   N("Frame",{BackgroundColor3=T.Line,BackgroundTransparency=.55,BorderSizePixel=0,Position=UDim2.new(0,10,0,21),Size=UDim2.new(1,-20,0,1)},card)
   if sc.Badge then
    local bc=sc.BadgeColor or T.RedDark
    local b=C(N("Frame",{BackgroundColor3=bc,BorderSizePixel=0,Position=UDim2.new(1,-88,0,6),Size=UDim2.fromOffset(78,15)},card),999)
    S(b,bc,.45,1);label(b,tostring(sc.Badge),UDim2.new(),UDim2.fromScale(1,1),8,T.White,T.Font,Enum.TextXAlignment.Center)
   end
   local sec={Card=card,Column=col,Height=60,Y=28,Tab=self};self.Sections[#self.Sections+1]=sec
   local function grow() sec.Height=math.max(60,sec.Y+8);tab:_reflow() end
   local function search(t,target) tab.SearchItems[#tab.SearchItems+1]={Title=t,Target=target} end

   function sec:AddToggle(x)
    x=x or {};local y=self.Y;local title=tostring(x.Title or "Toggle")
    label(card,title,UDim2.new(0,10,0,y),UDim2.new(1,-82,0,14),11,T.White,T.Font)
    if x.Content and tostring(x.Content)~="" then label(card,x.Content,UDim2.new(0,10,0,y+14),UDim2.new(1,-82,0,13),9,T.Muted,T.Body) end
    local state=x.Default==true
    local b=C(N("TextButton",{Text="",BackgroundColor3=state and T.Success or T.RedDark,BorderSizePixel=0,AutoButtonColor=false,
     Position=UDim2.new(1,-58,0,y+2),Size=UDim2.fromOffset(48,23)},card),12)
    local k=C(N("Frame",{BackgroundColor3=T.White,BorderSizePixel=0,AnchorPoint=Vector2.new(0,.5),
     Position=state and UDim2.new(1,-20,.5,0) or UDim2.new(0,3,.5,0),Size=UDim2.fromOffset(17,17)},b),10)
    local api={}
    function api:Set(v,fire) state=v==true;b.BackgroundColor3=state and T.Success or T.RedDark
     tw(k,{Position=state and UDim2.new(1,-20,.5,0) or UDim2.new(0,3,.5,0)},.15)
     if fire~=false and type(x.Callback)=="function" then x.Callback(state) end end
    function api:Get() return state end
    own(b.Activated:Connect(function() api:Set(not state) end))
    self.Y=y+((x.Content and tostring(x.Content)~="") and 38 or 34);grow();search(title,b);return api
   end

   function sec:AddButton(x)
    x=x or {};local y=self.Y;local title=tostring(x.Title or "Action")
    label(card,title,UDim2.new(0,10,0,y+5),UDim2.new(1,-125,0,18),11,T.White,T.Font)
    local b=C(N("TextButton",{Text=x.ButtonText or "RUN",Position=UDim2.new(1,-110,0,y+1),Size=UDim2.fromOffset(100,27),
     BackgroundColor3=x.Color or T.RedDark,BorderSizePixel=0,AutoButtonColor=false,TextColor3=T.White,Font=T.Font,TextSize=10},card),5)
    S(b,T.Red,.45,1)
    own(b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=T.Red},.1) end))
    own(b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=x.Color or T.RedDark},.1) end))
    own(b.Activated:Connect(function() if type(x.Callback)=="function" then x.Callback() end end))
    local api={Button=b};function api:SetText(v)b.Text=tostring(v or "")end
    self.Y=y+36;grow();search(title,b);return api
   end

   function sec:AddInput(x)
    x=x or {};local y=self.Y;local title=tostring(x.Title or "Input")
    label(card,title,UDim2.new(0,10,0,y),UDim2.new(1,-20,0,14),10,T.Muted,T.Font)
    local masked=x.Masked==true or x.Secret==true
    local b=C(N("TextBox",{Text=tostring(x.Default or ""),PlaceholderText=x.Placeholder or "Input value",ClearTextOnFocus=false,
     Font=T.Font,TextSize=11,TextColor3=T.White,PlaceholderColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Left,
     BackgroundColor3=T.Input,BorderSizePixel=0,Position=UDim2.new(0,10,0,y+17),Size=UDim2.new(1,-20,0,27)},card),5)
    N("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},b);S(b,T.Stroke,.82,1)
    local mask
    if masked then
     b.TextTransparency=1
     mask=label(b,"",UDim2.new(0,8,0,0),UDim2.new(1,-16,1,0),11,T.White,T.Font)
     mask.ZIndex=b.ZIndex+1
     mask.Active=false
     local function refreshMask()
      local value=tostring(b.Text or "")
      if value=="" then
       mask.Text=""
      else
       local shown=x.MaskText or "••••••••••••••••••••"
       mask.Text=tostring(shown)
      end
     end
     own(b:GetPropertyChangedSignal("Text"):Connect(refreshMask))
     own(b.Focused:Connect(refreshMask))
     own(b.FocusLost:Connect(refreshMask))
     refreshMask()
    end
    own(b.FocusLost:Connect(function(e) if type(x.Callback)=="function" then x.Callback(b.Text,b,e) end end))
    local api={Box=b,Mask=mask};function api:Set(v,fire)b.Text=tostring(v or "");if fire==true and type(x.Callback)=="function" then x.Callback(b.Text,b,false) end end
    function api:Get()return b.Text end
    self.Y=y+52;grow();search(title,b);return api
   end

   function sec:AddDropdown(x)
    x=x or {}
    local y=self.Y
    local title=tostring(x.Title or "Dropdown")

    label(
     card,
     title,
     UDim2.new(0,10,0,y),
     UDim2.new(1,-20,0,14),
     10,
     T.Muted,
     T.Font
    )

    local selector=C(N("TextButton",{
     Text="",
     Font=T.Body,
     TextSize=11,
     TextColor3=T.White,
     TextXAlignment=Enum.TextXAlignment.Left,
     TextTruncate=Enum.TextTruncate.AtEnd,
     BackgroundColor3=T.Input,
     BorderSizePixel=0,
     AutoButtonColor=false,
     Position=UDim2.new(0,10,0,y+17),
     Size=UDim2.new(1,-20,0,27),
     ClipsDescendants=true,
     ZIndex=5
    },card),5)

    S(selector,T.Stroke,.82,1)

    local multi=x.Multi==true
    local singleSelect=not multi
    local options=norm(x.Options or {})
    local selected=norm(x.Default or {})

    if singleSelect and #selected>1 then
     selected={selected[1]}
    end

    local empty=x.EmptyText or x.Placeholder or "Select..."
    local searchPlaceholder=x.SearchPlaceholder or "Search..."

    local selectorText=N("TextLabel",{
     Name="CompactSelectorText",
     Text=fmt(selected,empty),
     Font=T.Body,
     TextSize=12,
     TextColor3=T.White,
     TextXAlignment=Enum.TextXAlignment.Left,
     TextTruncate=Enum.TextTruncate.AtEnd,
     BackgroundTransparency=1,
     Position=UDim2.new(0,8,0,0),
     Size=UDim2.new(1,-28,1,0),
     ZIndex=6
    },selector)

    local selectorChevron=N("Frame",{
     Name="CompactSelectorChevron",
     BackgroundTransparency=1,
     BorderSizePixel=0,
     Position=UDim2.new(1,-20,.5,-5),
     Size=UDim2.fromOffset(14,10),
     Rotation=0,
     ZIndex=6
    },selector)

    N("Frame",{
     Name="ChevronLeft",
     BackgroundColor3=T.Muted,
     BorderSizePixel=0,
     AnchorPoint=Vector2.new(.5,.5),
     Position=UDim2.new(.5,-2,.5,0),
     Size=UDim2.fromOffset(7,2),
     Rotation=45,
     ZIndex=7
    },selectorChevron)

    N("Frame",{
     Name="ChevronRight",
     BackgroundColor3=T.Muted,
     BorderSizePixel=0,
     AnchorPoint=Vector2.new(.5,.5),
     Position=UDim2.new(.5,2,.5,0),
     Size=UDim2.fromOffset(7,2),
     Rotation=-45,
     ZIndex=7
    },selectorChevron)

    local function setChevron(open,instant)
     local rotation=open and 180 or 0

     if instant then
      selectorChevron.Rotation=rotation
     else
      tw(selectorChevron,{Rotation=rotation},.14)
     end
    end

    -- Match the reference Plant/Automation picker: popup belongs to the PAGE,
    -- not the scrolling card, so it can float over nearby cards without being
    -- clipped by them.
    local pop=C(N("Frame",{
     Name="CompactAutomationDropdown",
     Visible=false,
     BackgroundColor3=T.Surface2,
     BorderSizePixel=0,
     ClipsDescendants=true,
     Position=UDim2.fromOffset(0,0),
     Size=UDim2.fromOffset(230,240),
     ZIndex=800
    },P),6)

    S(pop,T.Red,0,1.5)

    local sb=C(N("TextBox",{
     Name="CompactAutomationSearch",
     Text="",
     PlaceholderText=searchPlaceholder,
     Font=T.Body,
     TextSize=12,
     TextColor3=T.White,
     PlaceholderColor3=T.Muted,
     TextXAlignment=Enum.TextXAlignment.Left,
     BackgroundColor3=T.Surface3,
     BorderSizePixel=0,
     ClearTextOnFocus=false,
     Position=UDim2.new(0,4,0,4),
     Size=UDim2.new(1,-8,0,26),
     ZIndex=801
    },pop),5)

    N("UIPadding",{
     PaddingLeft=UDim.new(0,8)
    },sb)

    local acts=N("Frame",{
     Name="CompactAutomationActions",
     BackgroundTransparency=1,
     BorderSizePixel=0,
     Position=UDim2.new(0,4,0,34),
     Size=UDim2.new(1,-8,0,26),
     Visible=multi,
     ZIndex=801
    },pop)

    local all=btn(
     acts,
     "SELECT ALL",
     UDim2.new(),
     UDim2.new(.5,-2,1,0),
     T.RedDark
    )
    all.TextSize=11
    all.ZIndex=802

    local clear=btn(
     acts,
     "CLEAR ALL",
     UDim2.new(.5,2,0,0),
     UDim2.new(.5,-2,1,0),
     T.Surface3
    )
    clear.TextSize=11
    clear.ZIndex=802

    local scroll=N("ScrollingFrame",{
     Name="CompactAutomationScroll",
     BackgroundTransparency=1,
     BorderSizePixel=0,
     Position=UDim2.new(
      0,
      4,
      0,
      singleSelect and 34 or 64
     ),
     Size=UDim2.new(
      1,
      -8,
      1,
      singleSelect and -38 or -68
     ),
     CanvasSize=UDim2.new(),
     ScrollBarThickness=3,
     ScrollBarImageColor3=T.Red,
     ScrollingDirection=Enum.ScrollingDirection.Y,
     ZIndex=801
    },pop)

    local lay=N("UIListLayout",{
     Padding=UDim.new(0,2),
     SortOrder=Enum.SortOrder.LayoutOrder
    },scroll)

    local api={}
    local rows={}
    local maxVisibleRows=6
    local rowHeight=34
    local headerHeight=singleSelect and 34 or 64
    local desiredHeight=240
    local currentWidth=230
    local openState=false
    local updatePosition

    local function fire()
     if type(x.Callback)=="function" then
      x.Callback(
       multi and norm(selected) or selected[1]
      )
     end
    end

    local function upd()
     selectorText.Text=fmt(selected,empty)
    end

    local function pointInside(gui,point)
     if not gui or not gui.Visible then
      return false
     end

     local pos=gui.AbsolutePosition
     local size=gui.AbsoluteSize

     return point.X>=pos.X
      and point.X<=pos.X+size.X
      and point.Y>=pos.Y
      and point.Y<=pos.Y+size.Y
    end

    local function selectorVisibleInScroll()
     if not tab.Scroll
      or not tab.Scroll.Parent
      or not selector.Parent
     then
      return false
     end

     local selectorPos=selector.AbsolutePosition
     local selectorSize=selector.AbsoluteSize
     local scrollPos=tab.Scroll.AbsolutePosition
     local scrollSize=tab.Scroll.AbsoluteSize

     local selectorLeft=selectorPos.X
     local selectorRight=selectorPos.X+selectorSize.X
     local selectorTop=selectorPos.Y
     local selectorBottom=selectorPos.Y+selectorSize.Y

     local scrollLeft=scrollPos.X
     local scrollRight=scrollPos.X+scrollSize.X
     local scrollTop=scrollPos.Y
     local scrollBottom=scrollPos.Y+scrollSize.Y

     return selectorRight>scrollLeft
      and selectorLeft<scrollRight
      and selectorBottom>scrollTop
      and selectorTop<scrollBottom
    end

    function api:Close()
     pop.Visible=false
     openState=false
     setChevron(false,false)

     if window._ActiveDropdown==pop then
      window._ActiveDropdown=nil
      window._ActiveDropdownClose=nil
      window._ActiveDropdownChevron=nil
     end
    end

    updatePosition=function()
     if not pop.Visible
      or not selector.Parent
      or not P.Parent
     then
      return
     end

     -- If scrolling moved the selector completely outside the visible
     -- ScrollingFrame, close instead of leaving an orphan popup on-screen.
     if tab.Scroll and not selectorVisibleInScroll() then
      api:Close()
      return
     end

     local ok=pcall(function()
      local scaleValue=math.max(
       tonumber(Scale.Scale) or 1,
       .01
      )

      local basePos=P.AbsolutePosition
      local baseSize=P.AbsoluteSize
      local buttonPos=selector.AbsolutePosition
      local buttonSize=selector.AbsoluteSize

      local pageWidth=baseSize.X/scaleValue
      local pageHeight=baseSize.Y/scaleValue

      local buttonX=
       (buttonPos.X-basePos.X)/scaleValue

      local buttonTop=
       (buttonPos.Y-basePos.Y)/scaleValue

      local buttonHeight=
       buttonSize.Y/scaleValue

      local buttonBottom=
       buttonTop+buttonHeight

      local margin=4

      currentWidth=
       buttonSize.X/scaleValue

      -- Keep the picker horizontally aligned with the selector but clamp it
      -- inside the visible page.
      local px=math.clamp(
       buttonX,
       margin,
       math.max(
        margin,
        pageWidth-currentWidth-margin
       )
      )

      local availableBelow=
       math.max(
        0,
        pageHeight-buttonBottom-margin
       )

      local availableAbove=
       math.max(
        0,
        buttonTop-margin
       )

      -- Same logic as the reference: prefer below, automatically flip above
      -- when there is not enough room underneath.
      local openAbove=
       desiredHeight>availableBelow
       and availableAbove>availableBelow

      local availableHeight=
       openAbove
       and availableAbove
       or availableBelow

      local actualHeight=
       math.min(
        desiredHeight,
        availableHeight
       )

      -- Tiny/scaled windows: use whichever side genuinely has more room.
      if actualHeight<100 then
       if availableAbove>availableBelow then
        openAbove=true
        availableHeight=availableAbove
       else
        openAbove=false
        availableHeight=availableBelow
       end

       actualHeight=
        math.min(
         desiredHeight,
         availableHeight
        )
      end

      actualHeight=
       math.max(
        0,
        actualHeight
       )

      local py

      if openAbove then
       py=
        buttonTop
        -actualHeight
        -margin
      else
       py=
        buttonBottom
        +margin
      end

      py=math.clamp(
       py,
       margin,
       math.max(
        margin,
        pageHeight-actualHeight-margin
       )
      )

      pop.Position=
       UDim2.fromOffset(
        px,
        py
       )

      pop.Size=
       UDim2.fromOffset(
        currentWidth,
        actualHeight
       )
     end)

     if not ok then
      pop.Position=
       UDim2.fromOffset(
        10,
        72
       )

      pop.Size=
       UDim2.fromOffset(
        currentWidth,
        desiredHeight
       )
     end
    end

    local function resizeDropdown(matchCount)
     local visibleRows=
      math.clamp(
       matchCount,
       1,
       maxVisibleRows
      )

     desiredHeight=
      headerHeight
      +(visibleRows*(rowHeight+2))
      +4

     if pop.Visible then
      updatePosition()
     else
      pop.Size=
       UDim2.fromOffset(
        currentWidth,
        desiredHeight
       )
     end
    end

    local function clearRows()
     for _,c in ipairs(rows) do
      if c.Parent then
       c:Destroy()
      end
     end

     table.clear(rows)
    end

    local function resetRowColors()
     for _,r in ipairs(rows) do
      if r and r.Parent then
       local optionName=r:GetAttribute("ScoopHubOptionName")

       r.BackgroundColor3=
        optionName
        and has(selected,optionName)
        and Color3.fromRGB(55,22,30)
        or T.Surface2
      end
     end
    end

    local function rebuild()
     clearRows()

     local q=
      string.lower(
       sb.Text or ""
      )

     local n=0

     for _,o in ipairs(options) do
      if q==""
       or string.find(
        string.lower(o),
        q,
        1,
        true
       )
      then
       n+=1

       local on=has(selected,o)

       local r=C(N("TextButton",{
        Text="",
        BackgroundColor3=
         on
         and Color3.fromRGB(55,22,30)
         or T.Surface2,
        BorderSizePixel=0,
        AutoButtonColor=false,
        Size=UDim2.new(1,0,0,rowHeight),
        LayoutOrder=n,
        ZIndex=802
       },scroll),4)

       rows[#rows+1]=r
       r:SetAttribute("ScoopHubOptionName",o)

       label(
        r,
        on and "✓" or "",
        UDim2.new(0,8,0,0),
        UDim2.fromOffset(18,rowHeight),
        14,
        T.Success,
        T.Font,
        Enum.TextXAlignment.Left
       ).ZIndex=803

       label(
        r,
        o,
        UDim2.new(0,28,0,0),
        UDim2.new(1,-36,1,0),
        12,
        T.White,
        T.Body
       ).ZIndex=803

       own(r.MouseEnter:Connect(function()
        if not has(selected,o) then
         r.BackgroundColor3=T.RedDark
        end
       end))

       own(r.MouseLeave:Connect(function()
        r.BackgroundColor3=
         has(selected,o)
         and Color3.fromRGB(55,22,30)
         or T.Surface2
       end))

       own(r.Activated:Connect(function()
        if multi then
         if has(selected,o) then
          local z={}

          for _,v in ipairs(selected) do
           if v~=o then
            z[#z+1]=v
           end
          end

          selected=z
         else
          selected[#selected+1]=o
         end

         upd()
         rebuild()
         fire()
        else
         selected={o}
         upd()
         fire()
         api:Close()
        end
       end))
      end
     end

     scroll.CanvasSize=
      UDim2.new(
       0,
       0,
       0,
       lay.AbsoluteContentSize.Y+4
      )

     resizeDropdown(
      math.max(n,1)
     )
    end

    function api:Open()
     -- Never allow two floating pickers to overlap. This is important when
     -- selectors in opposite columns are both visible.
     if window._ActiveDropdown
      and window._ActiveDropdown~=pop
      and type(window._ActiveDropdownClose)=="function"
     then
      window._ActiveDropdownClose()
     end

     window._ActiveDropdown=pop
     window._ActiveDropdownClose=function()
      api:Close()
     end
     window._ActiveDropdownChevron=selectorChevron

     sb.Text=""
     rebuild()
     resetRowColors()

     pop.Visible=true
     openState=true
     setChevron(true,false)

     -- Position after becoming visible so AbsoluteSize is valid.
     task.defer(function()
      if pop.Visible then
       updatePosition()
      end
     end)
    end

    function api:Set(v,firecb)
     selected=norm(v)

     if singleSelect and #selected>1 then
      selected={selected[1]}
     end

     upd()

     if pop.Visible then
      rebuild()
     end

     if firecb==true then
      fire()
     end
    end

    function api:Get()
     return multi
      and norm(selected)
      or selected[1]
    end

    function api:SetOptions(v,preserve)
     options=norm(v)

     if preserve~=true then
      selected={}
     else
      local z={}

      for _,i in ipairs(selected) do
       if has(options,i) then
        z[#z+1]=i
       end
      end

      selected=z
     end

     upd()

     if pop.Visible then
      rebuild()
     end
    end

    function api:Refresh(v,s)
     if v~=nil then
      options=norm(v)
     end

     if s~=nil then
      selected=norm(s)
     end

     if singleSelect and #selected>1 then
      selected={selected[1]}
     end

     upd()

     if pop.Visible then
      rebuild()
     end
    end

    own(selector.Activated:Connect(function()
     if openState then
      api:Close()
     else
      api:Open()
     end
    end))

    own(sb:GetPropertyChangedSignal("Text"):Connect(function()
     rebuild()
    end))

    own(all.Activated:Connect(function()
     if multi then
      selected=norm(options)
      upd()
      rebuild()
      fire()
     end
    end))

    own(clear.Activated:Connect(function()
     if multi then
      selected={}
      upd()
      rebuild()
      fire()
     end
    end))

    -- Requested behavior: keep the popup anchored while the tab scrolls.
    -- The reference closes here; this library instead reuses the reference's
    -- positioning math so the popup follows the selector smoothly.
    if tab.Scroll then
     own(
      tab.Scroll:
       GetPropertyChangedSignal(
        "CanvasPosition"
       ):
       Connect(function()
        if pop.Visible then
         resetRowColors()
         updatePosition()

         task.defer(function()
          if pop.Visible then
           resetRowColors()
          end
         end)
        end
       end)
     )
    end

    -- If responsive scaling changes while open, recalc the anchor.
    own(
     Scale:
      GetPropertyChangedSignal(
       "Scale"
      ):
      Connect(function()
       if pop.Visible then
        resetRowColors()
        updatePosition()

        task.defer(function()
         if pop.Visible then
          resetRowColors()
         end
        end)
       end
      end)
    )

    -- Tab change = close.
    own(
     P:
      GetPropertyChangedSignal(
       "Visible"
      ):
      Connect(function()
       if not P.Visible
        and pop.Visible
       then
        api:Close()
       end
      end)
    )

    -- Click/tap outside = close.
    own(UIS.InputBegan:Connect(function(input)
     if not pop.Visible then
      return
     end

     if input.UserInputType
         ~=Enum.UserInputType.MouseButton1
      and input.UserInputType
         ~=Enum.UserInputType.Touch
     then
      return
     end

     local point=input.Position

     if not pointInside(pop,point)
      and not pointInside(selector,point)
     then
      api:Close()
     end
    end))

    upd()

    self.Y=y+52
    grow()
    search(title,selector)

    return api
   end

   tab:_reflow();return sec
  end

  function tab:AddUserDashboard(u)
   u=u or {};P.ClipsDescendants=false

   local function registerUserSearch(title,target)
    self.SearchItems[#self.SearchItems+1]={
     Title=tostring(title or ""),
     Target=target,
    }
   end
   if self.Built then
    if self.TitleLabel then self.TitleLabel:Destroy()end;if self.StatusLabel then self.StatusLabel:Destroy()end;if self.Scroll then self.Scroll:Destroy()end
    self.Built=false
   end
   local prefs=u.Preferences or {};if prefs.Notifications==nil then prefs.Notifications=false end;if prefs.Tooltips==nil then prefs.Tooltips=false end
   local function card(pos,size,title)
    local f=C(N("Frame",{Position=pos,Size=size,BackgroundColor3=Color3.fromRGB(12,12,14),BackgroundTransparency=.08,BorderSizePixel=0,ClipsDescendants=true},P),7)
    S(f,USER_SOFT,.48,1);label(f,title,UDim2.new(0,12,0,8),UDim2.new(1,-24,0,18),11,T.Red,T.Font);return f
   end
   local function hover(par,text,pos,size)
    local b=C(N("TextButton",{Text=text,Position=pos,Size=size,BackgroundColor3=Color3.fromRGB(24,22,25),BackgroundTransparency=.08,
     BorderSizePixel=0,AutoButtonColor=false,TextColor3=T.White,Font=T.Font,TextSize=10},par),5);S(b,USER_SOFT,.58,1)
    own(b.MouseEnter:Connect(function()tw(b,{BackgroundColor3=Color3.fromRGB(36,31,35)},.1)end))
    own(b.MouseLeave:Connect(function()tw(b,{BackgroundColor3=Color3.fromRGB(24,22,25)},.1)end));return b
   end
   local function row(par,t,v,y)
    label(par,t,UDim2.new(0,12,0,y),UDim2.new(.42,-6,0,17),10,T.Muted,T.Body)
    local x=label(par,v,UDim2.new(.42,0,0,y),UDim2.new(.58,-12,0,17),10,T.White,T.Body,Enum.TextXAlignment.Right)
    N("Frame",{Position=UDim2.new(0,12,0,y+22),Size=UDim2.new(1,-24,0,1),BackgroundColor3=Color3.fromRGB(68,55,59),BackgroundTransparency=.65,BorderSizePixel=0},par);return x
   end
   local function tog(par,t,d,y,init,cb)
    label(par,t,UDim2.new(0,12,0,y),UDim2.new(1,-75,0,15),10,T.White,T.Font)
    if d and d~="" then label(par,d,UDim2.new(0,12,0,y+14),UDim2.new(1,-75,0,14),8,T.Muted,T.Body)end
    local st=init==true;local b=C(N("TextButton",{Text="",Position=UDim2.new(1,-58,0,y+3),Size=UDim2.fromOffset(43,21),
     BackgroundColor3=st and T.RedDark or Color3.fromRGB(47,43,47),BorderSizePixel=0,AutoButtonColor=false},par),20)
    S(b,st and T.Red or Color3.fromRGB(93,77,82),.48,1)
    local k=C(N("Frame",{AnchorPoint=Vector2.new(0,.5),Position=st and UDim2.new(1,-19,.5,0) or UDim2.new(0,3,.5,0),
     Size=UDim2.fromOffset(16,16),BackgroundColor3=T.White,BorderSizePixel=0},b),20)
    local api={};function api:Set(v,fire)st=v==true;tw(b,{BackgroundColor3=st and T.RedDark or Color3.fromRGB(47,43,47)},.12);tw(k,{Position=st and UDim2.new(1,-19,.5,0) or UDim2.new(0,3,.5,0)},.12)
     local q=b:FindFirstChildOfClass("UIStroke");if q then q.Color=st and T.Red or Color3.fromRGB(93,77,82)end;if fire==true and type(cb)=="function"then cb(st)end end
    function api:Get()return st end;own(b.Activated:Connect(function()api:Set(not st,true)end));return api
   end

   N("ImageLabel",{Image=u.Icon or "rbxassetid://17132521951",ImageColor3=T.Red,BackgroundTransparency=1,Position=UDim2.new(0,3,0,4),Size=UDim2.fromOffset(31,31)},P)
   label(P,u.Title or "USER",UDim2.new(0,41,0,4),UDim2.new(1,-45,0,20),16,T.White,T.Font)
   label(P,u.Description or "Manage your account, preferences and session.",UDim2.new(0,41,0,24),UDim2.new(1,-45,0,16),10,T.Muted,T.Body)

   local pc=card(UDim2.new(0,0,0,49),UDim2.new(.5,-5,0,159),"PLAYER INFO")
   registerUserSearch("Player Info",pc)
   local av=C(N("Frame",{Position=UDim2.new(0,12,0,31),Size=UDim2.fromOffset(92,72),BackgroundColor3=Color3.fromRGB(26,25,28),BorderSizePixel=0,ClipsDescendants=true},pc),6);S(av,Color3.fromRGB(85,66,72),.62,1)
   N("ImageLabel",{Image="rbxthumb://type=AvatarBust&id="..tostring(LP.UserId).."&w=180&h=180",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ScaleType=Enum.ScaleType.Fit},av)
   local function pv(t,v,y)label(pc,t,UDim2.new(0,114,0,y),UDim2.new(1,-124,0,13),9,T.Muted,T.Body);label(pc,tostring(v),UDim2.new(0,114,0,y+13),UDim2.new(1,-124,0,15),10,T.White,T.Font)end
   pv("Username",LP.Name,30);pv("User ID",LP.UserId,60);pv("Display Name",LP.DisplayName,90)
   local copy=hover(pc,"COPY USER ID",UDim2.new(0,12,1,-30),UDim2.new(.5,-18,0,22))
   local rejoin=hover(pc,"REJOIN",UDim2.new(.5,6,1,-30),UDim2.new(.5,-18,0,22));local rs=rejoin:FindFirstChildOfClass("UIStroke");if rs then rs:Destroy()end
   own(copy.Activated:Connect(function()local ok=false;if type(setclipboard)=="function"then ok=pcall(setclipboard,tostring(LP.UserId))elseif type(toclipboard)=="function"then ok=pcall(toclipboard,tostring(LP.UserId))end;copy.Text=ok and "COPIED" or tostring(LP.UserId);task.delay(1.15,function()if copy.Parent then copy.Text="COPY USER ID"end end)end))
   own(rejoin.Activated:Connect(function()if type(u.OnRejoin)=="function"then u.OnRejoin()return end;pcall(function()if game.JobId and game.JobId~=""then TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)else TeleportService:Teleport(game.PlaceId,LP)end end)end))

   local sc=card(UDim2.new(.5,5,0,49),UDim2.new(.5,-5,0,159),"SESSION INFO")
   registerUserSearch("Session Info",sc)
   local started=os.time()-math.floor(math.max(tonumber(time())or 0,tonumber(workspace.DistributedGameTime)or 0))
   local function dur(n)n=math.max(0,math.floor(n or 0));return string.format("%02d:%02d:%02d",math.floor(n/3600),math.floor((n%3600)/60),n%60)end
   local play=row(sc,"Play Time",dur(time()),31)
   row(sc,"Join Time",os.date("%m/%d/%Y %I:%M:%S %p",started),55)
   row(sc,"Place ID",tostring(game.PlaceId),79)
   row(sc,"Job ID",tostring(game.JobId or "-"),103)

   local serverHopButton=C(N("TextButton",{
    Text="SERVER HOP",
    Position=UDim2.new(0,12,0,132),
    Size=UDim2.new(1,-24,0,20),
    BackgroundColor3=T.RedDark,
    BorderSizePixel=0,
    AutoButtonColor=false,
    TextColor3=T.White,
    Font=T.Font,
    TextSize=9,
   },sc),4)
   S(serverHopButton,T.Red,.42,1)

   local serverHopBusy=false

   local function doServerHop()
    if serverHopBusy then
     return
    end

    serverHopBusy=true
    serverHopButton.Text="SEARCHING..."

    task.spawn(function()
     local placeId=game.PlaceId
     local currentJobId=tostring(game.JobId or "")
     local cursor=nil
     local found=false

     for _=1,10 do
      local url=
       "https://games.roblox.com/v1/games/"
       ..tostring(placeId)
       .."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"

      if cursor and cursor~="" then
       url=url.."&cursor="..HttpService:UrlEncode(cursor)
      end

      local requestOk,response=pcall(function()
       return game:HttpGet(url)
      end)

      if not requestOk then
       break
      end

      local decodeOk,data=pcall(function()
       return HttpService:JSONDecode(response)
      end)

      if not decodeOk or type(data)~="table" then
       break
      end

      for _,server in ipairs(data.data or {}) do
       local serverId=tostring(server.id or "")
       local playing=tonumber(server.playing) or 0
       local maxPlayers=tonumber(server.maxPlayers) or 0

       if serverId~=""
        and serverId~=currentJobId
        and maxPlayers>0
        and playing<maxPlayers
       then
        found=true
        serverHopButton.Text="JOINING..."

        pcall(function()
         TeleportService:TeleportToPlaceInstance(
          placeId,
          serverId,
          LP
         )
        end)

        return
       end
      end

      cursor=data.nextPageCursor

      if not cursor or cursor=="" then
       break
      end
     end

     if not found and serverHopButton.Parent then
      serverHopButton.Text="NO SERVER FOUND"

      task.delay(1.4,function()
       if serverHopButton.Parent then
        serverHopButton.Text="SERVER HOP"
       end
      end)
     end

     serverHopBusy=false
    end)
   end

   own(serverHopButton.MouseEnter:Connect(function()
    tw(serverHopButton,{BackgroundColor3=T.Red},.1)
   end))

   own(serverHopButton.MouseLeave:Connect(function()
    tw(serverHopButton,{BackgroundColor3=T.RedDark},.1)
   end))

   own(serverHopButton.Activated:Connect(doServerHop))
   registerUserSearch("Server Hop",serverHopButton)
   registerUserSearch("Job ID",sc)
   registerUserSearch("Place ID",sc)
   registerUserSearch("Play Time",sc)
   registerUserSearch("Join Time",sc)

   task.spawn(function()while not window.Closed and play.Parent do if P.Visible then play.Text=dur(math.max(time(),workspace.DistributedGameTime,os.time()-started));task.wait(1)else task.wait(.5)end end end)

   local pref=card(UDim2.new(0,0,0,217),UDim2.new(.5,-5,1,-217),"PREFERENCES")
   registerUserSearch("Preferences",pref)
   local a=tog(pref,"Auto Rejoin","Automatically rejoin after a disconnect.",31,prefs.AutoRejoin==true,function(v)prefs.AutoRejoin=v;if type(u.OnAutoRejoin)=="function"then u.OnAutoRejoin(v)end end)
   local l=tog(pref,"Low Graphics Mode","Reduce world effects and decorative UI for better FPS.",66,prefs.LowGraphics==true,function(v)prefs.LowGraphics=v;stars.Visible=not v;if type(u.OnLowGraphics)=="function"then u.OnLowGraphics(v)end end)
   local n=tog(pref,"UI Notifications","Keep ScoopHub notification preference enabled.",101,prefs.Notifications==true,function(v)prefs.Notifications=v;window.NotificationsEnabled=v end)
   local tt=tog(pref,"Show Tooltips","Show helper descriptions where supported.",136,prefs.Tooltips==true,function(v)prefs.Tooltips=v;window.TooltipsEnabled=v end)
   window.NotificationsEnabled=prefs.Notifications==true;window.TooltipsEnabled=prefs.Tooltips==true;stars.Visible=prefs.LowGraphics~=true

   registerUserSearch("Auto Rejoin",pref)
   registerUserSearch("Low Graphics Mode",pref)
   registerUserSearch("UI Notifications",pref)
   registerUserSearch("Show Tooltips",pref)

   local lc=card(UDim2.new(.5,5,0,217),UDim2.new(.5,-5,1,-217),"LOCALPLAYER")
   registerUserSearch("LocalPlayer",lc)
   local q=u.LocalPlayer or {}
   label(lc,"WalkSpeed Value",UDim2.new(0,12,0,31),UDim2.new(1,-24,0,14),9,T.Muted,T.Font)
   local wi=C(N("TextBox",{Text=tostring(q.WalkSpeedValue or 16),PlaceholderText="16",ClearTextOnFocus=false,Font=T.Font,TextSize=10,TextColor3=T.White,
    PlaceholderColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Left,BackgroundColor3=T.Input,BorderSizePixel=0,Position=UDim2.new(0,12,0,48),Size=UDim2.new(1,-24,0,27)},lc),5)
   N("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},wi);S(wi,T.Stroke,.75,1)
   own(wi.FocusLost:Connect(function(e)if type(q.OnWalkSpeedValue)=="function"then q.OnWalkSpeedValue(wi.Text,e)end end))
   local ws=tog(lc,"WalkSpeed","",87,q.WalkSpeed==true,q.OnWalkSpeed)
   local ij=tog(lc,"InfiniteJump","",122,q.InfiniteJump==true,q.OnInfiniteJump)

   registerUserSearch("WalkSpeed Value",wi)
   registerUserSearch("WalkSpeed",lc)
   registerUserSearch("InfiniteJump",lc)
   registerUserSearch("Copy User ID",copy)
   registerUserSearch("Rejoin",rejoin)
   return{PlayerCard=pc,SessionCard=sc,PreferencesCard=pref,LocalPlayerCard=lc,AutoRejoin=a,LowGraphics=l,Notifications=n,Tooltips=tt,WalkSpeedInput=wi,WalkSpeed=ws,InfiniteJump=ij}
  end

  if not active then open(name) end
  return tab
 end

 -- exact sidebar search field geometry + feature search
 local SearchBox=C(N("TextBox",{
  Name="ScoopHubGlobalSearch",
  Position=UDim2.fromOffset(6,7),
  Size=UDim2.new(1,-12,0,29),
  BackgroundColor3=T.Surface3,
  BackgroundTransparency=.04,
  BorderSizePixel=0,
  Text="",
  PlaceholderText="Search...",
  PlaceholderColor3=T.Muted,
  TextColor3=T.White,
  Font=T.Body,
  TextSize=10,
  TextXAlignment=Enum.TextXAlignment.Left,
  ClearTextOnFocus=false,
  ZIndex=410,
 },Side),5)

 S(SearchBox,T.Line,.55,1)
 N("UIPadding",{
  PaddingLeft=UDim.new(0,9),
  PaddingRight=UDim.new(0,7),
 },SearchBox)

 local SearchResults=C(N("Frame",{
  Name="ScoopHubGlobalSearchResults",
  Visible=false,
  Position=UDim2.fromOffset(SIDE+6,7),
  Size=UDim2.fromOffset(300,0),
  BackgroundColor3=T.Panel,
  BackgroundTransparency=.02,
  BorderSizePixel=0,
  ClipsDescendants=true,
  ZIndex=1000,
 },Body),6)

 S(SearchResults,T.Line,.22,1.2)

 local SearchScroll=N("ScrollingFrame",{
  Position=UDim2.fromOffset(4,4),
  Size=UDim2.new(1,-8,1,-8),
  BackgroundTransparency=1,
  BorderSizePixel=0,
  CanvasSize=UDim2.new(),
  ScrollBarThickness=3,
  ScrollBarImageColor3=T.Red,
  ZIndex=1001,
 },SearchResults)

 local SearchLayout=N("UIListLayout",{
  Padding=UDim.new(0,2),
  SortOrder=Enum.SortOrder.LayoutOrder,
 },SearchScroll)

 local searchRows={}

 local function clearSearchRows()
  for _,rowObject in ipairs(searchRows) do
   if rowObject and rowObject.Parent then
    rowObject:Destroy()
   end
  end
  table.clear(searchRows)
 end

 local function scrollToTarget(tab,target)
  if not tab or not target then
   return
  end

  if tab.Scroll
   and target:IsDescendantOf(tab.Scroll)
  then
   task.defer(function()
    if not tab.Scroll or not tab.Scroll.Parent or not target.Parent then
     return
    end

    local scaleValue=math.max(tonumber(Scale.Scale) or 1,.01)
    local targetY=(target.AbsolutePosition.Y-tab.Scroll.AbsolutePosition.Y)/scaleValue
    local current=tab.Scroll.CanvasPosition.Y
    local wanted=math.max(0,current+targetY-18)

    tab.Scroll.CanvasPosition=Vector2.new(
     tab.Scroll.CanvasPosition.X,
     wanted
    )
   end)
  end
 end

 local function rebuildSearchResults()
  clearSearchRows()

  local query=string.lower(
   tostring(SearchBox.Text or "")
  )

  if query=="" then
   SearchResults.Visible=false
   SearchResults.Size=UDim2.fromOffset(300,0)
   return
  end

  local matches={}
  local seen={}

  -- Preserve tab order: USER -> AUTOMATION -> SHOP -> future tabs.
  for _,tabName in ipairs(Order) do
   local tab=Tabs[tabName]

   if tab then
    local tabTitle=string.upper(tabName)

    for _,item in ipairs(tab.SearchItems or {}) do
     local itemTitle=tostring(item.Title or "")
     local haystack=string.lower(tabName.." "..itemTitle)

     if itemTitle~=""
      and string.find(haystack,query,1,true)
     then
      local key=string.lower(tabName.."\31"..itemTitle)

      if not seen[key] then
       seen[key]=true
       matches[#matches+1]={
        Tab=tabName,
        TabLabel=tabTitle,
        Title=itemTitle,
        Target=item.Target,
       }
      end
     end

     if #matches>=8 then
      break
     end
    end

    if #matches>=8 then
     break
    end
   end
  end

  if #matches==0 then
   SearchResults.Visible=false
   SearchResults.Size=UDim2.fromOffset(300,0)
   return
  end

  for index,entry in ipairs(matches) do
   local row=C(N("TextButton",{
    Text="",
    Size=UDim2.new(1,-3,0,34),
    BackgroundColor3=T.Surface2,
    BackgroundTransparency=.08,
    BorderSizePixel=0,
    AutoButtonColor=false,
    LayoutOrder=index,
    ZIndex=1002,
   },SearchScroll),4)

   searchRows[#searchRows+1]=row

   local resultText=entry.TabLabel.." - "..entry.Title

   local resultLabel=label(
    row,
    resultText,
    UDim2.new(0,9,0,0),
    UDim2.new(1,-18,1,0),
    10,
    T.White,
    T.Font
   )
   resultLabel.ZIndex=1003

   own(row.MouseEnter:Connect(function()
    tw(row,{BackgroundColor3=Color3.fromRGB(54,24,31)},.1)
   end))

   own(row.MouseLeave:Connect(function()
    tw(row,{BackgroundColor3=T.Surface2},.1)
   end))

   own(row.Activated:Connect(function()
    local tab=Tabs[entry.Tab]

    SearchBox.Text=""
    SearchResults.Visible=false

    open(entry.Tab)

    if tab then
     scrollToTarget(tab,entry.Target)
    end
   end))
  end

  local resultHeight=math.min(#matches,8)*36+8

  SearchResults.Size=UDim2.fromOffset(
   300,
   math.min(resultHeight,296)
  )

  SearchScroll.CanvasSize=UDim2.new(
   0,
   0,
   0,
   SearchLayout.AbsoluteContentSize.Y+4
  )

  SearchResults.Visible=true
 end

 own(SearchBox:GetPropertyChangedSignal("Text"):Connect(
  rebuildSearchResults
 ))

 own(SearchBox.FocusLost:Connect(function()
  if SearchBox.Text=="" then
   SearchResults.Visible=false
  end
 end))

 function window:Notify(info,force)
  info=info or {};if force~=true and not self.NotificationsEnabled then return end
  local old=GP:FindFirstChild("ScoopHubDiscordNotification");if old then old:Destroy()end
  local ng=N("ScreenGui",{Name="ScoopHubDiscordNotification",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},GP)
  local nf=C(N("Frame",{AnchorPoint=Vector2.new(1,1),BackgroundColor3=T.Panel,BorderSizePixel=0,Position=UDim2.new(1,400,1,-30),Size=UDim2.fromOffset(320,70)},ng),8);S(nf,T.Line,.22)
  local first=label(nf,tostring(info.Title or "ScoopHub"),UDim2.fromOffset(12,8),UDim2.fromOffset(180,20),14,T.White,T.Font)
  local desc=tostring(info.Description or "");if desc~=""then local second=label(nf," "..desc,UDim2.fromOffset(12,8),UDim2.fromOffset(120,20),14,T.Red,T.Font);task.defer(function()if second.Parent then second.Position=UDim2.new(0,12+first.TextBounds.X,0,8)end end)end
  label(nf,tostring(info.Content or ""),UDim2.fromOffset(12,35),UDim2.new(1,-48,0,24),12,T.Muted,T.Body)
  local x=N("TextButton",{Text="X",Font=T.Font,TextSize=14,TextColor3=Color3.fromRGB(200,200,200),BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,6),Size=UDim2.fromOffset(22,22),BorderSizePixel=0},nf)
  own(x.Activated:Connect(function()if ng.Parent then ng:Destroy()end end));tw(nf,{Position=UDim2.new(1,-30,1,-30)},.35)
  task.delay(tonumber(info.Delay)or 5,function()if ng.Parent then tw(nf,{Position=UDim2.new(1,400,1,-30)},.3);task.delay(.35,function()if ng.Parent then ng:Destroy()end end)end end)
 end
 own(Discord.Activated:Connect(function()
  local copied=false;pcall(function()if setclipboard then setclipboard(invite);copied=true elseif toclipboard then toclipboard(invite);copied=true end end)
  window:Notify({Title="ScoopHub",Description="Discord",Content=copied and ("Copied to clipboard: "..invite) or "Clipboard is unavailable in this executor.",Delay=5},true)
 end))

 local minimized=false;local expanded=Holder.Position;local miniPos=nil
 local Mini=C(N("TextButton",{Name="MiniLauncher",Visible=false,Text="",AutoButtonColor=false,AnchorPoint=Vector2.new(.5,.5),Position=Holder.Position,Size=UDim2.fromOffset(48,48),BackgroundColor3=T.Bg,BackgroundTransparency=.03,BorderSizePixel=0,ZIndex=500},SG),12);S(Mini,T.Red,.35,1)
 N("ImageLabel",{Image=cfg.Logo or "rbxassetid://90541504618217",BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(36,36),ZIndex=501},Mini)
 local function miniDefault()local c=workspace.CurrentCamera;if not c then return expanded end;local v=c.ViewportSize;local p=Min.AbsolutePosition;local s=Min.AbsoluteSize;return UDim2.fromOffset(math.clamp(p.X+s.X/2,28,v.X-28),math.clamp(p.Y+s.Y/2,28,v.Y-28))end
 local function setMin(v)minimized=v==true;if minimized then expanded=Holder.Position;if not miniPos then miniPos=miniDefault()end;Mini.Position=miniPos;Mini.Visible=true;Body.Visible=false;Holder.Visible=false;Min.Text="+"else miniPos=Mini.Position;Holder.Position=expanded;Holder.Visible=true;Body.Visible=true;Mini.Visible=false;Min.Text="-"end end
 own(Min.Activated:Connect(function()setMin(not minimized)end))
 local dh,dm=false,false;local moved=false;local sm,sp;local touch=nil
 own(Header.InputBegan:Connect(function(i)if minimized then return end;if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dh=true;dm=false;touch=i.UserInputType==Enum.UserInputType.Touch and i or nil;sm=i.Position;sp=Holder.Position end end))
 own(Mini.InputBegan:Connect(function(i)if not minimized then return end;if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dm=true;dh=false;moved=false;touch=i.UserInputType==Enum.UserInputType.Touch and i or nil;sm=i.Position;sp=Mini.Position end end))
 own(Mini.Activated:Connect(function()if minimized and not moved then setMin(false)end end))
 own(UIS.InputEnded:Connect(function(i)local a=i.UserInputType==Enum.UserInputType.MouseButton1;local b=i.UserInputType==Enum.UserInputType.Touch and i==touch;if a or b then dm=false;dh=false;touch=nil end end))
 own(UIS.InputChanged:Connect(function(i)
  local mm=i.UserInputType==Enum.UserInputType.MouseMovement and touch==nil;local mt=i.UserInputType==Enum.UserInputType.Touch and i==touch
  if not(mm or mt)or not(dh or dm)then return end;local d=i.Position-sm;local cam=workspace.CurrentCamera;if not cam then return end;local v=cam.ViewportSize
  local bx=v.X*sp.X.Scale+sp.X.Offset+d.X;local by=v.Y*sp.Y.Scale+sp.Y.Offset+d.Y
  if dm then if d.Magnitude>=6 then moved=true end;Mini.Position=UDim2.fromOffset(math.clamp(bx,28,v.X-28),math.clamp(by,28,v.Y-28));miniPos=Mini.Position
  else local sw,sh=W*Scale.Scale,H*Scale.Scale;Holder.Position=UDim2.fromOffset(math.clamp(bx,sw/2+4,v.X-sw/2-4),math.clamp(by,sh/2+4,v.Y-sh/2-4));expanded=Holder.Position end
 end))

 function window:Destroy()
  if self.Closed then return end;self.Closed=true;Library.Unloaded=true
  for i=#conns,1,-1 do pcall(function()conns[i]:Disconnect()end);conns[i]=nil end
  if SG.Parent then SG:Destroy()end
 end
 own(Close.Activated:Connect(function()if type(cfg.OnClose)=="function"then pcall(cfg.OnClose)end;window:Destroy()end))
 return window
end

function Library:SetNotification(info)
 local w=self._LastWindow;if w and not w.Closed then w:Notify(info,false)end
end

return Library
