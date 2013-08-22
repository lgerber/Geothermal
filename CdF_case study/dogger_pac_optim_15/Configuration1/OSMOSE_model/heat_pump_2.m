function technology = heat_pump_2
%% Classification by grouping
technology.Group                      = {'Utilities'};       % Frist level of classification 
technology.Type                       = {'Heat Pump'};       % Second level of classification 
technology.SubType                    = {''};       % Third level of classification 
  
%% OSMOSE parameters
technology.OSMOSEVersion = {'2.7.8'};
technology.ETVersion = {'2.0.0'};
technology.Version = {'0.8.0'};
  
%% technology detail level
technology.PhysicalRepresentation     = {'0d'};       % Provides information about the level of detail of the technology.

%% Direct access
[path,name,extension] = fileparts(which(mfilename));
technology.FileName                  = {[name,extension],'heat_pump_compute.bls'};
technology.MainFile                  = {'heat_pump_compute.m'};
technology.Location                  = {path};
technology.Software                  = {'vali'};
technology.PreModelMFunction                  = {'HP2_PreModel'};
  
%% User tagging definition
technology.TagName                    = {'heat_pump2'};     % User-defined tag name 
technology.DisplayName                = {'Heat pump'};     % User-defined pretty short name
technology.Description               = { 'Simple model of a mechanical heat pump using R134a as the working fluid.'};     % Short paragraph containing the technology description

%% PinchLight tagging
technology.Keywords(1)          = {' pinchlight:type=utility '};
technology.Keywords(2)          ={'pinchlight:sector=any'}; 
technology.Keywords(3)          = {'pinchlight:subsector=any'}; 
technology.Keywords(4)          = {'pinchlight:technology=any'}; 
technology.Keywords(5)          = {'pinchlight:name=any'}; 
technology.DescriptionImageFileName = {''}; 
technology.Documentation.Url = {''};

%% Technology authoring
ncs=0;
  
ncs=ncs+1;
technology.Changesets(ncs).Id              = 1;         % Changeset identifier (integer)
technology.Changesets(ncs).Author          = {'Gerber Léda'};       % Author's name
technology.Changesets(ncs).Date            = {'21-May-2010'};       % Date of changeset
technology.Changesets(ncs).ChangeLog       = {''};       % Text describing the changes
technology.Changesets(ncs).ReferenceId     = {' '};       % Link to references (same DefaultValue as technology.References.Id)
  
technology.References.Id              = [];         % Reference Identifier (integer)
technology.References.Source          = {' '};       % Source of information. Use BibTeX style
technology.References.Comments        = {' '};       % Comments
  
technology.Tags                       = struct;   % This tructure contains all the internal parameters of the technology.

%% Material Streams
  
technology.MatStreams                = struct;  % this structure contains information about material streams entering or leaving the technology.

%% Units
nu=0;
  
nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'heat_pump'};
technology.EI.Units(nu).DisplayName = {'Heat Pump'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'@hp_massf_max/@hp_evap_out_massf'};
technology.EI.Units(nu).Cost1 = {'0'};
% technology.EI.Units(nu).Cost2 = {'@hp_w_power*3600*@demand_profiles.var_elec_price*@demand_profiles.dh_sell_price'};
technology.EI.Units(nu).Cost2 = {'@hp_w_power*3600*5'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'@hp_w_power'};

%% Tags definition

% Heat pump parameters

nc=0;
nc=nc+1;
technology.Tags(nc).DisplayName = {'Evaporation temperature'};
technology.Tags(nc).TagName = {'hp_evap_out_t'};
technology.Tags(nc).Description = {'Temperature at which working fluid is evaporating'};
technology.Tags(nc).DefaultValue = 60;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Condensation temperature'};
technology.Tags(nc).TagName = {'hp_cond_out_t'};
technology.Tags(nc).Description = {'Temperature at which working fluid is condensing'};
technology.Tags(nc).DefaultValue = 70;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Compressor efficiency'};
technology.Tags(nc).TagName = {'compressor_effic'};
technology.Tags(nc).Description = {'Mechanical efficiency of the compressor'};
technology.Tags(nc).DefaultValue = 0.8;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Power required'};
technology.Tags(nc).TagName = {'hp_w_power'};
technology.Tags(nc).Description = {'Mechanical power required by the compressor'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'OFF'};
technology.Tags(nc).isVIT =2;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat load at evaporation'};
technology.Tags(nc).TagName = {'q_evap_load'};
technology.Tags(nc).Description = {'Heat load transfered to working fluid at evaporation'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'OFF'};
technology.Tags(nc).isVIT =2;

technology.Tags(nc).DisplayName = {'Reference mass flow rate'};
technology.Tags(nc).TagName = {'hp_evap_out_massf'};
technology.Tags(nc).Description = {'Reference mass flow rate of working fluid'};
technology.Tags(nc).DefaultValue = 10;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Maximal mass flow rate'};
technology.Tags(nc).TagName = {'hp_massf_max'};
technology.Tags(nc).Description = {'Maximal mass flow rate of working fluid'};
technology.Tags(nc).DefaultValue = 100;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

% Energy integration parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'DTmin at evaporation'};
technology.Tags(nc).TagName = {'evap_dtmin'};
technology.Tags(nc).Description = {'Minimum temperature difference for working fluid at evaporation'};
technology.Tags(nc).DefaultValue = 4;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'DTmin at desuperheating'};
technology.Tags(nc).TagName = {'desuph_dtmin'};
technology.Tags(nc).Description = {'Minimum temperature difference for working fluid at desuperheating'};
technology.Tags(nc).DefaultValue = 2;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'DTmin at desuperheating'};
technology.Tags(nc).TagName = {'cond_dtmin'};
technology.Tags(nc).Description = {'Minimum temperature difference for working fluid at condensation'};
technology.Tags(nc).DefaultValue = 2;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat transfer coefficient of evaporation'};
technology.Tags(nc).TagName = {'h_evap'};
technology.Tags(nc).Description = {'Heat transfer coefficient for evaporating working fluid'}; % this is estimated using the Dittus-Boelter correlation for ammonia evaporating at 5 bar
technology.Tags(nc).DefaultValue = 13;
technology.Tags(nc).Unit = {'kW/m2/K'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat transfer coefficient of desuperheating'};
technology.Tags(nc).TagName = {'h_desuph'};
technology.Tags(nc).Description = {'Heat transfer coefficient for desuperheating working fluid'}; % this is estimated using the Dittus-Boelter correlation for ammonia in gas form at 50C and 12 bar
technology.Tags(nc).DefaultValue = 0.25;
technology.Tags(nc).Unit = {'kW/m2/K'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat transfer coefficient of condensation'};
technology.Tags(nc).TagName = {'h_cond'};
technology.Tags(nc).Description = {'Heat transfer coefficient for condensing working fluid'}; % this is estimated using the Dittus-Boelter correlation for ammonia condensing at 12 bar
technology.Tags(nc).DefaultValue = 13;
technology.Tags(nc).Unit = {'kW/m2/K'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

% Economic parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'Electricity price'};
technology.Tags(nc).TagName = {'elec_price'};
technology.Tags(nc).Description = {'Electricity price from the grid'};
technology.Tags(nc).DefaultValue = 0.15; 
technology.Tags(nc).Unit = {'CHF/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

% LCA parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat pump expected lifetime'};
technology.Tags(nc).TagName = {'hp_lifetime'};
technology.Tags(nc).Description = {'Heat pump expected lifetime'};
technology.Tags(nc).DefaultValue = 50; % this value can be linked to a LCIA parameter defined in the frontend if necessary
technology.Tags(nc).Unit = {'yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Working fluid required per kW'};
technology.Tags(nc).TagName = {'wf_req_kW'};
technology.Tags(nc).Description = {'Working fluid required per kW'};
technology.Tags(nc).DefaultValue = 0.309; % source (ecoinvent)
technology.Tags(nc).Unit = {'kg/kW'}; %kWth -> heat output
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Working fluid loss during operation'};
technology.Tags(nc).TagName = {'wf_loss'};
technology.Tags(nc).Description = {'Working fluid loss during operation, in percentage of the circulating working fluid'};
technology.Tags(nc).DefaultValue = 1.6e-8; % source Bochatay,2005
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Working fluid loss at decommissioning'};
technology.Tags(nc).TagName = {'wf_eol'};
technology.Tags(nc).Description = {'Working fluid loss at decommissioning'};
technology.Tags(nc).DefaultValue = 0.2; % source (Saner et al, 2010 -> for HPs)
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

%% Streams definition
ns=0;
ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','heat_pump','evap','@hp_evap_in_t+273',0,'@hp_evap_out_t+273','@q_evap_load','@evap_dtmin/2','@h_evap'};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','heat_pump','desuph','@hp_comp1_out_t+273','@q_desuph_load','@hp_cond_in_t+273',0,'@desuph_dtmin/2','@h_desuph'};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','heat_pump','cond','@hp_cond_in_t+273','@q_cond_load','@hp_cond_out_t+273',0,'@cond_dtmin/2','@h_cond'};

%% Life Cycle Inventory

nlup=0;
nlce=0;
nlcc=0;

% CONSTRUCTION
nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'working_fluid_initial'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Initial amount of working fluid'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'06017'}; % valid for R134a
technology.LCIA.LCI.UProcess(nlup).Value = {'@heat_pump_mult*(@q_desuph_load + @q_cond_load)*@wf_req_kW'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'trs_wf_initial'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Transport for initial amount of working fluid'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01942'}; 
technology.LCIA.LCI.UProcess(nlup).Value = {'@heat_pump_mult*(@q_desuph_load + @q_cond_load)*@wf_req_kW/1000*50'};  %assumed distance: 50km
technology.LCIA.LCI.UProcess(nlup).Unit = {'tkm'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

% OPERATION
nlce = nlce+1;
technology.LCIA.LCI.EFlows(nlce).TagName = {'working_fluid_loss'};
technology.LCIA.LCI.EFlows(nlce).DisplayName = {'Working fluid loss'};
technology.LCIA.LCI.EFlows(nlce).EFlowID = 2840; % R134a
technology.LCIA.LCI.EFlows(nlce).Value = {'@wf_loss*@hp_evap_out_massf*@heat_pump_mult*@hp_lifetime*@demand_profiles.op_time*3600'};  
technology.LCIA.LCI.EFlows(nlce).Unit = {'kg'};
technology.LCIA.LCI.EFlows(nlce).AddToProblem = 1;
technology.LCIA.LCI.EFlows(nlce).LifeCycleStage = {'O'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'working_fluid_mkup'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Make-up working fluid'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'06017'}; % R134a
technology.LCIA.LCI.UProcess(nlup).Value = {'@wf_loss*@hp_evap_out_massf*@heat_pump_mult*@hp_lifetime*@demand_profiles.op_time*3600'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'trs_wf_mkup'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Transport for make-up working fluid'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01942'}; 
technology.LCIA.LCI.UProcess(nlup).Value = {'@wf_loss*@hp_evap_out_massf*@heat_pump_mult*@hp_lifetime*@demand_profiles.op_time*3600'};  %assumed distance: 50km
technology.LCIA.LCI.UProcess(nlup).Unit = {'tkm'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};
nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'elec_consumed'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Electricity consumed'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'11362'}; % electricity, medium voltage, consumer mix, at grid, CH (this can be changed if a neat power balance is made on overall electricity production)
technology.LCIA.LCI.UProcess(nlup).Value = {'@hp_lifetime*@demand_profiles.op_time*@heat_pump_mult*(@hp_w_power)'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kWh'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};

% DECOMMISSIONING

nlce = nlce+1;
technology.LCIA.LCI.EFlows(nlce).TagName = {'wf_loss_eol'};
technology.LCIA.LCI.EFlows(nlce).DisplayName = {'Working fluid loss at decommissioning'};
technology.LCIA.LCI.EFlows(nlce).EFlowID = 2840; % valid for R134a
technology.LCIA.LCI.EFlows(nlce).Value = {'@heat_pump_mult*(@q_desuph_load + @q_cond_load)*@wf_req_kW*@wf_eol'};  
technology.LCIA.LCI.EFlows(nlce).Unit = {'kg'};
technology.LCIA.LCI.EFlows(nlce).AddToProblem = 1;
technology.LCIA.LCI.EFlows(nlce).LifeCycleStage = {'E'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'trs_wf_eol'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Transport for recycling working fluid'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01942'}; 
technology.LCIA.LCI.UProcess(nlup).Value = {'@heat_pump_mult*(@q_desuph_load + @q_cond_load)*@wf_req_kW*(1-@wf_eol)/1000*50'};  %assumed distance: 50km
technology.LCIA.LCI.UProcess(nlup).Unit = {'tkm'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'E'};

% PROCESS EQUIPMENT

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'compressor'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Compressor of the heat pump'};
technology.LCIA.LCI.Components(nlcc).Type = {'Compressor'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@hp_w_power*@heat_pump_mult'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;

% Heat exchanger network not included in the baseline model!!! (can be 
% taken from EI if necessary, since area is directly calculated)