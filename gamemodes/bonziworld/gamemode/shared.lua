AddCSLuaFile()

DeriveGamemode( "sandbox" )

GM.Name = "BonziWORLD 3D"
GM.Author = "Daisreich"
GM.Email = "N/A"
GM.Website = "https://steamcommunity.com/sharedfiles/filedetails/?id=2693835351"

CreateConVar("bonziworld_2donly","0",{FCVAR_ARCHIVE,FCVAR_NOTIFY})

function GM:Initialize()
	-- Do stuff
end
function GM:Think()
end

hook.Add("MouthMoveAnimation","EnhancedLipsync",function( ply )

	local flexes = {
		ply:GetFlexIDByName( "jaw_drop" ),
		ply:GetFlexIDByName( "left_part" ),
		ply:GetFlexIDByName( "right_part" ),
		ply:GetFlexIDByName( "left_mouth_drop" ),
		ply:GetFlexIDByName( "right_mouth_drop" ),
		ply:GetFlexIDByName( "AH" )
	}
	if CLIENT then
		local weight = math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) || 0

		for k, v in pairs( flexes ) do
			ply:SetFlexWeight( v, weight )
		end
	end
end)
-- We don't usually use this spot for parts of this gamemode.