/*
    heist mod
*/

void() trig_item_heist_touch={

    local entity itm;
    local entity player;
    local entity this;

    if(!(other.flags & FL_HEIST_ITEM)){
        return;
    }
    activator = other;
    other.flags = other.flags - (other.flags  & FL_HEIST_ITEM);

    if((other.flags & FL_CLIENT)){
        player = other;
        itm = player.inv_item_heist;
        player.inv_item_encumber = 0;
        player.inv_item_heist = world;
        itm.owner = world;
        itm.inv_item_throw_owner = player;

        //restore weapon
        if(itm.inv_item_encumber == IT_ENCUMBER_DISARM){
            this = self;
            self = player;
                self.weapon = self.weapon_last;
                W_SetCurrentAmmo();
            self = this;
        }
    }
    else{
        //set item_heist to non-interact
        itm = other;
        activator = itm.inv_item_throw_owner;
    }
    
    itm.solid = SOLID_NOT;
    if((self.spawnflags & SPAWNFLAG_REMOVE_HEIST_ITM)){
        itm.movetype = MOVETYPE_NONE;
        spawn_tfog(itm.origin);
        remove(itm);
    }
    else{
        if(itm.movetype == MOVETYPE_TOSS){
            itm.velocity = itm.velocity * 0.33;
        }
        else{
            traceline(itm.origin, itm.origin + '0 0 -256 ', TRUE, itm);  
            itm.movetype = MOVETYPE_NONE;
            setorigin(itm, trace_endpos);
            itm.think = SUB_Null;
            itm.nextthink = time + 0.001;
        }
        itm.inv_item_heist_end = TRUE;
    }


    if((activator.flags & FL_CLIENT)){
        centerprint (activator, "Item lifted.\n");
    }

    self.count = self.count - 1;

    if(self.count != 0){
        return;
    }
    self.enemy = activator;
    multi_trigger();
};

void() trig_item_heist_use={

    if(!(self.spawnflags & SPAWNFLAG_START_OFF)){
        return;
    }
    self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNFLAG_START_OFF);
    self.solid = SOLID_TRIGGER;
    self.touch = trig_item_heist_touch;

};

/*
    Brush-model trigger.
    Counts ITEM_HEIST entities thrown into OR carried into trigger area.
*/
void() trigger_heist_item_bin={

    InitTrigger();

    if(!self.count){
        self.count = 1;
    }

    if((self.spawnflags & SPAWNFLAG_START_OFF)){
        self.solid = SOLID_NOT;
        return;
    }
    self.touch = trig_item_heist_touch;
};

void() heist_endzone_trig;
void() th_heist_endzone={

    local entity players;
    local float dist;
    local float trig;
    
    players = find(world, classname, "player");
    while(players){
        dist = vlen(players.origin - self.origin);

        if(dist <= self.trig_radius){
            trig = trig + 1;
        }

        players = players.chain;
    }

    if(trig >= CLIENT_ACTIVE_TOTAL){
        self.think = heist_endzone_trig;
        self.nextthink = time + 3;
    }
    else{
        self.think = th_heist_endzone;
        self.nextthink = time + 1;
    }
};

/*
    Call-by-trigger to activate, make sure SPAWNFLAG_START_OFF
*/
void() heist_endzone_use={
    //note: double-call prevention.
    if((self.spawnflags & SPAWNFLAG_START_OFF)){
        self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNFLAG_START_OFF);
        self.think = th_heist_endzone;
        self.nextthink = time + 1.0;
    }
};

void() heist_endzone_trig={
    //TODO - find first active and living player for activator.
    //activator = ?;
    multi_trigger();
};

/*
    Requires all players in it to trigger map end.

*/
void() heist_endzone={

    if(!self.trig_radius){
        self.trig_radius = 64;
    }

    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_NOT;

    //TODO - correct name for nail mdl?
    setsize(self, '-1 -1 -1', '1 1 1');

    if((self.spawnflags & SPAWNFLAG_START_OFF)){
        return;
    }

    self.think = th_heist_endzone;
    self.nextthink = time + 1.0;
};

void() trigger_heist_item_pile_touch={

    local entity newItem;
    local entity targItem;
    local entity this;
    local vector v;

    if(!(other.flags & FL_CLIENT)){
        return;
    }

    if(other.inv_item_heist){
        return;
    }

    if(other == self.inv_item_throw_owner){
        if(time < self.timer_action_start){
            return;
        }
    }

    targItem = self.inv_item_heist;

    self.inv_item_throw_owner = other;
    self.timer_action_start = time + 5;

    this = self;
    newItem = spawn();

    self = newItem;
        self.spawnflags = fabs(targItem.spawnflags);
        if(targItem.classname == "item_heist_gib"){
            self.classname = "item_heist_gib";
            item_heist_gib_spawn(targItem.ent_mdl_idx);
        }
        if(targItem.classname == "item_heist_pack"){
            self.classname = "item_heist_pack";
            self.ent_mdl_idx = targItem.ent_mdl_idx;
            item_heist_pack_spawn();
        }
        if(targItem.classname == "item_heist_ammo"){
            self.classname = "item_heist_ammo";
            self.ent_mdl_idx = targItem.ent_mdl_idx;
            item_heist_ammo_spawn();
        }
        if(targItem.classname == "item_heist_sigil"){
            self.classname = "item_heist_sigil";
            self.ent_mdl_idx = targItem.ent_mdl_idx;
            item_heist_sigil_spawn();
        }
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_NONE;

        setmodel(self, self.model);
        setsize(self, self.mins, self.maxs);
        setorigin(self, other.origin);

        self.cacheMins = self.mins;
        self.cacheMaxs = self.maxs;

        self.solid = SOLID_NOT;
        self.takedamage = DAMAGE_NO;

        self.origin_z = self.origin_z - 24;
        self.flags = self.flags - (self.flags & FL_ONGROUND);
        self.tempDir = normalize(other.origin - other.origin + '0 -8 0');
        self.think = self.throw;
        self.nextthink = time + 0.001;
    self = this;

    self.count = self.count - 1;
    
    if(self.count == 0){
        multi_trigger();
        self.solid = SOLID_NOT;

        if((self.spawnflags & SPAWNFLAG_KILL_ON_DONE)){

            WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
            WriteByte(MSG_BROADCAST, TE_EXPLOSION);
            WriteCoord(MSG_BROADCAST, self.cacheOrg_x);
            WriteCoord(MSG_BROADCAST, self.cacheOrg_y);
            WriteCoord(MSG_BROADCAST, self.cacheOrg_z);
            BecomeExplosion();
            return;
        }

        if((self.spawnflags & SPAWNFLAG_REMOVE_DONE)){
            remove(self);
            return;
        }

        self.spawnflags = self.spawnflags | SPAWNFLAG_START_OFF;
    }
};

void() trigger_heist_item_pile_use={
    if(!(self.spawnflags & SPAWNFLAG_START_OFF)){
        return;
    }
    self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNFLAG_START_OFF);
    self.solid = SOLID_TRIGGER;
    self.touch = trigger_heist_item_pile_touch;
};

void() trigger_heist_item_pile={

    local entity targItem;

    if(!self.group || self.group == ""){
        objerror(" missing group key!\n");
        return;
    }

    targItem = find(world, targetname, self.group);

    self.inv_item_heist = targItem;

    if(!self.inv_item_heist){
        objerror("couldn't find target heist_item for key.\n");
        return;
    }

    InitTrigger();

    if(!self.count){
        self.count = 1;
    }

    if((self.spawnflags & SPAWNFLAG_START_OFF)){
        self.solid = SOLID_NOT;
        return;
    }
    self.touch = trigger_heist_item_pile_touch;

    if((self.spawnflags & SPAWNFLAG_KILL_ON_DONE)){
        self.cacheOrg = self.absmin - self.absmax + world.origin;
    }

};


void() trigger_heist_start_init={


};

void() trigger_heist_start_use={

    self.think = trigger_heist_start_init;
    self.nextthink = time + self.count;
};

//map-load delay to make sure map-entiies spawned in.
void() trigger_heist_start_load={

    local entity t;

    t = find(world, wave_next_id, self.wave_next_id);
    if(!t){
        objerror("trigger_heist_start couldn't find first wave entity!\n");
        remove(self);
        return;
    }

    self.wave_next = t;
};
/*
    Begins wave-spawning system timer
*/
void()  trigger_heist_start={

    InitTrigger();

    if(!self.targetname || self.targetname == ""){
        objerror("trigger_heist_start missing targetname.\n");
        remove(self);
        return;
    }

    if(!self.wave_next_id || self.wave_next_id == ""){
        objerror("trigger_heist_start missing wave_next_id.\n");
        remove(self);
        return;
    }

    if(!self.count){
        self.count = 60;    //default 60 delay
    }
    self.use = trigger_heist_start_use;

    self.think = trigger_heist_start_load;
    self.nextthink = time + 3;
};

