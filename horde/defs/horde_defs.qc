/*
	horde mod.

*/
#define FUNC_WAVE_STATE_INIT 1
#define FUNC_WAVE_STATE_READY 2
#define FUNC_WAVE_STATE_RUN 3
#define FUNC_WAVE_STATE_DONE 4

#define SPAWNFLAG_HORDE_GRP_ORD_SIZE 16		//Spawn from lightest mob to heaviest
#define SPAWNFLAG_HORDE_GRP_ORD_RVSIZE 32	//spawn from heaviest mob to lightest
#define SPAWNFLAG_HORDE_GRP_ORD_RAND 64 //randomly spawn the next mob type

#define MOB_ID_FISH 1
#define MOB_ID_DOG 2
#define MOB_ID_ARMY 4
#define MOB_ID_ENFRCE 8
#define MOB_ID_KNIGHT 16
#define MOB_ID_OGRE 32
#define MOB_ID_FIEND 64
#define MOB_ID_HKNIGHT 128
#define MOB_ID_WIZRD 256
#define MOB_ID_VORE 512
#define MOB_ID_SHMBL 1024
#define MOB_ID_ZMBIE 2048
#define MOB_ID_TARBB 4096

#define SPAWNFLAG_HORDE_GROUP_VFX_TELE 1

entity HORDE_MANAGER;	// global singleton for horde management
void() horde_wave_manager;

//wave system
.string wave_next_id;		//find next wave entity
.string wave_point_group;	//unique id for wave points to target.
.entity wave_next;			//custom entity chain, set at map start.
.float wave_interval;
.float wave_size;
.entity wave_point;			// entity chain for spawn points in a func_wave
.entity wave_point_start;	// mark the chain start.
.float wave_mobs;			// collection reference


//WARN - horde standalone will need this uncommented.
//.float count_start;			//track initial count size of wave.

.float isHordeMob;			// bool - set when mob is swept up by a horde_wave_group
.vector hordeStart;			// log mob's horde start spot (useful for horde_wave_group)

//Decided to go with a field-count system for spawning monsters.
.float mob_fish;
.float mob_dog;
.float mob_army;
.float mob_enforcer;
.float mob_knight;
.float mob_ogre;
.float mob_fiend;
.float mob_hellknight;
.float mob_wizard;
.float mob_vore;
.float mob_shambler;
.float mob_zombie;
.float mob_tarbb;

#define M_mob_decrement(returnId, mobField, mobId) if((self.wave_mobs & mobId)){if(mobField > 0){returnId = mobId;mobField = mobField - 1;}else{self.wave_mobs = self.wave_mobs - (self.wave_mobs & mobId);}}