
AddCSLuaFile()

SWEP.PrintName = "Ban Baton"

SWEP.Slot = 0
SWEP.SlotPos = 4
 
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModel = Model( "models/weapons/c_stunstick.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.HoldType = "melee"
SWEP.HitDistance = 48

local SwingSound = Sound( "Weapon_StunStick.Melee_Miss" )
local HitSound = Sound( "Weapon_StunStick.Melee_Hit" )

function SWEP:Initialize()

	self:SetHoldType( "melee" )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	if (self.Owner:IsPlayer()) then
		local vm = self.Owner:GetViewModel()
		self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )
	end

end

function SWEP:PrimaryAttack( right )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = "attackcm"
	if ( right ) then anim = "attackcm" end
	if ( math.random(1,2) == 1 ) then
		anim = "attackch"
	end
	local vm
	if (self.Owner:IsPlayer()) then
		vm = self.Owner:GetViewModel()
	end
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	if (tr.Hit) then
		self.Owner:EmitSound( SwingSound )
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		self:SetNextPrimaryFire( CurTime() + 0.25 )
		self:SetNextSecondaryFire( CurTime() + 0.25 )
		self:SetNextMeleeAttack( CurTime() + 0.1 )
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
		effectdata:SetNormal( tr.HitNormal )
		util.Effect( "MetalSpark", effectdata )
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Owner:EmitSound( SwingSound )
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )
		self:SetNextMeleeAttack( CurTime() + 0.2 )
	end


	self:UpdateNextIdle()

end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self.Owner:EmitSound( HitSound )
	end

	local ply = tr.Entity
	if SERVER then
		if (IsValid(ply)) then
			
			local dissolver = ents.Create( "env_entity_dissolver" )
			dissolver:SetPos( ply:GetPos() )
			dissolver:Spawn()
			dissolver:Activate()
			dissolver:SetOwner(self.Owner)
			dissolver:SetKeyValue( "magnitude", 100 )
			dissolver:SetKeyValue( "dissolvetype", 2 )
			ply:SetName("banned_user_"..ply:EntIndex())
			dissolver:Fire("dissolve","banned_user_"..ply:EntIndex(),0)
			ply:EmitSound("ambient/explosions/explode_"..math.random(1,5)..".wav",95)
			util.ScreenShake( ply:GetPos(), 500, 500, 2, 5000 )
			ply:EmitSound("ambient/atmosphere/thunder"..math.random(1,4)..".wav",150,100)
			ply:EmitSound("ambient/explosions/exp"..math.random(1,4)..".wav",110,100)
		end
	end
	local hit = false
	local scale = phys_pushscale:GetFloat()
	if (tr.Entity:IsPlayer() and !tr.Entity:IsAdmin()) then
		if SERVER then
			PrintMessage(HUD_PRINTTALK,ply:Nick().." has been banned by ".. self.Owner:Nick().. "!")
			local ragdoll = ents.Create("prop_ragdoll")
			ragdoll:SetPos(ply:GetPos())
			ragdoll:SetAngles(ply:GetAngles())
			ragdoll:SetModel(ply:GetModel())
			ragdoll:Spawn()
			ragdoll:Activate()
			ragdoll:GetPhysicsObject():SetVelocity(tr.HitNormal * 1000)
			local dissolver = ents.Create( "env_entity_dissolver" )
			dissolver:SetPos( ragdoll:GetPos() )
			dissolver:Spawn()
			dissolver:Activate()
			dissolver:SetKeyValue( "magnitude", 100 )
			dissolver:SetKeyValue( "dissolvetype", 2 )
			ragdoll:SetName("banned_user_"..ragdoll:EntIndex())
			dissolver:Fire("dissolve","banned_user_"..ragdoll:EntIndex(),0)
			timer.Simple(5, function()
				dissolver:Remove()
			end)
			if (ply:IsBot()) then
				ply:Kick("Banned by the BonziPOPE!")
			else
				ply:Ban(1440, true)
			end
		end
	end
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( 100,500 ) )
		dmginfo:SetDamageType(DMG_DISSOLVE)

			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 * scale + self.Owner:GetForward() * 9989 * scale * 3000 )

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( self.Owner )

		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80000 * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function SWEP:Deploy()
	local vm
	if (self.Owner:IsPlayer()) then
		vm = self.Owner:GetViewModel()
	end
	self:SendWeaponAnim(ACT_VM_DRAW)
	if (self.Owner:IsPlayer()) then
		vm:SetPlaybackRate( 1 )
	end
	self:EmitSound("Weapon_StunStick.Activate")
	if (self.Owner:IsPlayer()) then
		self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() )
		self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() )
	end
	self:UpdateNextIdle()

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetNormal( self:GetPos():GetNormalized() )
	--local effectdata2 = EffectData()
	--effectdata2:SetOrigin( self.Owner:GetViewModel():GetPos() )
	--effectdata2:SetNormal( self.Owner:GetViewModel():GetPos():GetNormalized() )
	util.Effect( "MetalSpark", effectdata )
	--util.Effect( "MetalSpark", effectdata2 )
	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	return true

end

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )

	self:EmitSound("Weapon_StunStick.Deactivate")
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetNormal( self:GetPos():GetNormalized() )
	--local effectdata2 = EffectData()
	--effectdata2:SetOrigin( self.Owner:GetViewModel():GetPos() )
	--effectdata2:SetNormal( self.Owner:GetViewModel():GetPos():GetNormalized() )
	util.Effect( "MetalSpark", effectdata )
	--util.Effect( "MetalSpark", effectdata2 )
	return true

end

function SWEP:Think()

	self:SetHoldType( "melee" )
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		self:SendWeaponAnim(ACT_VM_IDLE)

		self:UpdateNextIdle()

	end

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end

	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then

		self:SetCombo( 0 )

	end

end
