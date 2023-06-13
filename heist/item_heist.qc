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
		self.think = SUB_Remove;
		self.nextthink = time + 0.01;
		return;
	}

	precache_model(self.model);

	self.flags = self.flags | FL_HEIST_ITEM;
	self.touch = item_heist_touch;
	self.throw = item_heist_throw;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin)

	droptofloor();


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

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FOLLOW;
	self.owner = other;
	self.aiment = other;


};

/*
	Player has thrown the item.
*/
void() item_heist_throw={

	self.owner.flags = self.owner.flags - (self.owner.flags | FL_HEIST_ITEM);
	self.owner.inv_item_heist = world;

	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_CORPSE;
	self.dphitcontentsmask = DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_CORPSE | DPCONTENTS_NODROP;
	self.owner = world;
	
	self.think = th_item_heist_thrown;
	self.nextthink = time + 0.1;
};

void() item_heist_land={

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BSP;
	droptofloor();

};

void() item_heist_throw_touch={



};

void() th_item_heist_thrown={

	

};