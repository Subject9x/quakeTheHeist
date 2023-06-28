/*
	horde mod

    TODO
        + wave-point rollover - better iteration of wave points.
        + wave-point occupied detection,.
        + wave-point path corner, generate? make mapper place?
        + 'reset' wave-group to refire.

*/

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
    self.nextthink = time + 2;
};

//scan area of brush for any mobs being contained in it.
void() horde_wave_group_init={

    local entity mob;
    local vector v;
    local entity link;

    local entity point;

    v = math_brush_origin(self);

    mob = findradius(v, fabs(self.absmin_x - self.absmax_x) * 3);
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
    
    if(!self.wave_point){
        objerror("failed to build wave-point spawn list.\n");
        remove(self);
        return;
    }

    self.attack_state = FUNC_WAVE_STATE_READY;
};

void() horde_wave_group_use={

    if(self.attack_state != FUNC_WAVE_STATE_READY){
        return;
    }

    self.attack_state = FUNC_WAVE_STATE_RUN;
    self.think = horde_wave_group_spawn;
    self.nextthink = time + 1;

};

void() horde_wave_group_spawn_pause={


};

void() horde_wave_group_spawn={

    local entity mob;
    local entity point;

    if(self.count < 0){
        dprint("horde_wave_group_spawn complete!\n");
        self.attack_state = FUNC_WAVE_STATE_DONE;
        self.nextthink = -1;
        return;
    }
    
    //TODO - REFINE / FIX
    point = self.wave_point;
    if(self.wave_mob){
        mob = self.wave_mob;
        mob.flags = mob.flags - (mob.flags & FL_ONGROUND);
        setorigin(mob, point.origin);
        mob.angles = point.angles;

        force_retouch = 2;

        //bad fly-monster patch
        if(mob.classname == "monster_wizard"){
            mob.think = flymonster_start;
        }
        else{
            mob.think = walkmonster_start;
        }
        mob.nextthink = time + 0.1;

        self.wave_mob = self.wave_mob.wave_mob;
        if(self.wave_point.wave_point){
            self.wave_point = self.wave_point.wave_point;
        }
        else{
            self.wave_point = self.wave_point_start;
        }
        
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
    self.nextthink = time + 0.5;
};

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