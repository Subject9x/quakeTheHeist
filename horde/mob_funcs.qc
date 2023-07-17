



void() precache_mobs={
	precache_model2 ("progs/fish.mdl");
	precache_sound2 ("fish/death.wav");
	precache_sound2 ("fish/bite.wav");
	precache_sound2 ("fish/idle.wav");
	

	precache_model("progs/h_dog.mdl");
	precache_model("progs/dog.mdl");
	precache_sound("dog/dattack1.wav");
	precache_sound("dog/ddeath.wav");
	precache_sound("dog/dpain1.wav");
	precache_sound("dog/dsight.wav");
	precache_sound("dog/idle.wav");

	precache_model("progs/zombie.mdl");
	precache_model("progs/h_zombie.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");

	precache_model("progs/soldier.mdl");
	precache_model("progs/h_guard.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("soldier/death1.wav");
	precache_sound("soldier/idle.wav");
	precache_sound("soldier/pain1.wav");
	precache_sound("soldier/pain2.wav");
	precache_sound("soldier/sattck1.wav");
	precache_sound("soldier/sight1.wav");
	precache_sound("player/udeath.wav"); // gib death

	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");

	precache_model("progs/wizard.mdl");
	precache_model("progs/h_wizard.mdl");
	precache_model("progs/w_spike.mdl");
	precache_sound("wizard/hit.wav"); // used by c code
	precache_sound("wizard/wattack.wav");
	precache_sound("wizard/wdeath.wav");
	precache_sound("wizard/widle1.wav");
	precache_sound("wizard/widle2.wav");
	precache_sound("wizard/wpain.wav");
	precache_sound("wizard/wsight.wav");

	precache_model("progs/ogre.mdl");
	precache_model("progs/h_ogre.mdl");
	precache_model("progs/grenade.mdl");
	precache_sound("ogre/ogdrag.wav");
	precache_sound("ogre/ogdth.wav");
	precache_sound("ogre/ogidle.wav");
	precache_sound("ogre/ogidle2.wav");
	precache_sound("ogre/ogpain1.wav");
	precache_sound("ogre/ogsawatk.wav");
	precache_sound("ogre/ogwake.wav");

	precache_model("progs/knight.mdl");
	precache_model("progs/h_knight.mdl");
	precache_sound("knight/kdeath.wav");
	precache_sound("knight/khurt.wav");
	precache_sound("knight/ksight.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("knight/idle.wav");

	precache_model("progs/demon.mdl");
	precache_model("progs/h_demon.mdl");
	precache_sound("demon/ddeath.wav");
	precache_sound("demon/dhit2.wav");
	precache_sound("demon/djump.wav");
	precache_sound("demon/dpain1.wav");
	precache_sound("demon/idle1.wav");
	precache_sound("demon/sight2.wav");
	
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");
	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound("hknight/hit.wav"); // used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");

	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");

	precache_model("progs/shambler.mdl");
	precache_model("progs/s_light.mdl");
	precache_model("progs/h_shams.mdl");
	precache_model("progs/bolt.mdl");
	precache_sound("shambler/sattck1.wav");
	precache_sound("shambler/sboom.wav");
	precache_sound("shambler/sdeath.wav");
	precache_sound("shambler/shurt2.wav");
	precache_sound("shambler/sidle.wav");
	precache_sound("shambler/ssight.wav");
	precache_sound("shambler/melee1.wav");
	precache_sound("shambler/melee2.wav");
	precache_sound("shambler/smack.wav");

	precache_model2 ("progs/tarbaby.mdl");
	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
};

float() mob_spawn_next={
	local float id;
	local float rand;
	local float shift;

	id = -1;
	rand = 1;

	if((self.spawnflags & SPAWNFLAG_HORDE_GRP_ORD_RAND))
	{
		while(!(rand & self.wave_mobs)){
			shift = fabs(rint(ceil(13)));
			while(rand < shift+1){
				rand = rand * 2;
			}
		}
		id = rand;
	}

	if((self.spawnflags & SPAWNFLAG_HORDE_GRP_ORD_SIZE))
	{
		M_mob_decrement(id, self.mob_fish, MOB_ID_FISH)
		M_mob_decrement(id, self.mob_dog, MOB_ID_DOG)
		M_mob_decrement(id, self.mob_zombie, MOB_ID_ZMBIE)
		M_mob_decrement(id, self.mob_army, MOB_ID_ARMY)
		M_mob_decrement(id, self.mob_enforcer, MOB_ID_ENFRCE)
		M_mob_decrement(id, self.mob_knight, MOB_ID_KNIGHT)
		M_mob_decrement(id, self.mob_ogre, MOB_ID_OGRE)
		M_mob_decrement(id, self.mob_fiend, MOB_ID_FIEND)
		M_mob_decrement(id, self.mob_hellknight, MOB_ID_HKNIGHT)
		M_mob_decrement(id, self.mob_wizard, MOB_ID_WIZRD)
		M_mob_decrement(id, self.mob_vore, MOB_ID_VORE)
		M_mob_decrement(id, self.mob_shambler, MOB_ID_SHMBL)
		M_mob_decrement(id, self.mob_tarbb, MOB_ID_TARBB)
	}

	if((self.spawnflags & SPAWNFLAG_HORDE_GRP_ORD_RVSIZE))
	{
		M_mob_decrement(id, self.mob_tarbb, MOB_ID_TARBB)
		M_mob_decrement(id, self.mob_shambler, MOB_ID_SHMBL)
		M_mob_decrement(id, self.mob_vore, MOB_ID_VORE)
		M_mob_decrement(id, self.mob_hellknight, MOB_ID_HKNIGHT)
		M_mob_decrement(id, self.mob_fiend, MOB_ID_FIEND)
		M_mob_decrement(id, self.mob_ogre, MOB_ID_OGRE)
		M_mob_decrement(id, self.mob_wizard, MOB_ID_WIZRD)
		M_mob_decrement(id, self.mob_knight, MOB_ID_KNIGHT)
		M_mob_decrement(id, self.mob_enforcer, MOB_ID_ENFRCE)
		M_mob_decrement(id, self.mob_army, MOB_ID_ARMY)
		M_mob_decrement(id, self.mob_zombie, MOB_ID_ZMBIE)
		M_mob_decrement(id, self.mob_dog, MOB_ID_DOG)
		M_mob_decrement(id, self.mob_fish, MOB_ID_FISH)
	}

	return id;
};

entity(float mobId) mob_generate={

	local entity mob;
	local entity this;

	mob = spawn();

	if(!mob)
		return world;

	this = self;
	self = mob;
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags | FL_MONSTER;
	self.takedamage = DAMAGE_AIM;
	self.isHordeMob = TRUE;
	
	if(mobId == MOB_ID_FISH)
	{
		self.classname = "monster_fish";
		self.flags = self.flags | FL_SWIM;

		setmodel(self, "progs/fish.mdl");

		setsize(self, '-16 -16 -24', '16 16 24');
		self.health = 25;
		self.health_max = self.health;
	
		self.th_stand = f_stand1;
		self.th_walk = f_walk1;
		self.th_run = f_run1;
		self.th_die = f_death1;
		self.th_pain = fish_pain;
		self.th_melee = f_attack1;	
	}

	if(mobId == MOB_ID_DOG)
	{
		self.classname = "monster_dog";
		setmodel(self, "progs/dog.mdl");

		setsize(self, '-32 -32 -24', '32 32 40');
		self.health = 25;
		self.health_max = self.health;
	
		self.th_stand = dog_stand1;
		self.th_walk = dog_walk1;
		self.th_run = dog_run1;
		self.th_pain = dog_pain;
		self.th_die = dog_die;
		self.th_melee = dog_atta1;
		self.th_missile = dog_leap1;
	}

	if(mobId == MOB_ID_ZMBIE)
	{
		self.classname = "monster_zombie";
		setmodel(self, "progs/zombie.mdl");
	
		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 60;
		self.health_max = self.health;
	
		self.th_stand = zombie_stand1;
		self.th_walk = zombie_walk1;
		self.th_run = zombie_run1;
		self.th_pain = zombie_pain;
		self.th_die = zombie_die;
		self.th_missile = zombie_missile;
	}

	if(mobId == MOB_ID_ARMY)
	{
		self.classname = "monster_army";
		setmodel(self, "progs/soldier.mdl");

		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 30;
		self.health_max = self.health;

		self.th_stand = army_stand1;
		self.th_walk = army_walk1;
		self.th_run = army_run1;
		self.th_missile = army_atk1;
		self.th_pain = army_pain;
		self.th_die = army_die;
	}

	if(mobId == MOB_ID_KNIGHT)
	{
		self.classname = "monster_knight";
		setmodel(self, "progs/knight.mdl");

		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 75;
		self.health_max = self.health;
	
		self.th_stand = knight_stand1;
		self.th_walk = knight_walk1;
		self.th_run = knight_run1;
		self.th_melee = knight_atk1;
		self.th_pain = knight_pain;
		self.th_die = knight_die;	
	}

	if(mobId == MOB_ID_ENFRCE)
	{
		self.classname = "monster_enforcer";
		setmodel(self, "progs/enforcer.mdl");

		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 80;
		self.health_max = self.health;
		
		self.th_stand = enf_stand1;
		self.th_walk = enf_walk1;
		self.th_run = enf_run1;
		self.th_pain = enf_pain;
		self.th_die = enf_die;
		self.th_missile = enf_atk1;
	}

	if(mobId == MOB_ID_OGRE)
	{
		self.classname = "monster_ogre";
		setmodel(self, "progs/ogre.mdl");

		setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.health = 200;
		self.health_max = self.health;
	
		self.th_stand = ogre_stand1;
		self.th_walk = ogre_walk1;
		self.th_run = ogre_run1;
		self.th_die = ogre_die;
		self.th_melee = ogre_melee;
		self.th_missile = ogre_nail1;
		self.th_pain = ogre_pain;
	}

	if(mobId == MOB_ID_HKNIGHT)
	{
		self.classname = "monster_hell_knight";
		setmodel(self, "progs/hknight.mdl");

		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 250;
		self.health_max = self.health;
	
		self.th_stand = hknight_stand1;
		self.th_walk = hknight_walk1;
		self.th_run = hknight_run1;
		self.th_melee = hknight_melee;
		self.th_missile = hknight_magicc1;
		self.th_pain = hknight_pain;
		self.th_die = hknight_die;	
	}

	if(mobId == MOB_ID_WIZRD)
	{
		self.classname = "monster_wizard";
		self.flags = self.flags | FL_FLY;

		setmodel(self, "progs/wizard.mdl");
	
		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 80;
		self.health_max = self.health;
	
		self.th_stand = wiz_stand1;
		self.th_walk = wiz_walk1;
		self.th_run = wiz_run1;
		self.th_missile = Wiz_Missile;
		self.th_pain = Wiz_Pain;
		self.th_die = wiz_die;	
	}

	if(mobId == MOB_ID_FIEND)
	{
		self.classname = "monster_demon1";
		setmodel(self, "progs/demon.mdl");
	
		setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.health = 300;
		self.health_max = self.health;
	
		self.th_stand = demon1_stand1;
		self.th_walk = demon1_walk1;
		self.th_run = demon1_run1;
		self.th_die = demon_die;
		self.th_melee = Demon_MeleeAttack; // one of two attacks
		self.th_missile = demon1_jump1; // jump attack
		self.th_pain = demon1_pain;
	}

	if(mobId == MOB_ID_VORE)
	{
		self.classname = "monster_shalrath";
		setmodel(self, "progs/shalrath.mdl");
		setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);

		self.health = 400;
		self.health_max = self.health;
	
		self.th_stand = shal_stand;
		self.th_walk = shal_walk1;
		self.th_run = shal_run1;
		self.th_die = shalrath_die;
		self.th_pain = shalrath_pain;
		self.th_missile = shal_attack1;
	}

	if(mobId == MOB_ID_SHMBL)
	{
		self.classname = "monster_shambler";
		setmodel(self, "progs/shambler.mdl");

		setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.health = 600;
		self.health_max = self.health;
	
		self.th_stand = sham_stand1;
		self.th_walk = sham_walk1;
		self.th_run = sham_run1;
		self.th_die = sham_die;
		self.th_melee = sham_melee;
		self.th_missile = sham_magic1;
		self.th_pain = sham_pain;
	}

	if(mobId == MOB_ID_TARBB)
	{
		self.classname = "monster_tarbaby";
		setmodel(self, "progs/tarbaby.mdl");

		setsize(self, '-16 -16 -24', '16 16 40');
		self.health = 80;
		self.health_max = self.health;

		self.th_stand = tbaby_stand1;
		self.th_walk = tbaby_walk1;
		self.th_run = tbaby_run1;
		self.th_missile = tbaby_jump1;
		self.th_melee = tbaby_jump1;
		self.th_die = tbaby_die1;
	}

	self = this;

	return mob;
};

void() wavemonster_start={
	self.origin_z = self.origin_z + 1; // raise off floor a bit
	droptofloor();

	if (!walkmove(0,0))
	{
		dprint("walkmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}


	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';

};

void() wavemonster_flystart={

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';

	if (!walkmove(0,0))
	{
		dprint("flymonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
}