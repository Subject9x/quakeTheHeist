/*
	heist mod
*/

void() item_heist_touch;
void() item_heist_throw;
void() item_heist_land;

void() item_heist_throw_touch;
void() th_item_heist_thrown;

/*
	generic item for 'heist' gameplay.
*/
void() item_heist={

	if(strlen(self.model) < 1){
		objerror("Heist item missing model!");
		remove(self);
		return;
	}

	precache_model(self.model);

	self.flags = self.flags | FL_HEIST_ITEM;
	self.touch = item_heist_touch;
	self.throw = item_heist_throw;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);

	droptofloor(self.angles_y, 64);
};

void() item_heist_touch={

	//only players can heist the item
	if(!(other.flags & FL_CLIENT)){
		return;
	}

	//already carrying heisted item.
	if((other.flags & FL_HEIST_ITEM)){
		return;
	}

	other.flags = other.flags | FL_HEIST_ITEM;
	other.inv_item_heist = self;
	other.inv_item_encumber = self.inv_item_encumber;

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FOLLOW;
	self.aiment = other;
	self.punchangle = other.angles;
	self.view_ofs = self.origin - other.origin;
	self.v_angle = self.angles;
	self.owner = other;
};

/*
	Player has thrown the item.
	set dir and velocity before this call!
*/
void() item_heist_throw={

	self.owner.flags = self.owner.flags - (self.owner.flags | FL_HEIST_ITEM);
	self.owner.inv_item_heist = world;

	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
	self.dphitcontentsmask = DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_CORPSE | DPCONTENTS_NODROP;
	self.owner = world;

	self.avelocity = vectoangles(self.velocity);

	self.think = th_item_heist_thrown;
	self.nextthink = time + 0.1;
};

void() item_heist_land={

	droptofloor(self.angles_y, 64);

	self.movetype = MOVETYPE_NONE;
	if(self.inv_item_heist_end){
		self.solid = SOLID_NOT;
		self.touch = SUB_Null;
	}
	else{
		self.solid = SOLID_BSP;
	}
};

void() item_heist_throw_touch={



};

void() th_item_heist_thrown={

	

};

//==============
// THE ITEMS
//==============
void() heist_item_sigil={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*3));
	}

	self.model = "progs/end1.mdl";
	if(self.ent_mdl_idx == 1){
		self.model = "progs/end2.mdl";
	}
	if(self.ent_mdl_idx == 2){
		self.model = "progs/end3.mdl";
	}
	if(self.ent_mdl_idx == 3){
		self.model = "progs/end4.mdl";
	}

	item_heist();
};

void() item_heist_ammo={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*3));
	}

	self.model = "maps/b_shell1.bsp";
	if(self.ent_mdl_idx == 1){
		self.model = "maps/b_nail1.bsp";
	}
	if(self.ent_mdl_idx == 2){
		self.model = "maps/b_rock1.bsp";
	}
	if(self.ent_mdl_idx == 3){
		self.model = "maps/b_batt1.bsp";
	}

	item_heist();
};

void() item_heist_pack={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}

	self.model = "progs/backpack_enforcer.mdl";

	self.colormod = '1.0 1.0 1.0';
	if(self.ent_mdl_idx == 1){
		self.colormod = '0.33 0.33 1.15';
	}
	if(self.ent_mdl_idx == 2){
		self.colormod = '0.33 1.15 0.33';
	}
	if(self.ent_mdl_idx == 3){
		self.colormod = '1.15 0.33 0.33';
	}

	item_heist();
};

void() item_heist_gib={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*9));
	}

	self.model = "progs/h_player1.mdl";
	if(self.ent_mdl_idx == 1){
		self.model = "progs/h_guard.mdl";
	}
	if(self.ent_mdl_idx == 2){
		self.model = "progs/h_knight.mdl";
	}
	if(self.ent_mdl_idx == 3){
		self.model = "progs/h_zombie.mdl";
	}
	if(self.ent_mdl_idx == 4){
		self.model = "progs/h_wizard.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}
	if(self.ent_mdl_idx == 5){
		self.model = "progs/h_hellkn.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}
	if(self.ent_mdl_idx == 6){
		self.model = "progs/h_ogre.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}
	if(self.ent_mdl_idx == 7){
		self.model = "progs/h_demon.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}
	if(self.ent_mdl_idx == 8){
		self.model = "progs/h_shal.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}
	if(self.ent_mdl_idx == 9){
		self.model = "progs/h_shams.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}
	
	item_heist();
};