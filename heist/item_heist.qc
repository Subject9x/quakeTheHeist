/*
	heist mod
*/

void() item_heist_touch;
void() item_heist_throw;
void() item_heist_land;

void() th_item_heist_thrown;
void() th_item_heist_place;

/*
	generic item for 'heist' gameplay.
*/
void() item_heist={

	if(!self.model){
		objerror("Heist item missing model!");
		remove(self);
		return;
	}

	precache_model(self.model);

	self.flags = self.flags | FL_HEIST_ITEM;
	self.touch = item_heist_touch;
	self.throw = item_heist_throw;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);

	self.cacheMins = self.mins;
	self.cacheMaxs = self.maxs;


	if(self.inv_item_encumber == IT_ENCUMBER_DISARM){
		self.view_ofs = '0 0 4';
		if(self.classname == "item_heist_ammo"){
			self.view_ofs_x = self.maxs_x / 2;
			self.view_ofs_y = self.maxs_z / -2;
		}
		if(self.classname == "item_heist_sigil"){
			self.view_ofs_x = self.maxs_x / 2;
			self.view_ofs_y = self.maxs_z / 3;
			self.view_ofs_z = self.maxs_y;
		}
		if(self.classname == "item_heist_gib"){
			self.view_ofs_x = self.maxs_x / 3;
			self.view_ofs_y = self.maxs_z / -2;
			self.view_ofs_z = self.maxs_y * 1.25;
		}
	}
	else{
		self.view_ofs_x = self.maxs_x / -2 - 8;
		self.view_ofs_z = self.maxs_x / 2 + 4;
		self.view_ofs_y = self.maxs_z / 2;
	}

	droptofloor();
};

void() item_heist_th_carry;
void() item_heist_touch={

	//only players can heist the item
	if(!(other.flags & FL_CLIENT)){
		return;
	}

	//already carrying heisted item.
	if((other.flags & FL_HEIST_ITEM)){
		return;
	}

	if(other.inv_item_heist){
		return;
	}

	if(self.velocity != '0 0 0'){
		return;
	}

	if(self.inv_item_heist_end){
		return;
	}

	if(time < self.timer_item_thrown_touch && other == self.inv_item_throw_owner){
		return;
	}

	other.flags = other.flags | FL_HEIST_ITEM;
	other.inv_item_heist = self;
	other.inv_item_encumber = self.inv_item_encumber;

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.angles = self.angles - '0 180 0';
	self.owner = other;

	if(self.inv_item_encumber == IT_ENCUMBER_DISARM){
		other.weapon_last = other.weapon;
		other.weaponmodel = "";
		other.currentammo = 0;
		other.weaponframe = 0;
	}

	makevectors(other.v_angle);
	self.origin = other.origin + (v_forward * self.view_ofs_z) + (v_right * self.view_ofs_x) + (v_up * self.view_ofs_y);
	setorigin(self, self.origin);

	self.frame = 0;
	self.think = item_heist_th_carry;
	self.nextthink = time + 0.01;
};


void() item_heist_th_carry={

	vector plrView;
	vector v;
	
	self.angles = self.owner.v_angle;
	
	plrView = self.angles;

	self.angles_x = self.angles_x * 0.25;
	if(self.inv_item_encumber != IT_ENCUMBER_DISARM || self.classname == "item_heist_gib"){
		self.angles_y = self.angles_y - 180;
	}
	
	makevectors(plrView);
	v = self.owner.origin + (v_forward * self.view_ofs_z) + (v_right * self.view_ofs_x) + (v_up * self.view_ofs_y);

	setorigin(self,v);
	
	self.frame = 0;
	self.think = item_heist_th_carry;
	self.nextthink = time + 0.01;
	self.oldorigin = v;
};

/*
	Player has thrown the item.
	set dir and velocity before this call!
*/
void() item_heist_throw={

	vector v;
	vector tOrg;
	entity this;

	self.owner.flags = self.owner.flags - (self.owner.flags & FL_HEIST_ITEM);
	self.owner.inv_item_heist = world;
	self.owner.inv_item_encumber = 0;

	//restore weapon
	if(self.inv_item_encumber == IT_ENCUMBER_DISARM){
		this = self;
		self = self.owner;
			self.weapon = self.weapon_last;
			W_SetCurrentAmmo();
		self = this;
	}

	self.inv_item_throw_owner = self.owner;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;

	makevectors(self.owner.angles);
	v = self.owner.origin + (v_forward *1);

	self.movedir = normalize(v - self.owner.origin);

	tOrg = self.owner.origin;// + (v_forward * 48);
	self.think = th_item_heist_thrown;
	self.nextthink = time + 0.01;
	
	setorigin(self, tOrg);

	self.owner = world;
};

void() th_item_heist_thrown={
	self.solid = SOLID_BBOX;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.velocity = self.movedir * 300 * self.inv_item_throw_wt;
	self.velocity_z = 250 * self.inv_item_throw_wt;

	self.think = item_heist_land;
	self.nextthink = time + 0.1;
};

void() th_item_heist_place={

	entity player;

	player = self.inv_item_throw_owner;

	if((player.flags & FL_ONGROUND)){
		makevectors(player.angles);
		traceline(player.origin, player.origin + (v_up * -512), FALSE, player);
		setorigin(self, trace_endpos + (v_up * self.maxs_z));
		droptofloor();
	}
	self.timer_item_thrown_touch = time + 4;

};

void() item_heist_land={

	if(self.velocity){
		self.think = item_heist_land;
		self.nextthink = time + 0.01;
		return;
	}

	self.angles = '0 0 0';
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';

	setsize(self, self.cacheMins, self.cacheMaxs);
	if(self.inv_item_heist_end){
		self.solid = SOLID_NOT;
	}
	else{
		self.solid = SOLID_TRIGGER;
		self.touch = item_heist_touch;
	}
	if(!(self.flags & FL_ONGROUND)){
		droptofloor();
		self.movetype = MOVETYPE_NONE;
	}
};


//==============
// THE ITEMS
//==============
void() item_heist_sigil={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*3));
	}

	self.inv_item_throw_wt = 1.0;
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
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*3));
	}

	self.model = "maps/b_shell1.bsp";
	self.inv_item_throw_wt = 0.85;
	if(self.ent_mdl_idx == 1){
		self.model = "maps/b_nail1.bsp";
		self.inv_item_throw_wt = 0.75;
	}
	if(self.ent_mdl_idx == 2){
		self.model = "maps/b_rock1.bsp";
		self.inv_item_throw_wt = 0.67;
	}
	if(self.ent_mdl_idx == 3){
		self.model = "maps/b_batt1.bsp";
		self.inv_item_throw_wt = 0.67;
	}

	item_heist();
};

void() item_heist_pack={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}

	self.model = "progs/backpack.mdl";
	self.inv_item_throw_wt = 0.85;

	/*self.colormod = '1.0 1.0 1.0';
	if(self.ent_mdl_idx == 1){
		self.colormod = '0.33 0.33 1.15';
	}
	if(self.ent_mdl_idx == 2){
		self.colormod = '0.33 1.15 0.33';
	}
	if(self.ent_mdl_idx == 3){
		self.colormod = '1.15 0.33 0.33';
	}*/

	item_heist();
};

void() item_heist_gib={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*9));
	}

	self.model = "progs/h_player.mdl";
	self.inv_item_throw_wt = 1.0;
	if(self.ent_mdl_idx == 1){
		self.model = "progs/h_guard.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}
	if(self.ent_mdl_idx == 2){
		self.model = "progs/h_knight.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}
	if(self.ent_mdl_idx == 3){
		self.model = "progs/h_zombie.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
		self.inv_item_throw_wt = 1.5;
	}
	if(self.ent_mdl_idx == 4){
		self.model = "progs/h_wizard.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
		self.inv_item_throw_wt = 0.85;
	}
	if(self.ent_mdl_idx == 5){
		self.model = "progs/h_hellkn.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
		self.inv_item_throw_wt = 0.75;
	}
	if(self.ent_mdl_idx == 6){
		self.model = "progs/h_ogre.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
		self.inv_item_throw_wt = 0.75;
	}
	if(self.ent_mdl_idx == 7){
		self.model = "progs/h_demon.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
		self.inv_item_throw_wt = 0.67;
	}
	if(self.ent_mdl_idx == 8){
		self.model = "progs/h_shal.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
		self.inv_item_throw_wt = 0.5;
	}
	if(self.ent_mdl_idx == 9){
		self.model = "progs/h_shams.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
		self.inv_item_throw_wt = 0.5;
	}
	
	item_heist();
};