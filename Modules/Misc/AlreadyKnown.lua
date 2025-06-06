local E, L, V, P, G = unpack(ElvUI)
local AK = E:NewModule("Enhanced_AlreadyKnown", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local match = string.match
local ceil, fmod = math.ceil, math.fmod

-- local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GetAuctionItemClasses = GetAuctionItemClasses
-- local GetAuctionItemInfo = GetAuctionItemInfo
-- local GetAuctionItemLink = GetAuctionItemLink
local GetBuybackItemInfo = GetBuybackItemInfo
local GetBuybackItemLink = GetBuybackItemLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local GetItemInfo = GetItemInfo
local GetMerchantItemInfo = GetMerchantItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantNumItems = GetMerchantNumItems
-- local GetNumAuctionItems = GetNumAuctionItems
local GetNumBuybackItems = GetNumBuybackItems
local IsAddOnLoaded = IsAddOnLoaded
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor

local BUYBACK_ITEMS_PER_PAGE = BUYBACK_ITEMS_PER_PAGE
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local MERCHANT_ITEMS_PER_PAGE = MERCHANT_ITEMS_PER_PAGE

local knownColor = {r = 0.1, g = 1.0, b = 0.2}

local function MerchantFrame_UpdateMerchantInfo()
	local numItems = GetMerchantNumItems()

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]

		if button and button:IsShown() then
			local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)

			if isUsable and AK:IsAlreadyKnown(GetMerchantItemLink(index)) then
				local r, g, b = knownColor.r, knownColor.g, knownColor.b

				if numAvailable == 0 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end

				SetItemButtonTextureVertexColor(button, r, g, b)
			end
		end
	end
end

local function MerchantFrame_UpdateBuybackInfo()
	local numItems = GetNumBuybackItems()

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		if i > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]

		if button and button:IsShown() then
			local _, _, _, _, _, isUsable = GetBuybackItemInfo(i)

			if isUsable and AK:IsAlreadyKnown(GetBuybackItemLink(i)) then
				SetItemButtonTextureVertexColor(button, knownColor.r, knownColor.g, knownColor.b)
			end
		end
	end
end

-- local function AuctionFrameBrowse_Update()
--	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
--	-- print("112312312")

--	for i=1, _G.NUM_BROWSE_TO_DISPLAY do
--		-- print(i)
--		if (_G["BrowseButton"..i.."Item"] and _G["BrowseButton"..i.."ItemIconTexture"]) or _G["BrowseButton"..i].id then -- Something to do with ARL?
--			local itemLink
--			if _G["BrowseButton"..i].id then
--				itemLink = GetAuctionItemLink('list', _G["BrowseButton"..i].id)
--			else
--				itemLink = GetAuctionItemLink('list', offset + i)
--			end

--			if itemLink and _checkIfKnown(itemLink) then
--				if _G["BrowseButton"..i].id then
--					_G["BrowseButton"..i].Icon:SetVertexColor(db.r, db.g, db.b)
--				else
--					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(db.r, db.g, db.b)
--				end

--				if db.monochrome then
--					if _G["BrowseButton"..i].id then
--						_G["BrowseButton"..i].Icon:SetDesaturated(true)
--					else
--						_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(true)
--					end
--				end
--			else
--				if _G["BrowseButton"..i].id then
--					_G["BrowseButton"..i].Icon:SetVertexColor(1, 1, 1)
--					_G["BrowseButton"..i].Icon:SetDesaturated(false)
--				else
--					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(1, 1, 1)
--					_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(false)
--				end
--			end
--		end
--	end
-- end

local function AuctionFrameBid_Update()
	-- local numItems = GetNumAuctionItems("bidder")
	-- local offset = FauxScrollFrame_GetOffset(BidScrollFrame)

	-- for i = 1, NUM_BIDS_TO_DISPLAY do
	--	local index = offset + i
	--	if index > numItems then return end

	--	local texture = _G["BidButton"..i.."ItemIconTexture"]

	--	if texture and texture:IsShown() then
	--		local _, _, _, _, canUse = GetAuctionItemInfo("bidder", index)

	--		if canUse and AK:IsAlreadyKnown(GetAuctionItemLink("bidder", index)) then
	--			texture:SetVertexColor(knownColor.r, knownColor.g, knownColor.b)
	--		end
	--	end
	-- end
end

local function AuctionFrameAuctions_Update()
	-- local numItems = GetNumAuctionItems("owner")
	-- local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)

	-- for i = 1, NUM_AUCTIONS_TO_DISPLAY do
	--	local index = offset + i
	--	if index > numItems then return end

	--	local texture = _G["AuctionHouseFrameBrowseResultsFrameItemListScrollFrameButton"..i]

	--	if texture and texture:IsShown() then
	--		local _, _, _, _, canUse, _, _, _, _, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)

	--		if canUse and AK:IsAlreadyKnown(GetAuctionItemLink("owner", index)) then
	--			local r, g, b = knownColor.r, knownColor.g, knownColor.b
	--			if saleStatus == 1 then
	--				r, g, b = r * 0.5, g * 0.5, b * 0.5
	--			end

	--			texture:SetVertexColor(r, g, b)
	--		end
	--	end
	-- end
end

local function GuildBankFrame_Update()
	if GuildBankFrame.mode ~= "bank" then return end
	local tab = GetCurrentGuildBankTab()
	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local button = _G["GuildBankColumn"..ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP).."Button"..fmod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)]
		if button and button:IsShown() then
			local texture, _, locked = GetGuildBankItemInfo(tab, i)
			if texture and not locked then
				if AK:IsAlreadyKnown(GetGuildBankItemLink(tab, i)) then
					SetItemButtonTextureVertexColor(button, knownColor.r, knownColor.g, knownColor.b)
				else
					SetItemButtonTextureVertexColor(button, 1, 1, 1)
				end
			end
		end
	end

--	local numItems = GetNumAuctionItems("owner")
--	-- local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)

--	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
--		local index = offset + i
--		if index > numItems then return end

--		local texture = _G["AuctionHouseFrameBrowseResultsFrameItemListScrollFrameButton"..i]

--		if texture and texture:IsShown() then
--			local _, _, _, _, canUse, _, _, _, _, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)

--			if canUse and AK:IsAlreadyKnown(GetAuctionItemLink("owner", index)) then
--				local r, g, b = knownColor.r, knownColor.g, knownColor.b
--				if saleStatus == 1 then
--					r, g, b = r * 0.5, g * 0.5, b * 0.5
--				end

--				texture:SetVertexColor(r, g, b)
--			end
--		end
--	end
end

function AK:IsAlreadyKnown(itemLink)
	if not itemLink then return end

	local itemID = match(itemLink, "item:(%d+):")
	if self.knownTable[itemID] then return true end

	local _, _, _, _, _, itemType = GetItemInfo(itemLink)
	if not self.knowableTypes[itemType] then return end

	self.scantip:ClearLines()
	self.scantip:SetHyperlink(itemLink)

	for i = 2, self.scantip:NumLines() do
		local text = _G["ElvUI_MerchantAlreadyKnownTextLeft"..i]:GetText()

		if text == ITEM_SPELL_KNOWN then
			self.knownTable[itemID] = true
			return true
		end
	end
end

function AK:ADDON_LOADED(_, addon)
	if addon == "Custom_AuctionHouseUI" and not self.auctionHooked then
	-- print("1")
		self:SetHooks()
	elseif addon == "Blizzard_GuildBankUI" and not self.guildBankHooked then
		self:SetHooks()
	end

	if self.auctionHooked and self.guildBankHooked then
		self:UnregisterEvent("ADDON_LOADED")
	end
end
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
-- hooksecurefunc(AuctionHouseBrowseResultsFrameMixin,"UpdateBrowseResults",AuctionFrameBrowse_Update)
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
		--------firs hoook?
function AK:SetHooks()
	if not self:IsHooked("MerchantFrame_UpdateMerchantInfo") then
		self:SecureHook("MerchantFrame_UpdateMerchantInfo", MerchantFrame_UpdateMerchantInfo)
	end
	if not self:IsHooked("MerchantFrame_UpdateBuybackInfo") then
		self:SecureHook("MerchantFrame_UpdateBuybackInfo", MerchantFrame_UpdateBuybackInfo)
	end

	if not self.auctionHooked and IsAddOnLoaded("Custom_AuctionHouseUI") then
		-- if not self:IsHooked("AuctionHouseBrowseResultsFrameMixin:UpdateBrowseResults") then
			-- self:SecureHook("AuctionFrameBrowse_Update", AuctionFrameBrowse_Update)
		-- end



		if not self:IsHooked("AuctionFrameBid_Update") then

			self:SecureHook("AuctionFrameBid_Update", AuctionFrameBid_Update)
		end
		if not self:IsHooked("AuctionFrameAuctions_Update") then
			self:SecureHook("AuctionFrameAuctions_Update", AuctionFrameAuctions_Update)
		end

		self.auctionHooked = true
	end

	if not self.guildBankHooked and IsAddOnLoaded("Blizzard_GuildBankUI") then
		if not self:IsHooked("GuildBankFrame_Update") then
			self:SecureHook("GuildBankFrame_Update", GuildBankFrame_Update)
		end

		self.guildBankHooked = true
	end
end

function AK:IsLoadeble()
	return not (IsAddOnLoaded("RecipeKnown") or IsAddOnLoaded("AlreadyKnown"))
end

function AK:ToggleState()
	if not self:IsLoadeble() then return end

	if not self.initialized then
		self.scantip = CreateFrame("GameTooltip", "ElvUI_MerchantAlreadyKnown", nil, "GameTooltipTemplate")
		self.scantip:SetOwner(UIParent, "ANCHOR_NONE")

		self.knownTable = {}

		local _, _, _, consumable, glyph, _, recipe, _, miscallaneous = GetAuctionItemClasses()
		self.knowableTypes = {
			[consumable] = true,
			[glyph] = true,
			[recipe] = true,
			[miscallaneous] = true
		}

		self.initialized = true
	end

	if E.db.enhanced.general.alreadyKnown then
		self:SetHooks()

		if not (IsAddOnLoaded("Custom_AuctionHouseUI") and IsAddOnLoaded("Blizzard_GuildBankUI")) then
			self:RegisterEvent("ADDON_LOADED")
		end
	else
		self:UnhookAll()

		self.auctionHooked = nil
		self.guildBankHooked = nil
	end
end

function AK:Initialize()
	if not E.db.enhanced.general.alreadyKnown then return end

	self:ToggleState()
end

local function InitializeCallback()
	AK:Initialize()
end

E:RegisterModule(AK:GetName(), InitializeCallback)
