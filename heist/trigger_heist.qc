/*
    heist mod
*/

#define SPAWNFLAG_REMOVE_HEIST_ITM 8

void() trig_item_heist_touch={

    if(!(other.flags & FL_HEIST_ITEM)){
        return;
    }

    if((other.flags & FL_CLIENT)){
        other.flags = other.flags - (other.flags  & FL_HEIST_ITEM);
        other.inv_item_encumber = 0;
        other.inv_item_heist = world;
    }
    else{

    }

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