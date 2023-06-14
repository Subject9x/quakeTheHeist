/*
    heist mod
*/

#define SPAWNFLAG_REMOVE_HEIST_ITM 8

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

/*
    Brush-model trigger.
    Counts ITEM_HEIST entities thrown into OR carried into trigger area.
*/
void() trigger_heist_item_bin={

    if(!self.count){
        self.count = 1;
    }

    self.solid = SOLID_TRIGGER;
    self.movetype = MOVETYPE_NONE;

    self.touch = trig_item_heist_touch;
};

