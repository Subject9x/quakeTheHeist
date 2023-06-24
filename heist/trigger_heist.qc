/*
    heist mod
*/

void() trig_item_heist_touch={

    entity itm;
    entity player;
    entity this;

    if(!(other.flags & FL_HEIST_ITEM)){
        return;
    }
    activator = other;

    if((other.flags & FL_CLIENT)){
        player = other;
        itm = player.inv_item_heist;
        player.flags = player.flags - (player.flags  & FL_HEIST_ITEM);
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
        itm.think = SUB_Remove;
        itm.nextthink = time + 0.1;
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

    entity players;
    float dist;
    float trig;
    
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

/*
    Monster wave-point, use these to spawn waves of baddies as players are heistin'.
*/
void() th_heist_mob_spawn_init;
void() heist_mob_spawn_point={

    if(!self.group){
        objerror("[heist_mob_spawn_point] missing .group field.\n");
        remove(self);
        return;
    }

    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;

    setsize(self, '-16 -16 -24', '16 16 24');

    self.think = th_heist_mob_spawn_init;
    self.nextthink = time + 0.1;
};
void() th_heist_mob_spawn_init={

    entity points;
    float parent;

    parent = false;

    points = find(world, group, self.group);
    while(points){
        if(points.classname == "heist_mob_wave_group"){
            parent = true;
        }
        points = points.chain;
    }
    if(!parent){
        objerror("[heist_mob_spawn_point] has no parent wave entity.\n");
        remove(self);
        return;
    }
};

/*
    TODO - FINISH THIS
    Defines a mob-wave composition, and has a collection of [heist_mob_spawn_point] to use.
*/
void() th_heist_mob_wave_trig;
void() heist_mob_wave_use={

    self.think = th_heist_mob_wave_trig;
    if(self.wait > 0.0){
        self.nextthink = time + self.wait;
        return;
    }
    self.nextthink = time + 0.1;
    
};
void() th_heist_mob_wave_init;
void() heist_mob_wave_group={

    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;

    if(!self.group){
        objerror("[heist_mob_wave_group] missing .group field.\n");
        remove(self);
        return;
    }

    self.use = heist_mob_wave_use;
    self.think = th_heist_mob_wave_init;
    self.nextthink = time + 0.5;
};

//just a validation method for debug
void() th_heist_mob_wave_init={

    entity points;
    
    points = find(world, group, self.group);
    if(!points){
        objerror("[heist_mob_wave_group] has no children spawn points.\n");
        remove(self);
        return;
    }
};

void() th_heist_mob_wave_trig={

    if(true){
        return;
    }

};
