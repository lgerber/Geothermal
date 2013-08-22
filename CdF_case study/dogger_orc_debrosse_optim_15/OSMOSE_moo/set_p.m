p.nvars =  20;
p.objective = 'osmose_moo_objectives';
p.initialise = 'osmose_moo_init';
p.nobjectives =  2;
p.monitor{1} =  500;
p.monitor{2} =  500;
p.monitor{3} =  500;
p.monitor{4} =  500;
p.monitor{5} =  5;
p.monitor{6} =  500;
p.monitor{7} = 'moo_restart_monitor';
p.monitor{8} = 'moo_count_monitor';
p.monitor{9} = 'moo_speed_monitor';
p.monitor{10} = 'moo_objective_monitor';
p.monitor{11} = 'moo_draw';
p.monitor{12} = 'moo_stop_monitor';
p.monitor = reshape(p.monitor, [ 6 2 ]);
p.test_name = 'frontend_dogger_cogen';
p.max_evaluations =  12000;
p.nclusters =  1;
p.drawing.invert =  1;
p.keep_tails =  0;
p.keep_duplicates =  1;
p.cluster_dims = [  1  2  3  4  5 ];
p.thin.off =  0;
p.keep_intermediate_pops =  1;
p.group(1).limits = [  12  25 ];
p.group(1).is_integer =  0;
p.group(1).indexes =  1;
p.group(2).limits = [  1000  5000 ];
p.group(2).is_integer =  0;
p.group(2).indexes =  2;
p.group(3).limits = [  0  0 ];
p.group(3).is_integer =  0;
p.group(3).indexes =  3;
p.group(4).limits = [  1000  5000 ];
p.group(4).is_integer =  0;
p.group(4).indexes =  4;
p.group(5).limits = [  1000  5000 ];
p.group(5).is_integer =  0;
p.group(5).indexes =  5;
p.group(6).limits = [  1000  5000 ];
p.group(6).is_integer =  0;
p.group(6).indexes =  6;
p.group(7).limits = [  1000  5000 ];
p.group(7).is_integer =  0;
p.group(7).indexes =  7;
p.group(8).limits = [  40  60 ];
p.group(8).is_integer =  0;
p.group(8).indexes =  8;
p.group(9).limits = [  40  60 ];
p.group(9).is_integer =  0;
p.group(9).indexes =  9;
p.group(10).limits = [  40  60 ];
p.group(10).is_integer =  0;
p.group(10).indexes =  10;
p.group(11).limits = [  40  60 ];
p.group(11).is_integer =  0;
p.group(11).indexes =  11;
p.group(12).limits = [  40  60 ];
p.group(12).is_integer =  0;
p.group(12).indexes =  12;
p.group(13).limits = [  40  60 ];
p.group(13).is_integer =  0;
p.group(13).indexes =  13;
p.group(14).limits = [  60  80 ];
p.group(14).is_integer =  0;
p.group(14).indexes =  14;
p.group(15).limits = [  60  80 ];
p.group(15).is_integer =  0;
p.group(15).indexes =  15;
p.group(16).limits = [  60  80 ];
p.group(16).is_integer =  0;
p.group(16).indexes =  16;
p.group(17).limits = [  60  80 ];
p.group(17).is_integer =  0;
p.group(17).indexes =  17;
p.group(18).limits = [  60  80 ];
p.group(18).is_integer =  0;
p.group(18).indexes =  18;
p.group(19).limits = [  60  80 ];
p.group(19).is_integer =  0;
p.group(19).indexes =  19;
p.group(20).limits = [  14  20 ];
p.group(20).is_integer =  0;
p.group(20).indexes =  20;
p.handler = 'osmose_MatlabMPI_moo_eval';
p.shared_directory{1} = '/home/lgerber/oc/CdF_dogger_orc_optim_15';
p.objective_directory = 'oc/Matlab_files/osmose_lastversion/handlers/computation/moo/';
p.test_directory = 'results/frontend_dogger_cogen/';
p.run_number =  1;
p.run_directory = 'results/frontend_dogger_cogen/run_0001/';
p.run_name = 'osmose_moo_objectives_01_run.m';