echo off
echo battleMETAL v4.0.0 COMPILE ALL
echo ------------------------------

echo COMPILE PROGS.DAT
echo ------------------------------
fteqcc64.exe -Wno-mundane -Fkce -Fwasm -Fifvector -Fvectorlogic -Ffastarrays -Fno-boundchecks