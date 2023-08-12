AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "player_class/bonzibuddy.lua" )

include( "shared.lua" ) 

CreateConVar("bonziworld_enableotherpms","0",{FCVAR_ARCHIVE,FCVAR_NOTIFY})

local dectalk = CreateConVar("bonziworld_alternatetts","0",{FCVAR_ARCHIVE,FCVAR_NOTIFY},"Enables Dectalk TTS. Use this for fallback in case Voiceforge is down.")
local enablepitch = CreateConVar("bonziworld_enablepitch","0",{FCVAR_ARCHIVE,FCVAR_NOTIFY},"Enables Pitch on the Text to Speech.")


local BonziActivityTranslate = {}

DEFINE_BASECLASS("gamemode_base")
DeriveGamemode("sandbox")
GM.IsSandboxDerived = true


util.AddNetworkString( "BonziSpeak" )
util.AddNetworkString( "BonziSpeak2" )
util.AddNetworkString( "BonziSpeakAlt" )
hook.Add( "DoPlayerDeath","BZWFreezeCam",function(ply, attacker, dmginfo)

	if (attacker:IsPlayer() and attacker != ply) then
		ply:Spectate(OBS_MODE_DEATHCAM)
		ply:SpectateEntity(attacker)
		timer.Simple(0 + 1.5 + 0.4 - 0.3, function()
			if (!ply:Alive()) then
				ply:PrintMessage(HUD_PRINTCENTER,"You were killed by "..attacker:Name())
				ply:SendLua("surface.PlaySound('ui/freeze_cam.wav')")
			end
		end)
		timer.Simple(1.7, function()
			if (!ply:Alive()) then
				ply:Spectate(OBS_MODE_FREEZECAM)
				ply:SpectateEntity(attacker)
			end
		end)
	else
		ply:Spectate(OBS_MODE_DEATHCAM)
	end

end)
hook.Add( "PlayerSpawnedNPC", "SetColorForRandomBonzi", function( ply,ent )
	if ( ent:GetName() == "npc_bonzi_random" || ent:GetName() == "npc_bonzi_kiddie" ) then
		
		if (GetConVar("bonziworld_2donly"):GetBool()) then
			ent:SetColor(table.Random({ 
				Color( 255, 255, 255, 0 ),
				Color( 255, 0, 0, 0 ),
				Color( 0, 255, 0, 0 ), 
				Color( 0, 250, 255, 0 ),
				Color( 0, 0, 255, 0 ),
				Color( 20, 20, 20, 0 ),
				Color( 255, 161, 0, 0 ),
				Color( 255, 20, 147, 0 ),
				Color( 255, 255, 255, 0 ),
			}))
		else
			ent:SetColor(table.Random({ 
				Color( 255, 255, 255, 255 ),
				Color( 255, 0, 0, 255 ),
				Color( 0, 255, 0, 255 ), 
				Color( 0, 250, 255, 255 ),
				Color( 0, 0, 255, 255 ),
				Color( 20, 20, 20, 255 ),
				Color( 255, 161, 0, 255 ),
				Color( 255, 20, 147, 255 ),
				Color( 255, 255, 255, 255 ) 
			}))
		end
		
	elseif ( ent:GetName() == "npc_bonzi_pope" ) then
		
		if (GetConVar("bonziworld_2donly"):GetBool()) then
			ent:SetColor(Color( 100, 100, 100, 0 ))
		else
			ent:SetColor(Color( 270, 270, 270, 255 ))
		end
		
	end
end )
hook.Add( "PlayerSay", "BonziSpeak", function( ply, text, team )
    if not team then
        if string.sub( text, 1, 1 ) != "/" and string.sub( text, 1, 1 ) != "!" and string.sub( text, 1, 1 ) != "@" then
			if (dectalk:GetBool()) then
				net.Start( "BonziSpeakAlt" )
				net.WriteString( text )
				net.WriteEntity( ply )
				net.Broadcast()
			elseif (enablepitch:GetBool()) then
				net.Start( "BonziSpeak2" )
				net.WriteString( text )
				net.WriteEntity( ply )
				net.Broadcast()
			else
				net.Start( "BonziSpeakAlt" )
				net.WriteString( text )
				net.WriteEntity( ply )
				net.Broadcast()
			end
        end
		local strText = string.lower( text ) -- make the string lower case 
		if (strText == "/fact") then
			local whoopdeedoo = table.Random({"Hey kids, it's time for a Fun Fact!"})
			
			net.Start( "BonziSpeakAlt" )
				net.WriteString( whoopdeedoo )
				net.WriteEntity( ply )
			net.Broadcast()
			PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..whoopdeedoo)
			timer.Simple(1 * (string.len(whoopdeedoo) * 0.073), function()
				local joketext = table.Random({"Did you know that Yer Anus is 31 thousand 500 and 18 miles in diameter?","Fun Fact: The skript kiddie of this site didn't bother checking if the text that goes into the dialog box is HTML code: toppest jej"})
				net.Start( "BonziSpeakAlt" )
				net.WriteString( joketext )
				net.WriteEntity( ply )
				net.Broadcast()
				PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..joketext)
				timer.Simple(1 * (string.len(joketext) * 0.073), function()
					local joketext = table.Random({"o gee whilickers wasn't that sure interesting huh"})
					net.Start( "BonziSpeakAlt" )
					net.WriteString( joketext )
					net.WriteEntity( ply )
					net.Broadcast()
					PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..joketext)
				end)
			end)
		end
		if (strText == "/pawn") then
			local cuttext1 = table.Random({"Hi, my name is BonziBUDDY, and this is my website. I meme here with my old harambe, and my son, Clippy. Everything in here has"})
			local cuttext2 = "an ad and a fact. One thing I've learned after 17 years - you never know what is gonna give you some malware."
			local actualtext = table.Random({"Hi, my name is BonziBUDDY, and this is my website. I meme here with my old harambe, and my son, Clippy. Everything in here has an ad and a fact. One thing I've learned after 17 years - you never know what is gonna give you some malware."})
			net.Start( "BonziSpeakAlt" )
            net.WriteString( actualtext )
            net.WriteEntity( ply )
            net.Broadcast()
			PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..cuttext1)
			PrintMessage(HUD_PRINTTALK, cuttext2)
		end
		if (strText == "/joke") then
			local whoopdeedoo = table.Random({ply:Nick().. " used /joke. Whoop-dee-fucking doo.","HEY YOU IDIOTS ITS TIME FOR A JOKE","Wanna hear a joke? No? Stay far away from me then.","Time for whatever horrible fucking jokes the creator of this gamemode wrote.","Senpai "..ply:Nick().." wants me to tell a joke.","Yeah, of course "..ply:Nick().." wants me to tell a joke. Hah hah! Look at the stupid "..ply:GetInfo("bonziworld_bonzicolor").." monkey telling jokes! Fuck you. It isn't funny. But i'll do it anyway. Because you want me to. I hope you're happy."})
			
			PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..whoopdeedoo)
			net.Start( "BonziSpeakAlt" )
				net.WriteString( whoopdeedoo )
				net.WriteEntity( ply )
			net.Broadcast()
			timer.Simple(1 * (string.len(whoopdeedoo) * 0.073), function()
				local joketext = table.Random({"What is a cow that eats grass? ASS! I'm a comedic genius, i know.","Who earns a living by driving his customers away? Nintendo!","Why do they call HTML HyperText? AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA! Sorry. I just had an epiphany of my own sad, sad existence.","Two sausages are in a pan. One looks at the other and says, Boy it's hot in here! and the other sausage says, Unbelievable! It's a talking sausage!","What is in the middle of Paris? A giant inflatable buttplug.","What goes in pink and comes out blue? Sonic's asshole.","What type of water won't freeze? Your mothers."})
				PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..joketext)
				net.Start( "BonziSpeakAlt" )
				net.WriteString( joketext ) 
				net.WriteEntity( ply )
				net.Broadcast()
				timer.Simple(1 * (string.len(joketext) * 0.073), function()
				
					local endjoketext = table.Random({"You know "..ply:Nick()..", a good friend laughs at your jokes even when they're not so funny. And you fricking stink. Thanks.","Where do I come up with these? My ass?","Do I amuse you, "..ply:Nick().."? Am I funny? Do I make you laugh? please respond","Maybe I'll keep my day job, "..ply:Nick()..". Youtube Monetization didn't accept me.","Laughter is the best medicine! Apart from meth."})
					PrintMessage(HUD_PRINTTALK, ply:Nick()..": "..endjoketext)
					net.Start( "BonziSpeakAlt" )
					net.WriteString( endjoketext )
					net.WriteEntity( ply )
					net.Broadcast()
				end)
			end)
		end
    end
end )


hook.Add("OnPlayerChat", "BonziPope", function(ply, strText, bTeamOnly)
		
	if IsValid(ply) and ply:IsPlayer() then
				if !ply:IsAdmin() then
					if !bTeamOnly then
						chat.AddText(v[3], nickteam, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					else
						chat.AddText(v[3], nickteam, color_white,"(TEAM) ", ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					end
				else
					if !bTeamOnly then
						chat.AddText(v[3], color_white,"(POPE) ", Colour, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					else
						chat.AddText(v[3], color_white,"(POPE) ", "(TEAM) ", Colour, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					end
				end
	end
	if !IsValid(ply) and !ply:IsPlayer() then
		local ConsoleColor = Color(0, 255, 0) --Change this to change Console name color
		chat.AddText(ConsoleColor, "Console", color_white, ": ", strText)
		return true
	end
end )

function GM:Think(  )
	for _,ply in ipairs(player.GetAll()) do
		if (IsValid(ply) and ply:IsPlayer() and ply:IsAdmin()) then
			for k,v in ipairs(ents.FindInSphere(ply:GetPos(),300)) do
				if (v:GetClass() == "item_suitcharger") then
					if (!v.PopePowered) then
						v:Fire("addoutput","spawnflags 8192")
						v:Fire("recharge")
						v:EmitSound("common/launch_upmenu1.wav",95,100,0.2,CHAN_WEAPON)
						v.PopePowered = true
					end
					if (v.PopePowered) then
						timer.Create("CitadelCharge"..ply:EntIndex(), 0.1, 1, function()
							v:Fire("addoutput","spawnflags 0")
							v.PopePowered = false
							v:Fire("recharge")
							v:EmitSound("common/launch_dnmenu1.wav",95,100,0.2,CHAN_WEAPON)
						end)
					end
				end
			end
		end
	end
end

function GM:PlayerInitialSpawn( ply )
    PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has joined the room" )
	timer.Simple(3, function()
	
		ply:SendLua("surface.PlaySound('bonziworld/welcome.wav')")

	end)
	BaseClass.PlayerInitialSpawn( self, ply )
end
hook.Add( "PlayerConnect", "BZWJoinGlobalMessage", function( name, ip )
	EmitSound( Sound( "bonziworld/join.wav" ), Entity(1):GetPos(), 1, CHAN_AUTO, 1, 0, 0, 100 )
end)
hook.Add( "PlayerDisconnected", "BZWPlayerleave", function(ply)
	ply:EmitSound("bonziworld/leave.wav",95,150,0.2,CHAN_WEAPON)
    PrintMessage( HUD_PRINTTALK, ply:Name().. " has left the room. " )
end )
hook.Add( "ShutDown", "BZWServerShuttingDown", function()
	EmitSound( Sound( "bonziworld/shutdown.wav" ), Entity(1):GetPos(), 1, CHAN_AUTO, 1, 0, 0, 100 )
end )
function GM:DoPlayerDeath( ply, attacker, dmg )
	ply:EmitSound("die"..math.random(1,3)..".wav",95)
	BaseClass.DoPlayerDeath(self,ply,attacker,dmg)
end
function GM:PlayerSpawn( ply, transition )
    
	local col = ply:GetInfo( "cl_playercolor" )
    player_manager.SetPlayerClass( ply, "bonzibuddy" ) 
    ply:EmitSound("bonziworld/join.wav",95,100,1,CHAN_WEAPON)
    if (ply:GetInfo("bonziworld_bonzicolor") == "purple") then
	    ply:SetColor( Color( 255, 255, 255, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "red") then
	    ply:SetColor( Color( 255, 0, 0, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "green") then
	    ply:SetColor( Color( 0, 255, 0, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "cyan") then
	    ply:SetColor( Color( 0, 250, 255, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "blue") then
	    ply:SetColor( Color( 0, 0, 255, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "black") then
	    ply:SetColor( Color( 20, 20, 20, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "brown") then
	    ply:SetColor( Color( 255, 161, 0, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "pink") then
	    ply:SetColor( Color( 255, 20, 147, 255 ) )
    else
		if (GetConVar("bonziworld_2donly"):GetBool()) then
			ply:SetColor(table.Random({ 
				Color( 255, 255, 255, 0 ),
				Color( 255, 0, 0, 0 ),
				Color( 0, 255, 0, 0 ), 
				Color( 0, 250, 255, 0 ),
				Color( 0, 0, 255, 0 ),
				Color( 20, 20, 20, 0 ),
				Color( 255, 161, 0, 0 ),
				Color( 255, 20, 147, 0 ),
				Color( 255, 255, 255, 0 ),
			}))
		else
			ply:SetColor(table.Random({ 
				Color( 255, 255, 255, 255 ),
				Color( 255, 0, 0, 255 ),
				Color( 0, 255, 0, 255 ), 
				Color( 0, 250, 255, 255 ),
				Color( 0, 0, 255, 255 ),
				Color( 20, 20, 20, 255 ),
				Color( 255, 161, 0, 255 ),
				Color( 255, 20, 147, 255 ),
				Color( 255, 255, 255, 255 ) 
			}))
		end
    end
	ply.IsRandomizedP = false
	ply.IsRandomizedS = false 
	if (ply:GetInfo("bonziworld_bonzipitch") == "random") then
		ply:SetNWInt("bonzipitch",math.random(15,125))
	else
		ply:SetNWInt("bonzipitch",ply:GetInfo("bonziworld_bonzipitch"))
	end
	if (ply:GetInfo("bonziworld_bonzispeed") == "random") then
		ply:SetNWInt("bonzispeed",math.random(125,275))
	else
		ply:SetNWInt("bonzispeed",ply:GetInfo("bonziworld_bonzispeed"))
	end
    ply:SetNWString("bonzicolor",ply:GetInfo("bonziworld_bonzicolor"))
    ply:SetNWString("bonzivoice",ply:GetInfo("bonziworld_bonzivoice"))
	ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
	BaseClass.PlayerSpawn( self, ply, transition )
end


if pcall(require,"pk_pills") then
	pk_pills.packStart("BonziFUN","bzw_fun","icon16/monkey.png")
	local function all_humans()
		--{model="models/Combine_Super_Soldier.mdl"},
		--{model="models/Combine_Soldier_PrisonGuard.mdl"},
		--{model="models/Combine_Soldier.mdl"},
		--{model="models/Police.mdl"}
		return {
			{
				model = "models/bonzi/bonzibuddy.mdl"
			},
		}
	end

	pk_pills.register("bonzifun_e", {
		printName = "WE LOVE Bonzi",
		model = false,
		options = all_humans,
		parent = "antlion_guard",
		anims = {
			default = {
				idle = "fear_reaction_idle",
				run = "run_protected_all",
				jump = "cower",
				glide = "cower_idle",
				jump_attack = "cower",
				glide_attack = "cower_idle",
				attack = "walkaimall1",
				climb = "lineidle02",
				climb_start = "jump_holding_jump",
				release = "swing"
			}
		},
		boneMorphs = {
			["ValveBiped.Bip01_Spine"] = {
				rot = Angle(90, 0, 0)
			},
			["ValveBiped.Bip01_Head1"] = {
				scale = Vector(2, 2, 2),
				rot = Angle(90, 0, 0)
			}
		},
		crab = "melon"
	})

	pk_pills.register("bonzifun_k", {
		printName = "BONZI IS THE BEST",
		model = false,
		options = all_humans,
		parent = "antlion",
		modelScale = 1,
		anims = {
			default = {
				idle = "sit_ground",
				walk = "walk_all",
				run = "run_protected_all",
				fly = "run_protected_all",
				jump = "run_protected_all",
				glide = "run_protected_all",
				melee1 = "meleeattack01",
				melee2 = "meleeattack01",
				melee3 = "meleeattack01",
				charge_start = "jump_holding_land",
				charge_loop = "crouchrunall1",
				charge_hit = "kick_door",
				burrow_in = "idle_to_sit_ground",
				burrow_out = "sit_ground_to_idle",
				burrow_loop = "injured1"
			}
		},
		boneMorphs = {
			["ValveBiped.Bip01_Pelvis"] = {
				scale = Vector(2, 2, 2),
				rot = Angle(0, 0, 20),
				pos = Vector(0, 0, 0)
			},
			["ValveBiped.Bip01_Spine"] = {
				scale = Vector(2, 2, 1)
			},
			["ValveBiped.Bip01_Spine1"] = {
				scale = Vector(2, 2, 1)
			},
			["ValveBiped.Bip01_Spine2"] = {
				scale = Vector(2, 2, 1)
			},
			["ValveBiped.Bip01_Spine4"] = {
				scale = Vector(2, 2, 1)
			},
			["ValveBiped.Bip01_Head1"] = {
				scale = Vector(4, 4, 1),
				rot = Angle(0, 20, 0)
			},
			["ValveBiped.Bip01_L_Clavicle"] = {
				pos = Vector(0, 0, 10)
			},
			["ValveBiped.Bip01_R_Clavicle"] = {
				pos = Vector(0, 0, -10)
			}
		},
		--["ValveBiped.Bip01_R_Forearm"]={pos=Vector(-100,0,-100),scale=Vector(1,100,1)},
		--["ValveBiped.Bip01_L_Forearm"]={pos=Vector(-100,0,100),scale=Vector(1,100,1)},
		--["ValveBiped.Bip01_R_Foot"]={pos=Vector(20,0,0)},
		--["ValveBiped.Bip01_L_Foot"]={pos=Vector(20,0,0)},
		--[[moveSpeed={
			walk=100,
			run=400
		},]]
		movePoseMode = "yaw"
	})

	pk_pills.register("bonzifun_a", {
		printName = "Bonzi IS A COOL GUY",
		parent = "antlion",
		side = "harmless",
		type = "ply",
		model = false,
		anims = {
			default = {
				idle = "sit_ground",
				walk = "walk_all",
				run = "run_protected_all",
				fly = "run_protected_all",
				jump = "run_protected_all",
				glide = "run_protected_all",
				melee1 = "meleeattack01",
				melee2 = "meleeattack01",
				melee3 = "meleeattack01",
				charge_start = "jump_holding_land",
				charge_loop = "crouchrunall1",
				charge_hit = "kick_door",
				burrow_in = "idle_to_sit_ground",
				burrow_out = "sit_ground_to_idle",
				burrow_loop = "injured1"
			}
		},
		options = all_humans,
		camera = {
			--offset=Vector(0,0,40),
			dist = 300
		},
		hull = Vector(200, 200, 100),
		modelScale = 2,
		boneMorphs = {
			["ValveBiped.Bip01_Pelvis"] = {
				scale = Vector(2, 2, 2),
				rot = Angle(0, 0, 90),
				pos = Vector(0, 0, 0)
			},
			["ValveBiped.Bip01_Spine"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Spine1"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Spine2"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Spine4"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Head1"] = {
				scale = Vector(4, 4, 4),
				rot = Angle(0, 90, 0)
			},
			["ValveBiped.Bip01_L_Clavicle"] = {
				pos = Vector(0, 0, 10)
			},
			["ValveBiped.Bip01_R_Clavicle"] = {
				pos = Vector(0, 0, -10)
			},
			["ValveBiped.Bip01_R_Forearm"] = {
				pos = Vector(50, 0, 0)
			},
			["ValveBiped.Bip01_L_Forearm"] = {
				pos = Vector(50, 0, 0)
			},
			["ValveBiped.Bip01_R_Foot"] = {
				pos = Vector(20, 0, 0)
			},
			["ValveBiped.Bip01_L_Foot"] = {
				pos = Vector(20, 0, 0)
			}
		},
		moveSpeed = {
			walk = 100,
			run = 400
		},
		movePoseMode = "yaw",
		jumpPower = 400,
		health = 40,
		muteSteps = true
	})

	pk_pills.register("flying_bonzi", {
		printName = "FLYING BONZI",
		parent = "phantom",
		model = false,
		options = all_humans,
		driveOptions = {
			speed = 5000
		},
		camera = {
			dist = 500
		}
	})
	pk_pills.register("flying_bonzi2", {
		printName = "BONZI'S SURF BOARD",
		parent = "phantom",
		model = "models/bonzi/surfboard.mdl",
		camera = {
			dist = 500
		}
	})
	pk_pills.register("bonzi_globe", {
		printName = "BONZI'S GLOBE",
		parent = "melon",
		model = "models/bonzi/globe.mdl",
	})
	
	

	pk_pills.register("bonzifun_j", {
		printName = "GIVE US Bonzi",
		model = false,
		options = all_humans,
		parent = "bird_pigeon",
		modelScale = .2,
		anims = {
			default = {
				idle = "sit_ground",
				walk = "walk_all",
				run = "run_protected_all",
				fly = "run_protected_all",
				jump = "run_protected_all",
				glide = "run_protected_all",
				eat = "preskewer"
			}
		},
		boneMorphs = {
			["ValveBiped.Bip01_Pelvis"] = {
				scale = Vector(2, 2, 2),
				rot = Angle(0, 0, 20),
				pos = Vector(0, 0, 0)
			},
			["ValveBiped.Bip01_Spine"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Spine1"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Spine2"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Spine4"] = {
				scale = Vector(2, 2, 2)
			},
			["ValveBiped.Bip01_Head1"] = {
				scale = Vector(4, 4, 4),
				rot = Angle(0, 20, 0)
			},
			["ValveBiped.Bip01_L_Clavicle"] = {
				pos = Vector(0, 0, 10)
			},
			["ValveBiped.Bip01_R_Clavicle"] = {
				pos = Vector(0, 0, -10)
			},
			["ValveBiped.Bip01_R_Forearm"] = {
				pos = Vector(-100, 0, -100),
				scale = Vector(1, 100, 1)
			},
			["ValveBiped.Bip01_L_Forearm"] = {
				pos = Vector(-100, 0, 100),
				scale = Vector(1, 100, 1)
			}
		},
		--["ValveBiped.Bip01_R_Foot"]={pos=Vector(20,0,0)},
		--["ValveBiped.Bip01_L_Foot"]={pos=Vector(20,0,0)},
		--[[moveSpeed={
			walk=100,
			run=400
		},]]
		movePoseMode = "yaw"
	})

	--jumpPower=400,
	--health=40,
	--muteSteps=true
	pk_pills.register("bonzifun_2", {
		printName = "~ALL HAIL Bonzi~",
		parent = "hero_overseer",
		model = false,
		options = all_humans,
		anims = {
			default = {
				idle = "fear_reaction_idle"
			}
		},
		attack2 = {
			mode = "trigger",
			func = function(ply, ent)
				if not ply:OnGround() then return end
				ent:EmitSound("weapons/crowbar/crowbar_impact1.wav",95,math.random(50,150))
				local puppet = ent:GetPuppet()

				for i = 1, puppet:GetBoneCount() do
					puppet:ManipulateBonePosition(i, puppet:GetManipulateBonePosition(i) + VectorRand() * 3)
				end
			end
		},
		sounds = {
			clang = "weapons/crowbar/crowbar_impact1.wav"
		}
	})
end

local function AddNPC( t, class )
	list.Set( "NPC", class or t.Class, t )
end

AddNPC( {
	Name = "Bonzi",
	Class = "npc_citizen",
	Category = "BonziWORLD",
	Model = "models/bonzi/bonzibuddy.mdl",
	Weapons = { "none" },
	KeyValues = { SquadName = "bonzis", targetname = "npc_bonzi" }
}, "Bonzi" )

AddNPC( {
	Name = "Random Bonzi",
	Class = "npc_citizen",
	Category = "BonziWORLD",
	Model = "models/bonzi/bonzibuddy.mdl",
	Weapons = { "none" },
	KeyValues = { SquadName = "bonzis", targetname = "npc_bonzi_random" }
}, "RandomBonzi" )

AddNPC( {
	Name = "Hostile Bonzi",
	Class = "npc_combine_s",
	Category = "BonziWORLD",
	Model = "models/bonzi/bonzibuddy.mdl",
	Weapons = { "weapon_pistol" },
	KeyValues = { SquadName = "kiddies", targetname = "npc_bonzi_bad" }
}, "BadBonzi" )

AddNPC( {
	Name = "BonziPOPE",
	Class = "npc_citizen",
	Category = "BonziWORLD",
	Model = "models/bonzi/bonzibuddy.mdl",
	Health = 200,
	Weapons = { "weapon_stunstick" },
	KeyValues = { SquadName = "bonzis", targetname = "npc_bonzi_pope" },
	AdminOnly = true,
}, "BonziPope" )

AddNPC( {
	Name = "Kiddie",
	Class = "npc_metropolice",
	Category = "BonziWORLD",
	Model = "models/bonzi/bonzibuddy.mdl",
	Weapons = { "weapon_crowbar" },
	KeyValues = { SquadName = "kiddies", modelscale = 0.75, targetname = "npc_bonzi_kiddie" }
}, "KiddieBonzi" )

local function CanSpawn(ply) if !ply:IsAdmin() then return false end return true end
function GM:PlayerSpawnSWEP(ply)
	return CanSpawn(ply)
end

function GM:PlayerGiveSWEP(ply)
	return CanSpawn(ply)
end


function GM:PlayerSpawnVehicle(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnNPC(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnSENT(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnObject(ply)
	return CanSpawn(ply)
end

hook.Add("TranslateActivity","BonziActivity",function( ply, act )
    BonziActivityTranslate[ACT_HL2MP_WALK] = ACT_WALK 
    if (ply:GetModel() != "models/bonzi/bonzibuddy.mdl" and !GetConVar("bonziworld_enableotherpms"):GetBool()) then
        ply:SetModel("models/bonzi/bonzibuddy.mdl")
    end
    if (ply:GetInfo("bonziworld_bonzicolor") == "purple") then
	    ply:SetColor( Color( 255, 255, 255, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "red") then
	    ply:SetColor( Color( 255, 0, 0, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "green") then
	    ply:SetColor( Color( 0, 255, 0, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "cyan") then
	    ply:SetColor( Color( 0, 250, 255, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "blue") then
	    ply:SetColor( Color( 0, 0, 255, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "black") then
	    ply:SetColor( Color( 20, 20, 20, 255 ) )
    elseif (ply:GetInfo("bonziworld_bonzicolor") == "brown") then
	    ply:SetColor( Color( 255, 161, 0, 255 ) )
    else
        ply:SetColor( Color( 255, 255, 255, 255 ) )
    end
    
    ply:SetNWString("bonzicolor",ply:GetInfo("bonziworld_bonzicolor"))
    ply:SetNWString("bonzivoice",ply:GetInfo("bonziworld_bonzivoice"))
	
	if (ply:GetInfo("bonziworld_bonzipitch") == "random") then
		if (!ply.IsRandomizedP) then
			ply.IsRandomizedP = true
			ply:SetNWInt("bonzipitch",math.random(15,125))
		end
	else
		ply:SetNWInt("bonzipitch",ply:GetInfo("bonziworld_bonzipitch"))
	end
	if (ply:GetInfo("bonziworld_bonzipitch") == "random") then
		if (!ply.IsRandomizedS) then
			ply.IsRandomizedS = true
			ply:SetNWInt("bonzispeed",math.random(125,275))
		end
	else
		ply:SetNWInt("bonzispeed",ply:GetInfo("bonziworld_bonzispeed"))
	end
    return BonziActivityTranslate[act] or act
end)
function GM:PlayerSetModel( ply )
    ply:SetModel("models/bonzi/bonzibuddy.mdl")
	ply:GetHands():SetModel("models/weapons/v_hands.mdl")
end