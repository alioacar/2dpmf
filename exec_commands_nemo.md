# Merging
*rebuild_nemo -t [number_of_cores]* *[filename]* *[number_of_files]* <br>
/m1/acar/MODEL/NEMO-fabm1/NEMOGCM/TOOLS/REBUILD_NEMO/TOOLS/REBUILD_NEMO/rebuild_nemo -t 2 MarmaraSea_1d_20140101_20141231_grid_T 20
# Execution
/nfsshare/software/openmpi-4.1.4/bin/mpirun -np 220 -hostfile ./hostfile --mca btl_tcp_if_include em1 -n 20 ./xios_server.exe : -n 200 ./opa &
