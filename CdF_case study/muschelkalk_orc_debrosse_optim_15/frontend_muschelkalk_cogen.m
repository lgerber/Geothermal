function o = frontend
% 
% Subversion control line - don't delete it!
% $Id: frontend_example.m 952 2008-04-18 10:36:08Z gassner $
% 
% =========================================================================
%   FRONTEND TEMPLATE FOR OSMOSE MODEL AND COMPUTATIONS DEFINITION 
% =========================================================================
%
% Follow the osmose steps: 
% 1. Define your models in the 'DefineModel' subfunction in this file
% 2. Determine the computations filling out the template below
% 3. Fill the required subfunctions accordingly
% 4. Run this function
% 5. Wait the time of the computation
% 6. Enjoy and analyse the results!!
%
warning off
% -------------------------------------------------------------------------
%   Setting general parameters of the computation
% -------------------------------------------------------------------------

% Reduce the routine messages to the minimum [required].
o.Silent = 0;                       % 1: yes, 0: no

% -------------------------------------------------------------------------
%   Setting general parameters of the computation
% -------------------------------------------------------------------------

% Perform a single evaluation of your model [required].
o.DoOneRun = 0;         % 1: yes, 0: no
% Perform a sensibility analysis [required].
o.DoSensi       = 0;    % 1: yes, 0: no                     
% Perform an optimisation with moo [required].
o.DoMoo         = 1;    % 1: yes, 0: no                     
% Restart an optimisation with moo [required].
o.DoRestartMoo  = 0;    % 1: yes, 0: no
% Optimizes each point of the pareto front                        
o.DoPushPareto  = 0;    % 1 if you want to search the real pareto frontier
% Recompute the points on the Pareto front to get the details [required].
o.DoRecompute   = 0;    % 1: yes, 0: no
% Plot figures for analysis of the Pareto results
o.DoParetoAnalysis = 0; % 1: yes, 0: no
% Generate an automatic report of the computation [required].
o.DoAutoReport  = 0;    % 1: yes, 0: no                  
% Generate a custom report of the computation [required].
o.DoCustomReport= 0;    % 1: yes, 0: no
                        
o = launch_osmose(o);

% =========================================================================
function o = DefineModel(o)

% -------------------------------------------------------------------------
% Definition of the model(s)
% Fill first the general model specifications, then each model can be
% completed with specific properties according to the software used.
% Available softwares : vali, easy, AMPL (energy integration is not defined
% for ampl models)

%                 
% -------------------------------------------------------------------------
%   Model definition
% -------------------------------------------------------------------------
% o.MPI.on = 1; %Necessary for parallel resolution with multiple nodes
% %o.MPI.shared_directory = {'/home/hoban/models/Model_geotherm/MPI_common_folder'};
% % o.MPI.machines = {'nodeID1', 'nodeID2', 'nodeID3', ... , 'nodeIDN'};
% % o.MPI.nslaves = N;
% o.MPI.maxqueuelength = 6; %between 4 and 8

% addpath(fullfile(pwd,'geothermal_egs_egsorc'));
% addpath(fullfile(pwd,'orc_bleeding_multifluid_egsorc'));
% addpath(fullfile(pwd,'geothermal_shallow_cooling_egsorc'));
% addpath(fullfile(pwd,'geothermal_shallow_heating_egsorc'));
% addpath(fullfile(pwd,'geothermal_deep_egsorc'));
% addpath(fullfile(pwd,'orc_simple_multifluid_egsorc'));
% addpath(fullfile(pwd,'heat_pump_egsorc'));
addpath('/home/lgerber/oc/models_CdF');
% o = osmose_appendModelMFileNames(o,{'geo_egs','cold_source','orc_bleeding_multifluid_egsorc','demand_profiles','geo_shallow_cool_egsorc','geo_shallow_heat_egsorc','geo_deep_egsorc','single_period_indics','combined_period_indics'}); %,'refrigeration_cycle'
o = osmose_appendModelMFileNames(o,{'electricity_production_muschelkalk_cad_orc'}); %,'refrigeration_cycle'
% ------------------------------------------------------------------------
% Specify if easy is used to perform the energy integration [required].
o.ComputeEI = 1;        % 1: yes, 0: no
                        % if yes, define the fields below.

% % Specify the objective used for the resolution of the heat cascade [optional].
% % Ex.:  o.EasyObjective = {'Operating cost'}; or {'Exergy'}; or {'Mechanical power'};
% % (Default is {'Operating cost'})
o.EI.PlotCCs = 0;
o.Eiampl.MILPParserName = {'ampl'}; % or ampl 
o.Ampl.Executable ={'/usr/local/ampl/ampl'}; 
o.EI.Params.Software = {'eiampl'};
o.Eiampl.Objective = {'OperatingCost'}; %{'OperatingCost'};
o.Eiampl.MILPSolverName = {'cplexamp'};

%o.Glpk.Executable = {'/usr/local/glpk-4.44/bin/glpsol'}; % ie c:\.....

% -------------------------------------------------------------------------
% Specify if life cycle impact assessment calculation is done [required]
o.ComputeLCIA = 0;      % 1:yes, 0:no
                        % if yes, define the fields below. 

% o.Paths.EcoinventDirectory = fullfile('C:\models\osmose\handlers\software\LCIA','ecoinvent');
                        
o.LCIA.ImpactMethod = {'ei99ha'}; % 'cml01_short', 'cml01_ext', 'ei99ha', 'ei99ee','ei99ii','impact02_end','ced','ubp','footprint','ipcc01'
                        
o.LCIA.IncludeProcessEquipment = 1;
o.LCIA.LifeCycleStageMode = 1;

% o.LCIA.FunctionalUnit.Quantity = {'@ORC_multi.W_TOT'}; 
o.LCIA.FunctionalUnit.Value = 1; %default value! This is updated after
o.LCIA.FunctionalUnit.Unit = {'kWh'}; %unit in which is given the FU
o.LCIA.FunctionalUnit.Description = {'Total district heating produced for 1 year of operation'}; 

o.LCIA.Graphics.PlotContribution = 0;
o.LCIA.Graphics.PlotContributionGlobal = 1;
o.LCIA.Graphics.CutOff = 0.01;
o.LCIA.Graphics.SavePlot = 0;

% =========================================================================
function o = DefineOneRun(o)

% -------------------------------------------------------------------------
%   Definition of the parameters for the execution of a single evaluation
% -------------------------------------------------------------------------

% =========================================================================
function o = DefineSensi(o)

% -------------------------------------------------------------------------
%   Definition of a parametric sensibility analysis
% -------------------------------------------------------------------------

% Define the parameter to vary [required].

% Define the name of the model to whom the tag belongs [required].
% Ex.:  o.Variables(i).ModelTagName    = {'SNG'};
o.Variables(1).ModelTagName    = {'demand_profiles'};
o.Variables(1).TagName          = {'elec_price'};
o.Variables(1).LowerBound       = 15;
o.Variables(1).UpperBound       = 26;
o.Variables(1).NumberOfSteps    = 2;

% Define a second parameter to vary for 2D sensibility [optional].

% o.Variables(2).ModelTagName    = {''};
% o.Variables(2).DisplayName    = {''};
% o.Variables(2).Unit           = {''};
% o.Variables(2).TagName        = {''};
% o.Variables(2).LowerBound     = ;
% o.Variables(2).UpperBound     = ;
% o.Variables(2).NumberOfSteps  = ;

% =========================================================================
function o = DefineMooOptim(o)

% -------------------------------------------------------------------------
%   Definition of the optimisation problem
% -------------------------------------------------------------------------

o.MPI.on = 1;

% Number of objectives [required].
o.Moo.nobjectives = 2;

% Number of maximal iterations [required].
o.Moo.max_evaluations = 12000;

% Number of clusters [required].
% A cluster is a subset of the Pareto population with similar values of the
% variables
o.Moo.nclusters = 1;

% Size of the initial population, i.e. number of initial points [required].
o.Moo.InitialPopulationSize = 500;

% Objectives definition

o.ComputeObjectives = 1;

i=0;

% Definition of objectives [required]
i=i+1;
o.ObjectiveFunction(i).ModelTagName = {'elec_prod'};
o.ObjectiveFunction(i).TagName = {'profit_elec'};
o.ObjectiveFunction(i).MinOrMax     = {'max'}; 
o.ObjectiveFunction(i).DisplayName = {'Annual profit of the system (without Cinv) CHF'};

i=i+1;
o.ObjectiveFunction(i).ModelTagName = {'elec_prod'};
o.ObjectiveFunction(i).TagName = {'cinv_tot_chf'};
o.ObjectiveFunction(i).MinOrMax     = {'min'}; 
o.ObjectiveFunction(i).DisplayName = {'Total investment costs CHF'};

% Define the decision variables [required].

i=0;

i=i+1; % 
o.Variables(i).ModelTagName = {'elec_prod'};
o.Variables(i).TagName = {'geo_inj_t'};
o.Variables(i).Unit           = {'C'};
o.Variables(i).Is_integer     = 0;
o.Variables(i).Limits	  = [12 25];

i = i+1;
o.Variables(i).ModelTagName    = {'elec_prod'};
o.Variables(i).TagName    = {'E_prod'}; % period average estimated with data of M�gel, 2011
o.Variables(i).Unit           = {'kW'};
o.Variables(i).Is_integer     = 0;
p=0;
p = p+1;
o.Variables(i).Period(p).Limits         = [1000 5000]; 
p = p+1;
o.Variables(i).Period(p).Limits         = [0 0];
p = p+1;
o.Variables(i).Period(p).Limits         = [1000  5000];
p = p+1;
o.Variables(i).Period(p).Limits         = [1000  5000];
p = p+1;
o.Variables(i).Period(p).Limits         = [1000  5000];
p = p+1;
o.Variables(i).Period(p).Limits         = [1000  5000];

i=i+1; % 
o.Variables(i).ModelTagName = {'elec_prod'};
o.Variables(i).TagName = {'orc_wf3_t'};
o.Variables(i).Unit           = {'C'};
o.Variables(i).Is_integer     = 0;
p=0;
p=p+1;
o.Variables(i).Period(p).Limits         = [40 60];
p=p+1;
o.Variables(i).Period(p).Limits         = [40 60];
p=p+1;
o.Variables(i).Period(p).Limits         = [40 60];
p=p+1;
o.Variables(i).Period(p).Limits         = [40 60];
p=p+1;
o.Variables(i).Period(p).Limits         = [40 60];
p=p+1;
o.Variables(i).Period(p).Limits         = [40 60];

i=i+1; % 
o.Variables(i).ModelTagName = {'elec_prod'};
o.Variables(i).TagName = {'orc_wf4_t'};
o.Variables(i).Unit           = {'C'};
o.Variables(i).Is_integer     = 0;
p=0;
p=p+1;
o.Variables(i).Period(p).Limits         = [60 80];
p=p+1;
o.Variables(i).Period(p).Limits         = [60 80];
p=p+1;
o.Variables(i).Period(p).Limits         = [60 80];
p=p+1;
o.Variables(i).Period(p).Limits         = [60 80];
p=p+1;
o.Variables(i).Period(p).Limits         = [60 80];
p=p+1;
o.Variables(i).Period(p).Limits         = [60 80];

i=i+1; % 
o.Variables(i).ModelTagName = {'elec_prod'};
o.Variables(i).TagName = {'orc_wf7_t'};
o.Variables(i).Unit           = {'C'};
o.Variables(i).Is_integer     = 0;
o.Variables(i).Limits         = [14 20];

% 
% % -------------------------------------------------------------------------
% %   Definition the parameters for displaying
% % -------------------------------------------------------------------------
% 
o.Moo.monitor =...
    {
    o.Moo.InitialPopulationSize 'moo_restart_monitor'
    o.Moo.InitialPopulationSize 'moo_count_monitor' 	    % population display in the  prompt [number of eval.]
    o.Moo.InitialPopulationSize 'moo_speed_monitor' 	    % speed display in the prompt  [number of eval.]
    o.Moo.InitialPopulationSize 'moo_objective_monitor' 	% objective display in the  prompt [number of eval.]
    o.Moo.InitialPopulationSize/100 'moo_draw' 			    % graph displaying frequency  [number of eval.]
    o.Moo.InitialPopulationSize 'moo_stop_monitor' 	        % number of evaluations
};

o.Moo.drawing.invert = 1;

o.Moo.test_name = mfilename; % gives the name of this file to the moo results folder
% 
% % Options for plotting results
% o.GraphicOptions.DoParetoAnalysis = 1;
% o.GraphicOptions.PlotPareto = 1;
% o.GraphicOptions.PlotDecVar = 0;
% o.GraphicOptions.PlotCorrelations = 0;
% o.GraphicOptions.PlotMatrix =1;
% 
% % =========================================================================
% function o = DefineRestartMoo(o)
% 
% % -------------------------------------------------------------------------
% %   Definition of the results folder for restarting an optimisation
% % -------------------------------------------------------------------------
% 
% % Specify the name of the results directory
% o.Paths.MooResultsDirectoryName = {'C:\results\run_0003'};
% 
% % ====================================================================================================
% function o = DefinePushPareto(o)
% %
% % Define the output paramters and properties to run pushPareto handler
% % ---------------------------------------------------------------------------------
% 
% 
% o.Paths.MooRunNumber ={sprintf('%s_%s',char(o.Model.TagName),char(o.Model.optimSelector))};
% 
% %% Set options accepted by optimset
% o.pushPareto.Display={'none'};
% o.pushPareto.Diagnostics = {'off'};
% o.pushPareto.plotPareto = 1;
% 
% % Followin values are relatives. 1e-1 means 10%
% o.pushPareto.DiffMinChange = 1e-2;
% o.pushPareto.DiffMaxChange = 1e-1;
% o.pushPareto.TolFun = 1e-3;
% o.pushPareto.TolX = 1e-2;
% o.pushPareto.TolCon = 1e-3;
% % o.pushPareto.PlotFcns = {@optimplotx,@optimplotfunccount,@optimplotfval,@optimplotconstrviolation,@optimplotstepsize,@optimplotfirstorderopt};
% 
% % o.pushPareto.MaxIter = 1;
% o.GraphicOptions.ColorStyle = {'lines'};

% display convergence statistics
% disp(sprintf('Iteration %i', o.Model(o.ModelID).Counter));
% disp(sprintf('%6.1f%s Vali convergence',ValiConvergenceCounter/o.Model(o.ModelID).Counter*100,'%'));
% disp(sprintf('%6.1f%s Easy convergence',EasyConvergenceCounter/ValiConvergenceCounter*100,'%'));
% disp(sprintf('%6.1f%s Model convergence (total)',model_convergence/o.Model(o.ModelID).Counter*100,'%'));

% =========================================================================
function o = DefineRecompute(o)

% -------------------------------------------------------------------------
%   Definition of files and folders for recomputing the points on the
%   Pareto front
% -------------------------------------------------------------------------

% Specify the run in the OSMOSE_results directory whose Pareto curve you
% want to analyse (ex.: o.Paths.MooRunNumber = {'run_0002'}):
o.Paths.MooRunNumber = {'run_0004'};

% Alternatively, indicate the path of the results directory in which the
% Pareto curve is saved. The model files of this run are used to recompute
% the points (ex. o.Paths.MooResultsDirectory =
% {'C:\oc\SNG_model_2.5\osmose_example_SNG\OSMOSE_results\run_0002\OSMOSE_moo'})

% If you want to recompute the pareto curve of an optimisation that did not
% finish entirely, don't specify anything here - during the run, a dialog
% will appear demanding the necessary information.

% =========================================================================
function o = DefineParetoAnalysis(o)

% -------------------------------------------------------------------------
%   ...
% -------------------------------------------------------------------------

o.Paths.MooRunNumber = {'run_0002'};

o.GraphicOptions.PlotPareto = 1;
o.GraphicOptions.PlotDecVar = 1;
o.GraphicOptions.PlotScatterplots = 1;
o.GraphicOptions.PlotCorrelations = 1;
o.GraphicOptions.PlotCorrelationCoefficients = 1;
o.GraphicOptions.PlotVariableDistribution = 1;
o.GraphicOptions.VariableDistributionObjectiveNumber = 2;
o.GraphicOptions.SavePlots = 1;

o.paretoAnalysis.PlotParetoHistory = 1;
o.paretoAnalysis.PlotCompositeCurvesEvolution = 0;
o.GraphicOptions.SaveMovies = 0;
o.paretoAnalysis.compositeCurvesToPlot = {'power'};

o.GraphicOptions.ColorStyle = {'summer'};

% =========================================================================

function o = DefineConstants(o)
 
% constants

i = 0;
i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dhn_ret_t'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 58; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 58; % juin
p = p+1;
o.Constants(i).Period(p).Value = 59; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 61; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 63; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 65; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dhn_fed_t'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 90; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 90; % juin
p = p+1;
o.Constants(i).Period(p).Value = 92; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 96; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 99; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 112; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'op_time'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 2190; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 730; % juin
p = p+1;
o.Constants(i).Period(p).Value = 1460; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 1460; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 2920; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 0; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_ret_t1'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 27; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 27; % juin
p = p+1;
o.Constants(i).Period(p).Value = 32; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 41; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 49; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 50; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_fed_t1'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 60; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 60; % juin
p = p+1;
o.Constants(i).Period(p).Value = 60; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 60; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 60; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 65; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_load1'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 200; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 200; % juin
p = p+1;
o.Constants(i).Period(p).Value = 200; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 150; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 80; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 4690; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_ret_t2'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 25; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 25; % juin
p = p+1;
o.Constants(i).Period(p).Value = 28; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 35; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 39; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 50; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_fed_t2'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 27; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 27; % juin
p = p+1;
o.Constants(i).Period(p).Value = 32; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 41; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 49; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 50; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_load2'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 500; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 500; % juin
p = p+1;
o.Constants(i).Period(p).Value = 1020; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 1990; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 2810; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 0; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_ret_t3'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 10; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 10; % juin
p = p+1;
o.Constants(i).Period(p).Value = 10; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 10; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 10; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 10; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_fed_t3'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 25; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 25; % juin
p = p+1;
o.Constants(i).Period(p).Value = 28; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 35; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 39; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 50; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'dh_load3'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 70; % mai, juillet, ao�t
p = p+1;
o.Constants(i).Period(p).Value = 70; % juin
p = p+1;
o.Constants(i).Period(p).Value = 70; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 100; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 150; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 1500; % -10, dimensionnement
% 
% i = i+1;
% o.Constants(i).ModelTagName    = {'elec_prod'};
% o.Constants(i).TagName    = {'Q_dhn'}; % taken from O.Megel
% 
% p=0;
% p = p+1;
% o.Constants(i).Period(p).Value = 3760; % mai, juillet, ao�t
% p = p+1;
% o.Constants(i).Period(p).Value = 0; % juin
% p = p+1;
% o.Constants(i).Period(p).Value = 5710; % avril, septembre
% p = p+1;
% o.Constants(i).Period(p).Value = 8990; % mars, octobre
% p = p+1;
% o.Constants(i).Period(p).Value = 10100; % novembre-f�vrier
% p = p+1;
% o.Constants(i).Period(p).Value = 13820; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'heat_load'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 0; % mai, juillet, ao�t -> check!!!
p = p+1;
o.Constants(i).Period(p).Value = 3000*1.132; % juin
p = p+1;
o.Constants(i).Period(p).Value = 1270*1.132; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 1770*1.132; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 2270*1.132; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 4000; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'hot_source'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 2; % mai, juillet, ao�t -> check!!!
p = p+1;
o.Constants(i).Period(p).Value = 2; % juin
p = p+1;
o.Constants(i).Period(p).Value = 2; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 2; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 2; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 2; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'geo_volumef_ref'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 15; % mai, juillet, ao�t -> check!!!
p = p+1;
o.Constants(i).Period(p).Value = 15; % juin
p = p+1;
o.Constants(i).Period(p).Value = 15; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 15; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 15; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 15; % -10, dimensionnement

i = i+1;
o.Constants(i).ModelTagName    = {'elec_prod'};
o.Constants(i).TagName    = {'geo_volumef_max'};

p=0;
p = p+1;
o.Constants(i).Period(p).Value = 15; % mai, juillet, ao�t -> check!!!
p = p+1;
o.Constants(i).Period(p).Value = 15; % juin
p = p+1;
o.Constants(i).Period(p).Value = 15; % avril, septembre
p = p+1;
o.Constants(i).Period(p).Value = 15; % mars, octobre
p = p+1;
o.Constants(i).Period(p).Value = 15; % novembre-f�vrier
p = p+1;
o.Constants(i).Period(p).Value = 15; % -10, dimensionnement


% =========================================================================
function o = launch_osmose(o)

% -------------------------------------------------------------------------
% Launches osmose computation, DO NOT EDIT
% -------------------------------------------------------------------------

o = DefineModel(o);

if o.DoOneRun == 1
    o = DefineOneRun(o);
    o = DefineConstants(o);
end
if o.DoSensi == 1
    o = DefineSensi(o);
    o = DefineConstants(o);
end
if o.DoMoo == 1
    o = DefineMooOptim(o);
    o = DefineConstants(o);
end
if o.DoRestartMoo == 1
    o = DefineMooOptim(o);
    o = DefineRestartMoo(o);
    o = DefineConstants(o);
end
if o.DoPushPareto == 1
    o = DefineMooOptim(o);
    o = DefinePushPareto(o);
end
if o.DoRecompute == 1
    o = DefineMooOptim(o);
    o  = DefineRecompute(o);
    o = DefineConstants(o);
end
if o.DoParetoAnalysis == 1
    o = DefineParetoAnalysis(o);
end
if o.DoAutoReport == 1
    o = DefineAutoReport(o);
end
if o.DoCustomReport == 1
    o = DefineCustomReport(o);
end

o = run_frontend(o);