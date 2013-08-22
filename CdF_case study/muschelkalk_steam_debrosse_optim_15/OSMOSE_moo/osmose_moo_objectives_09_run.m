function p = osmose_moo_objectives_09_run

clear set_p;
run(fullfile(fileparts(which(mfilename)), 'set_p.m'));
clear set_q;
run(fullfile(fileparts(which(mfilename)), 'set_q.m'));
p = moo_restart(p, q);
