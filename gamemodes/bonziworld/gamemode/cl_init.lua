include( "shared.lua" ) 
include( "player_class/bonzibuddy.lua" )

CreateConVar( "bonziworld_bonzicolor", "purple", FCVAR_USERINFO, "Your Bonzi color. Must be a existing one." )
CreateConVar( "bonziworld_bonzivoice", "Kidaroo", FCVAR_USERINFO, "Your Bonzi voice. Must be a existing one." )
CreateConVar( "bonziworld_bonzipitch", "random", FCVAR_USERINFO, "Your Bonzi pitch. Must be a number." )
CreateConVar( "bonziworld_bonzispeed", "random", FCVAR_USERINFO, "Your Bonzi speed. Must be a number." )
-- if people keep uploading reskins of sanic, guess i'll have to use the 2D sprite code from sanic then
local MAT_SANIC = Material("bonzis/purple")
hook.Add( "PostDrawTranslucentRenderables", "BonziWORLD2d", function( bDepth, bSkybox )
	
	for _,self in ipairs(player.GetAll()) do
		
		if (GetConVar("bonziworld_2donly"):GetBool() && self != LocalPlayer() && self:Health() > 0 && self:GetNoDraw() != true) then
			local SPRITE_SIZE = 64 * self:GetModelScale()
			local DRAW_OFFSET = SPRITE_SIZE / 2 * vector_up	
			if (self:IsAdmin()) then
			
				render.SetMaterial(Material("bonzis/pope"))	
				
			else
				if (self:GetColor() == Color( 255, 0, 0, 0 )) then
				
					render.SetMaterial(Material("bonzis/red"))	
					
				elseif (self:GetColor() == Color( 0, 255, 0, 0 )) then
				
					render.SetMaterial(Material("bonzis/green"))	
					
				elseif (self:GetColor() == Color( 0, 250, 255, 0 )) then
				
					render.SetMaterial(Material("bonzis/cyan"))	
					
				elseif (self:GetColor() == Color( 0, 0, 255, 0 )) then
				
					render.SetMaterial(Material("bonzis/blue"))	
					
				elseif (self:GetColor() == Color( 20, 20, 20, 0 )) then
				
					render.SetMaterial(Material("bonzis/black"))	
					
				elseif (self:GetColor() == Color( 255, 161, 0, 0 )) then
				
					render.SetMaterial(Material("bonzis/brown"))	
					
				elseif (self:GetColor() == Color( 255, 20, 147, 0 )) then
				
					render.SetMaterial(Material("bonzis/pink"))	
					
				else
				
					render.SetMaterial(Material("bonzis/purple"))	
					
				end
			end

			-- Get the normal vector from Sanic to the player's eyes, and then compute
			-- a corresponding projection onto the xy-plane.
			local pos = self:GetPos() + DRAW_OFFSET
			local normal = EyePos() - pos
			normal:Normalize()
			local xyNormal = Vector(normal.x, normal.y, 0)
			xyNormal:Normalize()

			-- Sanic should only look 1/3 of the way up to the player so that they
			-- don't appear to lay flat from above.
			local pitch = math.acos(math.Clamp(normal:Dot(xyNormal), -1, 1)) / 3
			local cos = math.cos(pitch)
			normal = Vector(
				xyNormal.x * cos,
				xyNormal.y * cos,
				math.sin(pitch)
			)

			render.DrawQuadEasy(pos, normal, SPRITE_SIZE, SPRITE_SIZE,
				color_white, 180)
			self:SetColor(Color(self:GetColor().r,self:GetColor().g,self:GetColor().b,0))
		elseif (GetConVar("bonziworld_2donly"):GetBool() && self == LocalPlayer() && self:Health() > 0 && self:GetNoDraw() != true) then
				local SPRITE_SIZE = 64 * self:GetModelScale()
				local DRAW_OFFSET = SPRITE_SIZE / 2 * vector_up	
				if (self:IsAdmin()) then
				
					render.SetMaterial(Material("bonzis/pope"))	
					
				else
					if (self:GetColor() == Color( 255, 0, 0, 0 )) then
					
						render.SetMaterial(Material("bonzis/red"))	
						
					elseif (self:GetColor() == Color( 0, 255, 0, 0 )) then
					
						render.SetMaterial(Material("bonzis/green"))	
						
					elseif (self:GetColor() == Color( 0, 250, 255, 0 )) then
					
						render.SetMaterial(Material("bonzis/cyan"))	
						
					elseif (self:GetColor() == Color( 0, 0, 255, 0 )) then
					
						render.SetMaterial(Material("bonzis/blue"))	
						
					elseif (self:GetColor() == Color( 20, 20, 20, 0 )) then
					
						render.SetMaterial(Material("bonzis/black"))	
						
					elseif (self:GetColor() == Color( 255, 161, 0, 0 )) then
					
						render.SetMaterial(Material("bonzis/brown"))	
						
					elseif (self:GetColor() == Color( 255, 20, 147, 0 )) then
					
						render.SetMaterial(Material("bonzis/pink"))	
						
					else
					
						render.SetMaterial(Material("bonzis/purple"))	
						
					end
				end
	
				-- Get the normal vector from Sanic to the player's eyes, and then compute
				-- a corresponding projection onto the xy-plane.
				local pos = self:GetPos() + DRAW_OFFSET
				local normal = self:EyeAngles():Forward()
				normal:Normalize()
				local xyNormal = Vector(normal.x, normal.y, 0)
				xyNormal:Normalize()
	
				-- Sanic should only look 1/3 of the way up to the player so that they
				-- don't appear to lay flat from above.
				local pitch = math.acos(math.Clamp(normal:Dot(xyNormal), -1, 1)) / 3
				local cos = math.cos(pitch)
				normal = Vector(
					xyNormal.x * cos,
					xyNormal.y * cos,
					math.sin(self:EyeAngles():Forward().z * cos)
				)
	
				render.DrawQuadEasy(pos, normal, SPRITE_SIZE, SPRITE_SIZE,
					color_white, 180)
				render.DrawQuadEasy(pos, -normal, SPRITE_SIZE, SPRITE_SIZE,
					color_white, 180)
				self:SetColor(Color(self:GetColor().r,self:GetColor().g,self:GetColor().b,0))
			else
			if (self:GetColor() == Color(255,255,255,0)) then
				self:SetColor(Color(255,255,255,255))
			end
		end
	end
	for _,self in ipairs(ents.GetAll()) do
		  
		if (GetConVar("bonziworld_2donly"):GetBool() and self:IsNPC() and self:Health() > 0 and self:GetNoDraw() != true and self:GetModel() == "models/bonzi/bonzibuddy.mdl") then
			local SPRITE_SIZE = 64 * self:GetModelScale()
			local DRAW_OFFSET = SPRITE_SIZE / 2 * vector_up
			if (self:GetColor() == Color( 100, 100, 100, 0 )) then
			
				render.SetMaterial(Material("bonzis/pope"))	
				
			elseif (self:GetColor() == Color( 255, 0, 0, 0 )) then
				
					render.SetMaterial(Material("bonzis/red"))	
					
				elseif (self:GetColor() == Color( 0, 255, 0, 0 )) then
				
					render.SetMaterial(Material("bonzis/green"))	
					
				elseif (self:GetColor() == Color( 0, 250, 255, 0 )) then
				
					render.SetMaterial(Material("bonzis/cyan"))	
					
				elseif (self:GetColor() == Color( 0, 0, 255, 0 )) then
				
					render.SetMaterial(Material("bonzis/blue"))	
					
				elseif (self:GetColor() == Color( 20, 20, 20, 0 )) then
				
					render.SetMaterial(Material("bonzis/black"))	
					
				elseif (self:GetColor() == Color( 255, 161, 0, 0 )) then
				
					render.SetMaterial(Material("bonzis/brown"))	
					
				elseif (self:GetColor() == Color( 255, 20, 147, 0 )) then
				
					render.SetMaterial(Material("bonzis/pink"))	
					
				else
				
					render.SetMaterial(Material("bonzis/purple"))	
					
				end

			-- Get the normal vector from Sanic to the player's eyes, and then compute
			-- a corresponding projection onto the xy-plane.
			local pos = self:GetPos() + DRAW_OFFSET
			local normal = self:GetAimVector() - pos
			normal:Normalize()
			local xyNormal = Vector(normal.x, normal.y, 0)
			xyNormal:Normalize()

			-- Sanic should only look 1/3 of the way up to the player so that they
			-- don't appear to lay flat from above.
			local pitch = math.acos(math.Clamp(normal:Dot(xyNormal), -1, 1)) / 3
			local cos = math.cos(pitch)
			normal = Vector(
				xyNormal.x * cos,
				xyNormal.y * cos,
				math.sin(pitch)
			)

			render.DrawQuadEasy(pos, normal, SPRITE_SIZE, SPRITE_SIZE,
				color_white, 180)
			self:SetRenderMode(RENDERMODE_TRANSCOLOR)
			self:SetColor(Color(self:GetColor().r,self:GetColor().g,self:GetColor().b,0))
		elseif (self:IsNPC() and self:Health() > 0 and self:GetNoDraw() != true and self:GetModel() == "models/bonzi/bonzibuddy.mdl") then
			if (self:GetColor() == Color(255,255,255,0)) then
				self:SetColor(Color(255,255,255,255))
			end
		end
	end
end)

local dectalk = GetConVar("bonziworld_alternatetts")
-- deprecated, but updated to use mespeak
net.Receive( "BonziSpeak",  function()
    local text = net.ReadString()
    local ply = net.ReadEntity()
	text = string.Replace( text, "%", "")
    text = string.Replace( text, " ", "%20" )
	text = string.Replace( text, "[", "%5B")
	text = string.Replace( text, "]", "%5D")
	ply.sound2 = sound.PlayURL( "https://mespeak-engine.daisreich.repl.co/?pitch="..ply:GetNWInt("bonzipitch").."&speed="..ply:GetNWInt("bonzispeed").."&guid=poo&text="..text, "3d", function( sound,err,errorName )
		if (err && errorName) then
			print("ERROR ERROR ERROR!: "..err..", "..errorName)
		end
		if IsValid( sound ) then
			ply.sound = sound
			print(sound:GetLevel())
			sound:SetPos( ply:GetPos() )
			sound:SetVolume( 1 ) 
			sound:Play()
			sound:Set3DFadeDistance( 3000, 8000 )
		end
	end )	
end )
net.Receive( "BonziSpeak2",  function()
    local text = net.ReadString()
    local ply = net.ReadEntity()
    text = string.Replace( text, " ", "%20" )
	text = string.Replace( text, "[", "%5B")
	text = string.Replace( text, "]", "%5D")
	ply.sound2 = sound.PlayURL( "https://mespeak-engine.daisreich.repl.co/?pitch="..ply:GetNWInt("bonzipitch").."&speed="..ply:GetNWInt("bonzispeed").."&guid=poo&text="..text, "3d", function( sound,err,errorName )
		if (err && errorName) then
			print("ERROR ERROR ERROR!: "..err..", "..errorName)
		end
		if IsValid( sound ) then
			ply.sound = sound
			print(sound:GetLevel())
			sound:SetPos( ply:GetPos() )
			sound:SetVolume( 1 ) 
			sound:Play()
			sound:SetPlaybackRate(ply:GetNWInt("bonzipitch") * 0.008 + 0.5)
			sound:Set3DFadeDistance( 3000, 8000 )
		end
	end )
end )
net.Receive( "BonziSpeakAlt",  function()
    local text = net.ReadString()
    local ply = net.ReadEntity()
    text = string.Replace( text, " ", "%20" )
	text = string.Replace( text, "[", "%5B")
	text = string.Replace( text, "]", "%5D")
	ply.sound2 = sound.PlayURL( "https://mespeak-engine.daisreich.repl.co/?pitch="..ply:GetNWInt("bonzipitch").."&speed="..ply:GetNWInt("bonzispeed").."&guid=poo&text="..text, "3d", function( sound,err,errorName )
		if (err && errorName) then
			print("ERROR ERROR ERROR!: "..err..", "..errorName)
		end
		if IsValid( sound ) then
			ply.sound = sound
			print(sound:GetLevel())
			sound:SetPos( ply:GetPos() )
			sound:SetVolume( 1 ) 
			sound:Play()
			sound:Set3DFadeDistance( 3000, 8000 )
		end
	end )
end )

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


local Tags = 
{
--Group    --Tag     --Color
{"admin", "[ADMIN] ", Color(0, 0, 255, 255) },
{"superadmin", "[SUPERADMIN] ", Color(255, 0, 0, 255) },
{"owner", "[OWNER] ", Color(0, 255, 0, 255) }
}

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
		side = "harmless",
		type = "ply",
		parent = "antlion",
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
		driveOptions = {
			speed = 5000
		},
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
hook.Add("OnPlayerChat", "BonziPope", function(ply, strText, bTeamOnly)
		
	if IsValid(ply) and ply:IsPlayer() then
		local lowertext = string.lower( strText ) -- make the string lower case
	
		if ( lowertext == "/joke" ) then -- if the player typed /joke then
			return true -- this suppresses the message from being shown
		end
		if ( lowertext == "/pitch" ) then -- if the player typed /joke then
			return true -- this suppresses the message from being shown
		end
		if ( lowertext == "/speed" ) then -- if the player typed /joke then
			return true -- this suppresses the message from being shown
		end
		if ( lowertext == "/fact" ) then -- if the player typed /fact then
			return true -- this suppresses the message from being shown
		end
		if ( lowertext == "/pawn" ) then -- if the player typed /pawn then
			return true -- this suppresses the message from being shown
		end
		if ( lowertext.StartWith(lowertext,"/color") ) then
			if ( ply == LocalPlayer() ) then
				if (lowertext.StartWith(lowertext,"/color ")) then
					local color = lowertext.Replace(lowertext,"/color ")
					RunConsoleCommand("bonziworld_bonzicolor",color)
				end
			end
			return true
		end
		if ( lowertext.StartWith(lowertext,"/pitch") ) then
			if ( ply == LocalPlayer() ) then
				if (lowertext.StartWith(lowertext,"/pitch ")) then
					local color = lowertext.Replace(lowertext,"/pitch ")
						RunConsoleCommand("bonziworld_bonzipitch",color)
				end
			end
			return true
		end
		if ( lowertext.StartWith(lowertext,"/speed") ) then
			if ( ply == LocalPlayer() ) then
				if (lowertext.StartWith(lowertext,"/speed ")) then
					local color = lowertext.Replace(lowertext,"/speed ")
						RunConsoleCommand("bonziworld_bonzispeed",color)
				end
			end
			return true
		end
		if ( lowertext.StartWith(lowertext,"/voice") ) then
			if ( ply == LocalPlayer() ) then
				if (lowertext.StartWith(lowertext,"/voice ")) then
					local color = strText.Replace(strText,"/voice ")
					RunConsoleCommand("bonziworld_bonzivoice",color)
				end
			end
			return true
		end
		for k,v in pairs(Tags) do
				local R = GetConVarNumber("chat_color_r")
				local G = GetConVarNumber("chat_color_g")
				local B = GetConVarNumber("chat_color_b")
				local A = GetConVarNumber("chat_color_a")
				local Colour = team.GetColor(ply:Team()) or Color(255,255,255)
                local bonziworld_bonzicolor = Color( 255, 255, 255, 255 )
                if (ply:GetNWString("bonzicolor") == "purple") then
                    bonziworld_bonzicolor =  Color( 255, 0, 255, 255 )
                elseif (ply:GetNWString("bonzicolor") == "red") then
                    bonziworld_bonzicolor =  Color( 255, 0, 0, 255 )
                elseif (ply:GetNWString("bonzicolor") == "green") then
                    bonziworld_bonzicolor =  Color( 0, 255, 0, 255 )
                elseif (ply:GetNWString("bonzicolor") == "cyan") then
                    bonziworld_bonzicolor =  Color( 0, 250, 255, 255 )
                elseif (ply:GetNWString("bonzicolor") == "blue") then
                    bonziworld_bonzicolor =  Color( 0, 0, 255, 255 )
                elseif (ply:GetNWString("bonzicolor") == "black") then
                    bonziworld_bonzicolor =  Color( 20, 20, 20, 255 )
                elseif (ply:GetNWString("bonzicolor") == "brown") then
                    bonziworld_bonzicolor =  Color( 255, 161, 0, 255 )
                else
                    bonziworld_bonzicolor =  Color( 255, 0, 255, 255 )
                end
				if !ply:IsAdmin() then
					if !bTeamOnly then
						chat.AddText(v[3], color_white,"", bonziworld_bonzicolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					else
						chat.AddText(v[3], color_white,"", "(TEAM) ", bonziworld_bonzicolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					end
				else
					if !bTeamOnly then
						chat.AddText(v[3], color_white,"(POPE) ", bonziworld_bonzicolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					else
						chat.AddText(v[3], color_white,"(POPE) ", "(TEAM) ", bonziworld_bonzicolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), strText)
						return true
					end
				end
		end
	end
	if !IsValid(ply) and !ply:IsPlayer() then
		local ConsoleColor = Color(0, 255, 0) --Change this to change Console name color
		chat.AddText(ConsoleColor, "Console", color_white, ": ", strText)
		return true
	end
end )
