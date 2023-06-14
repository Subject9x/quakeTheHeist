/*
    heist mod
*/

void() trig_item_heist_touch={

    local entity itm;

    if(!(other.flags & FL_HEIST_ITEM)){
        return;
    }

    activator = other;

    if((other.flags & FL_CLIENT)){
        itm = other.inv_item_heist;
        other.flags = other.flags - (other.flags  & FL_HEIST_ITEM);
        other.inv_item_encumber = 0;
        other.inv_item_heist = world;
    }
    else{
        //set item_heist to non-interact
        itm = other;
    }

    if(itm.movetype != MOVETYPE_TOSS){
        itm.velocity = normalize(itm.origin - (itm.origin + '0 0 10'), 25);
        itm.angles = vectoangles(self.velocity);
        itm.think = itm.throw;
        itm.nextthink = time + 0.01;    
    }
    itm.inv_item_heist_end = TRUE;

    if((activator.flags & FL_CLIENT)){
        centerprint (activator, "Item lifted.");
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

    self.movetype = MOVETYPE_NONE;

    if(!self.count){
        self.count = 1;
    }

    if((self.spawnflags & SPAWNFLAG_START_OFF)){
        self.solid = SOLID_NOT;
        return;
    }

    self.solid = SOLID_TRIGGER;
    self.touch = trig_item_heist_touch;
};


void() th_heist_endzone={

    entity players;
    float dist;
    float trig;
    
    players = findchain(classname, "player");
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
        self.nextthink = time + 1.0
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
void() heist_mob_spawn_init;
void() heist_mob_spawn_point={

    if(strlen(self.group) < 1){
        objerror(sprintf("[heist_mob_spawn_point] missing .group field. at %s", vtos(self.origin)));
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

    points = findchain(group, self.group);
    while(points){
        if(points.classname == "heist_mob_wave_group"){
            parent = true;
        }
        points = points.chain;
    }
    if(!parent){
        objerror(sprintf("[heist_mob_spawn_point] has no parent wave entity at %s", vtos(self.origin)));
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
void() th_heist_mob_wave_int;
void() heist_mob_wave_group={

    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;

    if(strlen(self.group) < 1){
        objerror(sprintf("[heist_mob_wave_group] missing .group field. at %s", vtos(self.origin)));
        remove(self);
        return;
    }

    self.use = heist_mob_wave_use;
    self.think = th_heist_mob_wave_int;
    self.nextthink = time + 0.5;
};

//just a validation method for debug
void() th_heist_mob_wave_int={

    entity points;
    
    points = findchain(group, self.group);
    if(!points){
        objerror(sprintf("[heist_mob_wave_group] has no children spawn points at %s", vtos(self.origin)));
        remove(self);
        return;
    }
};

void() th_heist_mob_wave_trig={


};
