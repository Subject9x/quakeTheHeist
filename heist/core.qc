/*
    heist mod

    core is the meta-data map entities for a heist mission.
*/


/*
    called in-World
*/
void() heist_core_music_ini=
{
   MUSIC_ACTION = world.music_action;
   MUSIC_MOOD = world.music_mood;
   MUSIC_WAIT = world.music_wait;

    if(MUSIC_ACTION == 0)
    {
        MUSIC_ACTION = 2 + fabs(rint(random() * 10));
    }
    if(MUSIC_MOOD == 0)
    {
        MUSIC_MOOD = 13 + fabs(rint(random() * 6));
    }
    if(MUSIC_WAIT == 0)
    {
        //TODO
    }
};

void(entity e) heist_core_music_send=
{
    msg_entity = e;

    if(HORDE_MANAGER)
    {
        if(HORDE_MANAGER.attack_state == FUNC_WAVE_STATE_RUN)
        {
            WriteByte (MSG_ONE, SVC_CDTRACK);
            WriteByte (MSG_ONE, MUSIC_ACTION);        // CD start track
            WriteByte (MSG_ONE, MUSIC_ACTION);        // CD end track
        }
        else
        {
            WriteByte (MSG_ONE, SVC_CDTRACK);
            WriteByte (MSG_ONE, MUSIC_MOOD);        // CD start track
            WriteByte (MSG_ONE, MUSIC_MOOD);        // CD end track
        }
    }
};

void() heist_core_music_mood=
{
    WriteByte (MSG_ALL, SVC_CDTRACK);
    WriteByte (MSG_ALL, MUSIC_MOOD);        // CD start track
    WriteByte (MSG_ALL, MUSIC_MOOD);        // CD end track
};

void() heist_core_music_loud=
{
    WriteByte (MSG_ALL, SVC_CDTRACK);
    WriteByte (MSG_ALL, MUSIC_ACTION);        // CD start track
    WriteByte (MSG_ALL, MUSIC_ACTION);        // CD end track
};

void() heist_core_start=
{


};