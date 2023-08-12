
AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local SPRITE_SIZE = 128

local PLAYER = {}

PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.SlowWalkSpeed		= 100
PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 320

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()


	self.Player:Give( "none" )
    self.Player:RemoveSuit()
	self.Player:Give( "gmod_camera" )
    self.Player:Give("weapon_fists")


	if ( self.Player:IsAdmin() ) then
        self.Player:EquipSuit()
        self.Player:SetArmor(200)
		self.Player:GiveAmmo( 256,	"Pistol", 		true )
		self.Player:GiveAmmo( 256,	"SMG1", 		true )
		self.Player:GiveAmmo( 5,	"grenade", 		true )
		self.Player:GiveAmmo( 64,	"Buckshot", 	true )
		self.Player:GiveAmmo( 32,	"357", 			true )
		self.Player:GiveAmmo( 32,	"XBowBolt", 	true )
		self.Player:GiveAmmo( 6,	"AR2AltFire", 	true )
		self.Player:GiveAmmo( 100,	"AR2", 			true )

		self.Player:Give( "weapon_crowbar" )
		self.Player:Give( "weapon_pistol" )
		self.Player:Give( "weapon_smg1" )
		self.Player:Give( "weapon_frag" )
		self.Player:Give( "weapon_physcannon" )
		self.Player:Give( "weapon_crossbow" )
		self.Player:Give( "weapon_shotgun" )
		self.Player:Give( "weapon_357" )
		self.Player:Give( "weapon_rpg" )
		self.Player:Give( "weapon_ar2" )

		-- The only reason I'm leaving this out is because
		-- I don't want to add too many weapons to the first
		-- row because that's where the gravgun is.
	    self.Player:Give( "weapon_physgun" )
	    self.Player:Give( "weapon_stunstick" )

        self.Player:Give( "gmod_tool" )
	end

	self.Player:SetModel("models/bonzi/bonzibuddy.mdl")
	self.Player:SelectWeapon("none")
end

function PLAYER:SetModel()
    
    util.PrecacheModel("models/bonzi/bonzibuddy.mdl")
	self.Player:SetModel("models/bonzi/bonzibuddy.mdl")

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )
	if CLIENT then
		self:SetRenderBounds(
			Vector(-SPRITE_SIZE / 2, -SPRITE_SIZE / 2, 0),
			Vector(SPRITE_SIZE / 2, SPRITE_SIZE / 2, SPRITE_SIZE),
			Vector(5, 5, 5)
		)
	end

end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

function PLAYER:GetHandsModel()

	return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

end

--
-- Reproduces the jump boost from HL2 singleplayer
--
local JUMPING

function PLAYER:StartMove( move )

	-- Only apply the jump boost in FinishMove if the player has jumped during this frame
	-- Using a global variable is safe here because nothing else happens between SetupMove and FinishMove
	if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and self.Player:OnGround() then
		JUMPING = true
	end

end

function PLAYER:FinishMove( move )

	-- If the player has jumped this frame
	if ( JUMPING ) then
		-- Get their orientation
		local forward = move:GetAngles()
		forward.p = 0
		forward = forward:Forward()
        --[[
		-- Compute the speed boost

		-- HL2 normally provides a much weaker jump boost when sprinting
		-- For some reason this never applied to GMod, so we won't perform
		-- this check here to preserve the "authentic" feeling
		local speedBoostPerc = ( ( not self.Player:Crouching() ) and 0.5 ) or 0.1

		local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
		local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
		local newSpeed = speedAddition + move:GetVelocity():Length2D()

		-- Clamp it to make sure they can't bunnyhop to ludicrous speed
		if newSpeed > maxSpeed then
			speedAddition = speedAddition - (newSpeed - maxSpeed)
		end

		-- Reverse it if the player is running backwards
		if move:GetVelocity():Dot(forward) < 0 then
			speedAddition = -speedAddition
		end

		-- Apply the speed boost
		move:SetVelocity(forward * speedAddition + move:GetVelocity())]]
	end

	JUMPING = nil

end
 
player_manager.RegisterClass( "bonzibuddy", PLAYER, "player_default" )