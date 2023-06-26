/*
	heist mod
*/
#define FL_HEIST_ITEM 8192
#define FL_HEIST_ITEM_END 16384	//to 'end' item in final position, used mostly by trigger

#define SPAWNFLAG_START_OFF 1
#define SPAWNFLAG_REMOVE_HEIST_ITM 8
#define SPAWNFLAG_MDL_RAND 1

#define SPAWNFLAG_KILL_ON_DONE 8
#define SPAWNFLAG_REMOVE_DONE 16

#define IT_ENCUMBER_SHOOT 1		//player encumbered but allowed to use weapons.
#define IT_ENCUMBER_DISARM 2	//player encumbered,and item occupies active weapon slot.

#define SPAWNFLAG_HEIST_GIB 8	//monster dies and makes heist item gib

#define MONST_GIB_ID_SOLDIER 1
#define MONST_GIB_ID_KNIGHT 2
#define MONST_GIB_ID_ZOMBIE 3
#define MONST_GIB_ID_WIZARD 4
#define MONST_GIB_ID_HELLKNIGHT 5
#define MONST_GIB_ID_OGRE 6
#define MONST_GIB_ID_FIEND 7
#define MONST_GIB_ID_SHAL 8
#define MONST_GIB_ID_SHMBLR 9

//Action timer balance
#define TIME_ITEM_PICK_GIB 10
#define TIME_ITEM_PICK__RUNE 15
#define TIME_ITEM_PICK_AMMO 8

#define TIME_ACTION_DOOR_PICK 20
#define TIME_ACTION_BUTTON_PRESS 5

#define CL_IMPULSE_ITEM_THROW 16

.float ent_mdl_idx;
.string group;
.float isMapObj;	// detect if entity is spawned by map vs dynamic
.vector cacheMins;
.vector cacheMaxs;
.vector cacheOrg;
.float trig_radius;
.vector tempDir;

.void() throw;

.entity inv_item_throw_owner;	//who threw that!?
.float inv_item_throw_wt;	//multiplier for throw speed
.float inv_item_heist_end;	//bool - if item thrown / dropped into final "bin" position
.float inv_item_encumber;	//0, 1, 2 - encumbrance setting
.entity inv_item_heist;	//specific entity player is carrying





// Action timers
.float timer_action_start;
.float timer_action_length;
.float timer_item_thrown_touch;	//cooldown before retouch IF no space to throw!
.float timer_item_throw_solid;	//timer until item becomes solid

.float weapon_last; // cache weapon for post-item-throw

float CLIENT_ACTIVE_TOTAL;
entity ENT_CLIENT1;
entity ENT_CLIENT2;
entity ENT_CLIENT3;
entity ENT_CLIENT4;

void(float mdlId, vector dir) ThrowHeistItemGib;

void(vector v1, vector v2) dbg_line={

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, v1_x);
	WriteCoord(MSG_BROADCAST, v1_y);
	WriteCoord(MSG_BROADCAST, v1_z);
	WriteCoord(MSG_BROADCAST, v2_x);
	WriteCoord(MSG_BROADCAST, v2_y);
	WriteCoord(MSG_BROADCAST, v2_z);
};

float(float ang) math_quant_angle={

	local float f;

	f = fabs(ang) / 360;
	f = f * 4;
	f = ceil(f);

	return f * 90;
};