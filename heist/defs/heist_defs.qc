/*
	heist mod
*/
#define FL_HEIST_ITEM 8192

#define SPAWNFLAG_START_OFF 1
#define SPAWNFLAG_REMOVE_HEIST_ITM 8
#define SPAWNFLAG_MDL_RAND 1

#define SPAWNFLAG_MONST_ARMR_L 4
#define SPAWNFLAG_MONST_ARMR_H 8

#define SPAWNFLAG_KILL_ON_DONE 8
#define SPAWNFLAG_REMOVE_DONE 16

#define SPAWNFLAG_HEIST_GIB 8	//monster dies and makes heist item gib

#define IT_ENCUMBER_SHOOT 1		//player encumbered but allowed to use weapons.
#define IT_ENCUMBER_DISARM 2	//player encumbered,and item occupies active weapon slot.

#define MONST_GIB_ID_SOLDIER 1
#define MONST_GIB_ID_KNIGHT 2
#define MONST_GIB_ID_ZOMBIE 3
#define MONST_GIB_ID_WIZARD 4
#define MONST_GIB_ID_HELLKNIGHT 5
#define MONST_GIB_ID_OGRE 6
#define MONST_GIB_ID_FIEND 7
#define MONST_GIB_ID_SHAL 8
#define MONST_GIB_ID_SHMBLR 9
#define MONST_GIB_ID_FISH 10
#define MONST_GIB_ID_ENFRC 11

#define CONST_ITEM_CLASS "heist_item"
.string root_class;	//WARN - vanilla compat.

//Action timer balance
#define TIME_ITEM_PICK_GIB 10
#define TIME_ITEM_PICK__RUNE 15
#define TIME_ITEM_PICK_AMMO 8

#define TIME_ACTION_DOOR_PICK 20
#define TIME_ACTION_BUTTON_PRESS 5

#define CL_IMPULSE_ITEM_THROW 16
#define CL_IMPULSE_CLIENT_USE 17	//compatibility for vanilla

#define CL_STATE_CONN 1
#define CL_STATE_RESPN 2

#define AMMO_SHELLS_PICKUP 16

#define AMMO_MAX_SHELLS 100
#define AMMO_MAX_NAILS 200
#define AMMO_MAX_NADES 100
#define AMMO_MAX_CELLS 200

#define AMMO_USE_RIFLE 1
#define AMMO_USE_SHOTG 4
#define AMMO_USE_NAILG 1
#define AMMO_USE_SUPERNL 2
#define AMMO_USE_NADE 1
#define AMMO_USE_RCKT 2
#define AMMO_USE_LIGHT 1

#define DMG_AXE_BASE 30	//20
#define DMG_CL_RIFLE 24 // 6
#define DMG_CL_SHOTG 20	//14
#define DMG_CL_NAILG 3	//9
#define DMG_CL_HMG 20 //13
#define DMG_CL_NADE 40
#define DMG_CL_RCKT 40
#define DMG_CL_LIGHT 6

#define ROF_RIFLE 0.67
#define ROF_SHOTG 1.0
#define ROF_NAILG 0.09
#define ROF_HMG 0.3
#define ROF_NADE 2 //0.6
#define ROF_RCKT 4	//0.8

float MUSIC_ACTION;
float MUSIC_MOOD;
float MUSIC_WAIT;

.float ent_mdl_idx;
.string group;
.float isMapObj;	// detect if entity is spawned by map vs dynamic
.vector cacheMins;
.vector cacheMaxs;
.vector cacheOrg;
.float trig_radius;
.vector tempDir;

.void() pinged;	//used for "use-key" callback from player.
.void() throw;	// heist_item thrown.

.entity inv_item_throw_owner;	//who threw that!?
.float inv_item_throw_wt;	//multiplier for throw speed
.float inv_item_heist_end;	//bool - if item thrown / dropped into final "bin" position
.float inv_item_encumber;	//0, 1, 2 - encumbrance setting
.entity inv_item_heist;	//specific entity player is carrying
.float inv_armor_wt;	//heavier armor is...well heavier.

.float count_start;			//track initial count size.

// Action timers
.float timer_action_start;
.float timer_action_length;
.float timer_item_thrown_touch;	//cooldown before retouch IF no space to throw!
.float timer_item_throw_solid;	//timer until item becomes solid

.float weapon_dmg;	//base damage
.float weapon_last; // cache weapon for post-item-throw

.float health_max;	

.float music_mood;
.float music_action;
.float music_wait;

.float client_state;
float CLIENT_ACTIVE_TOTAL;
entity ENT_CLIENT1;
entity ENT_CLIENT2;
entity ENT_CLIENT3;
entity ENT_CLIENT4;

// Assault waves
void(string msg, vector v) logVec={

	dprint("\n");
	dprint(msg);
	dprint(":");
	dprint(vtos(v));
	dprint("\n");

};

void(string msg, string val) logStr={
	
	dprint("\n");
	dprint(msg);
	dprint(":");
	dprint(val);
	dprint("\n");
};


void(string msg, float val) logFloat={
	
	dprint("\n");
	dprint(msg);
	dprint(":");
	dprint(ftos(val));
	dprint("\n");
};

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

float(vector org, vector pos, vector neg) math_point_in_area={

	/*
	dprint("\n-math_point_in_area\n");
	logVec("org", org);
	logVec("pos", pos);
	logVec("neg", neg);
	dprint("\n-------\n");
	*/

	if(org_x > pos_x || org_x < neg_x){
		return FALSE;
	}
	if(org_y > pos_y || org_y < neg_y){
		return FALSE;
	}
	if(org_z > pos_z || org_z < neg_z){
		return FALSE;
	}
	
	//dprint("\npoint in area[X]\n");	//debug
	return TRUE;
};

vector(entity brush) math_brush_origin={

	local vector v;

	/*
	logVec("brush org", brush.origin);
	logVec("absmax", brush.absmax);
	logVec("absmin", brush.absmin);
	logVec("org?", brush.absmax - brush.absmin);
	*/
	v_x = (brush.absmax_x - brush.absmin_x) / 2;
	v_y = (brush.absmax_y - brush.absmin_y) / 2;
	v_z = (brush.absmax_z - brush.absmin_z) / 2;
	v = v + brush.absmin;

	//logVec("real org?", v);

	return v;

};

float(vector pos, vector neg) math_brush_radius={
	local float x;
	local float y;
	local float v;

	x = fabs(neg_x - pos_x);
	y = fabs(neg_y - pos_y);
	v = (x + y) / 2;

	return v;
};

void() game_monst_set_armor={
	
	float type, value, bit;
	if ((self.spawnflags & SPAWNFLAG_MONST_ARMR_L))
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if ((self.spawnflags & SPAWNFLAG_MONST_ARMR_H))
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}
	self.armortype = type;
	self.armorvalue = value;
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
};