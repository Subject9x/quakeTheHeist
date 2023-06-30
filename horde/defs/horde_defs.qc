/*
	horde mod.

*/
#define FUNC_WAVE_STATE_INIT 1
#define FUNC_WAVE_STATE_READY 2
#define FUNC_WAVE_STATE_RUN 3
#define FUNC_WAVE_STATE_DONE 4

#define SPAWNFLAG_HORDE_GROUP_VFX_TELE 1

entity HORDE_MANAGER;	// global singleton for horde management
void() horde_wave_manager;

//wave system
.string wave_next_id;		//find next wave entity
.entity wave_next;			//custom entity chain, set at map start.
.float wave_interval;
.float wave_size;
.entity wave_mob;			// entity chain for mobs in a func_wave
.entity wave_point;			// entity chain for spawn points in a func_wave
.entity wave_point_start;	// mark the chain start.


//WARN - horde standalone will need this uncommented.
//.float count_start;			//track initial count size of wave.

