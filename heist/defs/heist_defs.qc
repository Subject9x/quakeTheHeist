/*
	heist mod
*/
#define false 0
#define true 1

#define FL_HEIST_ITEM 8192
#define FL_HEIST_ITEM_END 16384	//to 'end' item in final position, used mostly by trigger

#define SPAWNFLAG_START_OFF 1
#define SPAWNFLAG_REMOVE_HEIST_ITM 8
#define SPAWNFLAG_MDL_RAND 1

#define IT_ENCUMBER_SHOOT 1		//player encumbered but allowed to use weapons.
#define IT_ENCUMBER_DISARM 2	//player encumbered,and item occupies active weapon slot.

//Action timer balance
#define TIME_ITEM_PICK_GIB 10
#define TIME_ITEM_PICK__RUNE 15
#define TIME_ITEM_PICK_AMMO 8

#define TIME_ACTION_DOOR_PICK 20
#define TIME_ACTION_BUTTON_PRESS 5

#define CL_IMPULSE_ITEM_THROW 16

.string group;

.vector cacheMins;
.vector cacheMaxs;

.float trig_radius;
.void() throw;

.float ent_mdl_idx;
.entity inv_item_throw_owner;	//who threw that!?

.float inv_item_throw_wt;	//multiplier for throw speed
.float inv_item_heist_end;	//bool - if item thrown / dropped into final "bin" position
.float inv_item_encumber;	//0, 1, 2 - encumbrance setting
.entity inv_item_heist;	//specific entity player is carrying



// Action timers
.float timer_action_start;
.float timer_action_length;
.float timer_item_thrown_touch;	//cooldown before retouch IF no space to throw!

.float weapon_last; // cache weapon for post-item-throw

float CLIENT_ACTIVE_TOTAL;
entity ENT_CLIENT1;
entity ENT_CLIENT2;
entity ENT_CLIENT3;
entity ENT_CLIENT4;


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