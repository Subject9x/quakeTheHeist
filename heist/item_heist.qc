/*
	heist mod
*/

void() item_heist_touch;
void() item_heist_throw;
void() item_heist_land;

void() th_item_heist_thrown;

/*
	generic item for 'heist' gameplay.
*/
void() item_heist={

	if(!self.model){
		objerror("Heist item missing model!");
		remove(self);
		return;
	}


	self.flags = self.flags | FL_HEIST_ITEM;
	//self.touch = item_heist_touch; //WARN - use DP/FTE
	self.pinged = item_heist_touch; //WARN - vanilla compat.

	self.throw = item_heist_throw;

	self.root_class = "heist_item";

	precache_model(self.model);

	if(self.isMapObj == TRUE){
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_NONE;
		setmodel(self, self.model);
		setsize(self, self.mins, self.maxs);
		setorigin(self, self.origin);
		self.solid = SOLID_TRIGGER;
		droptofloor();
		self.cacheMins = self.mins;
		self.cacheMaxs = self.maxs;
	}
	else{
		setmodel(self, self.model);
		setsize(self, self.mins, self.maxs);
	}

	if(self.inv_item_encumber == IT_ENCUMBER_DISARM){
		self.view_ofs = '0 0 4';
		if(self.classname == "item_heist_ammo"){
			self.solid = SOLID_BSP;
			setmodel(self, self.model);
			setsize(self, self.mins, self.maxs);
			self.solid = SOLID_TRIGGER;

			self.view_ofs_x = self.maxs_x / 2;
			self.view_ofs_y = self.maxs_z / -2;
			self.view_ofs_z = self.maxs_y / 2;
		}
		if(self.classname == "item_heist_sigil"){
			self.view_ofs_z = self.maxs_z * 2;
			self.view_ofs_y = self.maxs_z / -6;
		}
		if(self.classname == "item_heist_gib"){
			self.view_ofs_z = self.maxs_z + 4;
			self.view_ofs_y = self.maxs_z / -4;
		}
	}
	else{
		if(self.classname == "item_heist_gib"){
			self.view_ofs_x = self.maxs_x / -2 - 8;
			self.view_ofs_z = self.maxs_x / 2 + 8;
			self.view_ofs_y = self.maxs_z / 2 + 2;
		}
		else{
			self.view_ofs_x = self.maxs_x / -2 - 8;
			self.view_ofs_z = self.maxs_x / 2 + 4;
			self.view_ofs_y = self.maxs_z / 2;
		}
	}
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

	if(self.velocity != '0 0 0'){
		return;
	}

	if(other.inv_item_heist){
		return;
	}

	if(self.inv_item_heist_end){
		return;
	}

	if(time < self.timer_item_thrown_touch && other == self.inv_item_throw_owner){
		return;
	}
	
	//WARN - use DP/FTE for this feature.
	//if(!other.button1){
	//	return;
	//}

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

	self.flags = self.flags - (self.flags & FL_ONGROUND);

	self.think = item_heist_th_carry;
	self.nextthink = time + 0.01;
};


void() item_heist_th_carry={

	local vector plrView;
	local vector v;
	
	self.angles = self.owner.v_angle;
	
	plrView = self.angles;

	self.angles_x = self.angles_x * 0.25;
	if(self.inv_item_encumber != IT_ENCUMBER_DISARM || self.classname == "item_heist_gib"){
		self.angles_y = self.owner.angles_y - 180;
	}
	
	makevectors(plrView);
	v = self.owner.origin + (v_forward * self.view_ofs_z) + (v_right * self.view_ofs_x) + (v_up * self.view_ofs_y);

	setorigin(self, v);
	
	self.frame = 0;
	self.think = item_heist_th_carry;
	self.nextthink = time + 0.001;
	self.oldorigin = v;
};

/*
	Player has thrown the item.
	set dir and velocity before this call!
*/
void() item_heist_throw={

	local vector v;
	local vector tOrg;
	local entity this;

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_NO;
	if(self.owner != world){
		self.owner.solid = SOLID_NOT;
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
		makevectors(self.owner.angles);
		
		//detect wall
		traceline(self.owner.origin, self.owner.origin + (v_forward * 600), TRUE, self.owner);

		if(vlen(trace_endpos - self.owner.origin) < 64){
			v = self.owner.origin + (v_forward * -10);

			self.tempDir = normalize( self.owner.origin - v);
			
			tOrg = self.owner.origin + (v_forward * -48);
		}
		else{
			v = self.owner.origin + (v_forward * 10);
			
			self.tempDir = normalize(v - self.owner.origin);
			

			tOrg = self.owner.origin + (v_forward * 48);
		}

		self.owner = world;
	}
	else{
		self.inv_item_throw_owner = world;
		tOrg = self.origin;
	}

	self.timer_item_throw_solid = time + 0.25;
	self.think = th_item_heist_thrown;
	self.nextthink = time + 0.01;
	setorigin(self, tOrg);
};

void() th_item_heist_thrown={

	if((self.inv_item_throw_owner.flags & FL_CLIENT)){
		self.inv_item_throw_owner.solid = SOLID_SLIDEBOX;
	}

	//self.solid = SOLID_BBOX;
	self.velocity = self.tempDir * 300 * self.inv_item_throw_wt;
	self.velocity_z = 250 * self.inv_item_throw_wt;

	self.think = item_heist_land;
	self.nextthink = time + 0.1;
};

void() item_heist_land={

	if(self.velocity != '0 0 0'){
		if(time > self.timer_item_throw_solid){
			if(pointcontents(self.origin) == CONTENT_EMPTY){
				if(self.solid != SOLID_SLIDEBOX){
					self.solid = SOLID_SLIDEBOX;
				}
			}
		}
		if(self.inv_item_heist_end){
			self.velocity = self.velocity - (self.velocity * 0.33 * frametime);
		}
		self.think = item_heist_land;
		self.nextthink = time + 0.01;
		return;
	}

	if(self.classname == "item_heist_gib"){
		//vanilla quake collisions get indigestion with non-cardinal angles on certain bboxes.
		//just watch an ammo box model be rendered detached from its QC origin and bounding box.
		self.angles = [0, math_quant_angle(self.angles_y), 0];
	}
	else{
		self.angles = '0 0 0';
	}

	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';

	setsize(self, self.cacheMins, self.cacheMaxs);
	if(self.inv_item_heist_end){
		self.solid = SOLID_NOT;
	}
	else{
		self.solid = SOLID_TRIGGER;
		//self.touch = item_heist_touch;
	}
	if(!(self.flags & FL_ONGROUND)){
		droptofloor();
		self.movetype = MOVETYPE_NONE;
	}
};


//==============
// THE ITEMS
//==============

void() item_heist_sigil_spawn={

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*3));
	}
	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
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
	if(self.ent_mdl_idx == 4){
		self.model = "progs/lavaball.mdl";
	}
	if(self.ent_mdl_idx == 5){
		self.model = "progs/v_spike.mdl";
	}

	item_heist();
};
void() item_heist_sigil={

	self.isMapObj = TRUE;
	item_heist_sigil_spawn();
};

void() item_heist_ammo_spawn={

	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*3));
	}
	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
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
	if(self.ent_mdl_idx == 4){
		self.model = "maps/heist_box1.bsp";
		self.inv_item_throw_wt = 0.75;
	}
	if(self.ent_mdl_idx == 5){
		self.model = "maps/heist_comp1.bsp";
		self.inv_item_throw_wt = 0.85;
	}

	item_heist();
};

void() item_heist_ammo={

	self.isMapObj = TRUE;
	item_heist_ammo_spawn();
};

void() item_heist_pack_spawn={

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
	}

	self.model = "progs/backpack.mdl";
	self.inv_item_throw_wt = 0.85;
	item_heist();
};

void() item_heist_pack={

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

	self.isMapObj = TRUE;
	item_heist_pack_spawn();
};

void(float mdlIndex) item_heist_gib_spawn={
	self.ent_mdl_idx = mdlIndex;
	if((self.spawnflags & SPAWNFLAG_MDL_RAND)){
		self.ent_mdl_idx = fabs(rint(random()*9));
	}
	self.model = "progs/h_player.mdl";
	self.inv_item_throw_wt = 1.0;

	if(!self.inv_item_encumber){
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
	}

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
	if(self.ent_mdl_idx == 10){
		self.model = "progs/fish.mdl";
		self.inv_item_encumber = IT_ENCUMBER_SHOOT;
		self.inv_item_throw_wt = 1.25;
	}
	if(self.ent_mdl_idx == 11){
		self.model = "progs/h_mega.mdl";
		self.inv_item_encumber = IT_ENCUMBER_DISARM;
		self.inv_item_throw_wt = 0.75;
	}
	item_heist();
};

void() item_heist_gib={
	self.isMapObj = TRUE;

	item_heist_gib_spawn(self.ent_mdl_idx);
};

void(float mdlId, vector dir) ThrowHeistItemGib={

	local entity gib;
	local entity this;

	if((self.isHordeMob)){
		this = self;
		gib = spawn();
		self = gib;
	}

	self.classname = "item_heist_gib";
	item_heist_gib_spawn(mdlId);

	self.cacheMins = self.mins;
	self.cacheMaxs = self.maxs;

	self.frame = 0;
	self.nextthink = -1;

	//setsize(self, '-16 -16 0', '16 16 56');
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.movetype = MOVETYPE_NONE;

	self.origin_z = self.origin_z - 8;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.tempDir = dir;
	self.think = self.throw;
	self.nextthink = time + 0.001;
	
	if((self.isHordeMob)){
		self = this;
	}

};

/*
	ITEM EXTENSIONS / CUSTOM
*/