/*
	horde mod

    TODO
        + wave-point rollover - better iteration of wave points.
        + wave-point occupied detection,.
        + wave-point path corner, generate? make mapper place?
        + 'reset' wave-group to refire.

*/


/*
    server entry-point to wave manager
*/
void() horde_wave_manager_use;
void() horde_wave_manager={

    HORDE_MANAGER = spawn();

    if(!HORDE_MANAGER){
        error("worldspawn - failed to generate HORDE_MANAGER!\n");
        return;
    }

    HORDE_MANAGER.wave_next_id = "1";

};


void() horde_wave_manager_use={


};

//=====================================================
void() horde_wave_group_init;
void() horde_wave_group_use;
void() horde_wave_group_spawn;

/*
    Wave groups are brush-entities that scan their contents for mobs.
    Mobs are linked together as the basis of the wave.

*/
void() func_horde_wave_group={

    InitTrigger();

    if(!self.targetname || self.targetname == ""){
        objerror("missing targetname, needed for use.");
        remove(self);
        return;
    }

    if(!self.wave_interval){
        self.wave_interval = 1;
    }
    self.attack_state = FUNC_WAVE_STATE_INIT;
    self.use = horde_wave_group_use;
    self.think = horde_wave_group_init;
    self.nextthink = time + 5;
};

//scan area of brush for any mobs being contained in it.
void() horde_wave_group_init={

    local entity mob;
    local vector v;
    local entity link;

    local entity point;

    
    self.owner = HORDE_MANAGER;

    v = math_brush_origin(self);
    
    mob = findradius(v, math_brush_radius(self.absmax, self.absmin));
    link = self;
    while(mob){
        if(math_point_in_area(mob.origin, self.absmax, self.absmin)){
            mob.nextthink = -1; //pause the mob
            mob.owner = self;
            self.count = self.count + 1;
            
            link.wave_mob = mob;
            link = mob;
        }
        mob = mob.chain;
    }
    if(!self.wave_mob){
        objerror("\nfailed to find any mobs in trigger area!\nradius:");
        dprint(ftos(math_brush_radius(self.absmax, self.absmin))); 
        logVec("origin", v);    //debug

        remove(self);
        return;
    }

    if(!self.wave_point){
        objerror("failed to build wave-point spawn list.\n");
        remove(self);
        return;
    }
    else{
        if(cvar("developer") > 0){
            dprint("wave point list built.\n");
        }
    }

    self.attack_state = FUNC_WAVE_STATE_READY;
};

void() horde_wave_group_use={

    if(self.attack_state != FUNC_WAVE_STATE_READY){
        dprint("\n self.attack_state != FUNC_WAVE_STATE_READY \n");
        return;
    }

    if(self.attack_state == FUNC_WAVE_STATE_READY){
        //detects "first-time use"

    }
    self.attack_state = FUNC_WAVE_STATE_RUN;

    self.think = horde_wave_group_spawn;
    self.nextthink = time + 1;

};

//NOTE - if spawn point is 'blocked', pause the wave-spawning
void() horde_wave_group_spawn_pause={


};

void() horde_wave_group_spawn={

    local entity mob;
    local entity point;
    local entity clientTarg;

    if(self.count < 0){
        dprint("horde_wave_group_spawn complete!\n");
        self.attack_state = FUNC_WAVE_STATE_DONE;
        self.nextthink = -1;
        multi_trigger();
        return;
    }
    
    point = self.wave_point;
    if(self.wave_mob){
        mob = self.wave_mob;
        mob.flags = mob.flags - (mob.flags & FL_ONGROUND);
        setorigin(mob, point.origin);
        mob.angles = point.angles;

        force_retouch = 2;

        //TODO - bad fly-monster patch

        if(ENT_CLIENT1 || (ENT_CLIENT1.flags & FL_HEIST_ITEM)){
            clientTarg = ENT_CLIENT1;
        }
        if(ENT_CLIENT2 || (ENT_CLIENT2.flags & FL_HEIST_ITEM)){
            clientTarg = ENT_CLIENT2;
        }
        if(ENT_CLIENT3 || (ENT_CLIENT3.flags & FL_HEIST_ITEM)){
            clientTarg = ENT_CLIENT3;
        }
        if(ENT_CLIENT4 || (ENT_CLIENT4.flags & FL_HEIST_ITEM)){
            clientTarg = ENT_CLIENT4;
        }
        mob.enemy = clientTarg;
        mob.think = mob.th_run;
        mob.nextthink = time + 0.1;

        self.wave_mob = self.wave_mob.wave_mob;
        if(self.wave_point.wave_point){
            self.wave_point = self.wave_point.wave_point;
        }
        else{
            self.wave_point = self.wave_point_start;
        }
        
    }
    else{
        dprint("horde_wave_group_spawn no more mobs!\n");
        self.attack_state = FUNC_WAVE_STATE_DONE;
        self.nextthink = -1;
        multi_trigger();
        return;
    }

    self.count = self.count - 1;
    self.think = horde_wave_group_spawn;
    self.nextthink = time + 1;

};

/*
    Monster wave-point, use these to spawn waves of baddies as players are hordein'.
*/
void() th_horde_mob_spawn_init;
void() horde_mob_spawn_point={

    if(!self.group  || self.group == ""){
        objerror("[horde_mob_spawn_point] missing .group field.\n");
        remove(self);
        return;
    }

    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    setsize(self, '-16 -16 -24', '16 16 24');
    setorigin(self, self.origin);

    self.think = th_horde_mob_spawn_init;
    self.nextthink = time + 1.0;
};

//wave_point waits a few seconds for all map-ents to spawn in before building its linked list.
void() th_horde_mob_spawn_init={

    local entity funcWave;
    local entity pointLink;
    local entity pointNext;

    funcWave = find(world, group, self.group);
    if(!funcWave){
        objerror("missing parent(.group) entity\n");
        remove(self);
        return;
    }

    if(funcWave.classname != "func_horde_wave_group"){
        objerror("missing parent wasn't a func_horde_wave_group!\n");
        remove(self);
        return;
    }

    //construct func_wave's point chain bottom-up.
    pointLink = funcWave.wave_point;

    if(pointLink){
        pointNext = pointLink.wave_point;

        while(pointNext){
            pointLink = pointNext;
            pointNext = pointNext.wave_point;
        }
        pointLink.wave_point = self;
    }
    else{
        funcWave.wave_point = self;
        funcWave.wave_point_start = self;
    }
};