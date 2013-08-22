function technology = dogger

%% Classification by grouping
technology.Group                      = {'Resources'};       % Frist level of classification 
technology.Type                       = {'Geothermal'};       % Second level of classification 
technology.SubType                    = {'Deep Aquifer'};       % Third level of classification 
  
%% OSMOSE parameters
technology.OSMOSEVersion = {'2.7.8'};
technology.ETVersion = {'2.0.0'};
technology.Version = {'0.8.0'};
  
%% technology detail level
technology.PhysicalRepresentation     = {'1d'};       % Provides information about the level of detail of the technology.

%% Direct access
[path,name,extension] = fileparts(which(mfilename));
technology.FileName                  = {[name,extension],'geo_deep_compute.m'};
technology.MainFile                  = {'geo_deep_compute.m'};
technology.Location                  = {path};
technology.Software                  = {'matlab'};
  
%% User tagging definition
technology.TagName                    = {'dogger'};     % User-defined tag name 
technology.DisplayName                = {'geothermal resource, dogger aquifer CdF'};     % User-defined pretty short name
technology.Description               = {'Model of the Dogger aquifer of La Chaux-de-Fonds'};
%% PinchLight tagging
technology.Keywords(1)          = {' pinchlight:type=resource '};
technology.Keywords(2)          ={'pinchlight:sector=any'}; 
technology.Keywords(3)          = {'pinchlight:subsector=any'}; 
technology.Keywords(4)          = {'pinchlight:technology=geothermal'}; 
technology.Keywords(5)          = {'pinchlight:name=any'}; 
technology.DescriptionImageFileName = {''}; 
technology.Documentation.Url = {''};

%% Technology authoring
ncs=0;
  
ncs=ncs+1;
technology.Changesets(ncs).Id              = 1;         % Changeset identifier (integer)
technology.Changesets(ncs).Author          = {'Gerber Léda'};       % Author's name
technology.Changesets(ncs).Date            = {'17-Feb-2011'};       % Date of changeset
technology.Changesets(ncs).ChangeLog       = {''};       % Text describing the changes
technology.Changesets(ncs).ReferenceId     = {' '};       % Link to references (same DefaultValue as technology.References.Id)
  
technology.References.Id              = [];         % Reference Identifier (integer)
technology.References.Source          = {' '};       % Source of information. Use BibTeX style
technology.References.Comments        = {' '};       % Comments
  
technology.Tags                       = struct;   % This tructure contains all the internal parameters of the model.

%% Material Streams
  
technology.MatStreams                = struct;  % this structure contains information about material streams entering or leaving the technology.
  
%% technology validation
technology.Validation              = struct;    % Contains all the validation fields
technology.Validation.Status       = {'toDo'};      % Validation stage: toDo, Valid, toUpdate, inProgress   --> available states are defined in ET_validationStatus_list.m
technology.Validation.Comments     = {''};      % Any comment about validation can be put here
technology.Validation.Rating       = {' '};      % Provides a rating for the technology. A rating procedure must be defined 

%% Units
nu=0;
  
nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'geo_deep'};
technology.EI.Units(nu).DisplayName = {'geothermal resource deep'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'@geo_volumef_max/@geo_volumef_ref'};
technology.EI.Units(nu).Cost1 = {'0'};
technology.EI.Units(nu).Cost2 = {'@pump_power*3600'};
% technology.EI.Units(nu).Cost2 = {'@pump_power*3600*@demand_profiles.var_elec_price*@demand_profiles.dh_sell_price'};
technology.EI.Units(nu).Cinv1 = {'@inv_costs'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'@pump_power'};

%% Tags definition

% Geothermal resource parameters

nc=0;
nc=nc+1;
technology.Tags(nc).DisplayName = {'Temperature of geothermal water'};
technology.Tags(nc).TagName = {'geo_t'};
technology.Tags(nc).Description = {'Temperature of geothermal water, at well.'};
technology.Tags(nc).DefaultValue = 33; % temperature at well estimated by PDGN,2010
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Depth of the aquifer'};
technology.Tags(nc).TagName = {'geo_z'};
technology.Tags(nc).Description = {'Depth at which is the aquifer'};
technology.Tags(nc).DefaultValue = 900; % estimated by PDGN,2010
technology.Tags(nc).Unit = {'m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Geothermal gradient'};
technology.Tags(nc).TagName = {'geo_grad'};
technology.Tags(nc).Description = {'Average geothermal gradient, considered as linear.'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'C/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Initial temperature of ground at surface'};
technology.Tags(nc).TagName = {'z0_t'};
technology.Tags(nc).Description = {'Initial temperature of ground at surface'};
technology.Tags(nc).DefaultValue = 7; % estimated by PDGN,2010
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Temperature losses in well'};
technology.Tags(nc).TagName = {'geo_t_losses'};
technology.Tags(nc).Description = {'Temperature losses in well, difference between the aquifer temperature and the temperature at well.'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Reference mass flow rate'};
technology.Tags(nc).TagName = {'geo_volumef_ref'};
technology.Tags(nc).Description = {'Reference mass flow rate of geothermal water.'};
technology.Tags(nc).DefaultValue = 20; % estimated by PDGN,2010 - values from 10-20
technology.Tags(nc).Unit = {'l/s'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Maximal mass flow rate'};
technology.Tags(nc).TagName = {'geo_volumef_max'};
technology.Tags(nc).Description = {'Maximal mass flow rate of geothermal water.'};
technology.Tags(nc).DefaultValue = 20 ;
technology.Tags(nc).Unit = {'l/s'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Reference mass flow rate'};
technology.Tags(nc).TagName = {'geo_massf_ref'};
technology.Tags(nc).Description = {'Reference mass flow rate of geothermal water.'};
technology.Tags(nc).DefaultValue = 0; 
technology.Tags(nc).Unit = {'l/s'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Number of wells'};
technology.Tags(nc).TagName = {'n_wells'};
technology.Tags(nc).Description = {'Number of wells that have to be drilled for pumping and reinjection of geothermal water. Each well is at the same depth.'};
technology.Tags(nc).DefaultValue = 2;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Specific heat capacity of geothermal water'};
technology.Tags(nc).TagName = {'geo_cp'};
technology.Tags(nc).Description = {'Specific heat capcacity of geothermal water'};
technology.Tags(nc).DefaultValue = 4.1794; % estimated with RefProp for 33°C, 1 bar
technology.Tags(nc).Unit = {'kJ/kg/C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Density of geothermal water'};
technology.Tags(nc).TagName = {'geo_rho'};
technology.Tags(nc).Description = {'Density of geothermal water'};
technology.Tags(nc).DefaultValue = 994.7; % estimated with RefProp for 33°C, 1 bar
technology.Tags(nc).Unit = {'kg/m3'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat load from geothermal water'};
technology.Tags(nc).TagName = {'geo_load'};
technology.Tags(nc).Description = {'Heat load from geothermal water (is by default set to 0, can be changed if known by the user, which will influe on the reinjection temperature)'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat load from geothermal water'};
technology.Tags(nc).TagName = {'geo_load_calc'};
technology.Tags(nc).Description = {'Heat load from geothermal water, calculated as an output of the model.'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =2;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Temperature of reinjection of geothermal water'};
technology.Tags(nc).TagName = {'geo_inj_t'};
technology.Tags(nc).Description = {'Temperature at which the geothermal water is reinjected in the aquifer'};
technology.Tags(nc).DefaultValue = 5; % estimated by PDGN,2010
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

% Pumping parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'Lower pressure of the pump'};
technology.Tags(nc).TagName = {'pump_lp'};
technology.Tags(nc).Description = {'Lower pressure of the pump'};
technology.Tags(nc).DefaultValue = 1;
technology.Tags(nc).Unit = {'bar'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Higher pressure of the pump'};
technology.Tags(nc).TagName = {'pump_hp'};
technology.Tags(nc).Description = {'Higher pressure of the pump'};
technology.Tags(nc).DefaultValue = 2; % source: Vuataz (email communication)
technology.Tags(nc).Unit = {'bar'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Pump efficiency'};
technology.Tags(nc).TagName = {'pump_eff'};
technology.Tags(nc).Description = {'Efficiency of the pump'};
technology.Tags(nc).DefaultValue = 0.85;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Power for pumping'};
technology.Tags(nc).TagName = {'pump_power'};
technology.Tags(nc).Description = {'Power required for pumping of geothermal water'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =2;

% Energy integration parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'DTmin of geothermal water'};
technology.Tags(nc).TagName = {'geo_dtmin'};
technology.Tags(nc).Description = {'Minimum temperature difference for geothermal water in the heat exchanger'};
technology.Tags(nc).DefaultValue = 2;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat transfer coefficient of geothermal water'};
technology.Tags(nc).TagName = {'geo_h'};
technology.Tags(nc).Description = {'Heat transfer coefficient for geothermal water in the heat exchanger'}; % this is estimated using the Dittus-Boelter correlation for 12.5 kg/s of water at 33°C and 1 bar
technology.Tags(nc).DefaultValue = 0.95;
technology.Tags(nc).Unit = {'kW/m2/K'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

% Economic parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'Investment costs'};
technology.Tags(nc).TagName = {'inv_costs'};
technology.Tags(nc).Description = {'Investment costs for the drilling of wells, having the geothermal resource ready to be exploited.'};
technology.Tags(nc).DefaultValue = 0; 
technology.Tags(nc).Unit = {'CHF'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =2;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Electricity price'};
technology.Tags(nc).TagName = {'elec_price'};
technology.Tags(nc).Description = {'Electricity price from the grid'};
technology.Tags(nc).DefaultValue = 0.15; % source: données Viteos selon Mégel, 2011 
technology.Tags(nc).Unit = {'CHF/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Operating time'};
technology.Tags(nc).TagName = {'op_time'};
technology.Tags(nc).Description = {'Operating time, in hours per year'};
technology.Tags(nc).DefaultValue = 8760; 
technology.Tags(nc).Unit = {'hr/yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Operating costs'};
technology.Tags(nc).TagName = {'op_costs'};
technology.Tags(nc).Description = {'Operating costs, accounting for consumed power for pumping'};
technology.Tags(nc).DefaultValue = 0; 
technology.Tags(nc).Unit = {'CHF/yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =2;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Percentage of success'};
technology.Tags(nc).TagName = {'success'};
technology.Tags(nc).Description = {'Percentage of drilling success and in creating effectively an EGS'};
technology.Tags(nc).DefaultValue = 1; %0-1 
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

% LCA parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'Diesel used for drilling site preparation'};
technology.Tags(nc).TagName = {'drill_site_prep_diesel'};
technology.Tags(nc).Description = {'Diesel used for drilling site preparation'};
technology.Tags(nc).DefaultValue = 20000; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'MJ/site'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Cement used for drilling site preparation'};
technology.Tags(nc).TagName = {'drill_site_prep_cement'};
technology.Tags(nc).Description = {'Cement used for drilling site preparation'};
technology.Tags(nc).DefaultValue = 300; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/site'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Diesel used for drilling rig drive'};
technology.Tags(nc).TagName = {'drill_rig_drive_diesel'};
technology.Tags(nc).Description = {'Diesel used for drilling rig drive'};
technology.Tags(nc).DefaultValue = 7.492; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'MJ/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Diesel used for drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_diesel'};
technology.Tags(nc).Description = {'Diesel used for drilling mud'};
technology.Tags(nc).DefaultValue = 181.3; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'MJ/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Bentonite used for drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_bento'};
technology.Tags(nc).Description = {'Bentonite used for drilling mud'};
technology.Tags(nc).DefaultValue = 7.7; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Starch used for drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_starch'};
technology.Tags(nc).Description = {'Starch used for drilling mud'};
technology.Tags(nc).DefaultValue = 12.8; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Chalk used for drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_chalk'};
technology.Tags(nc).Description = {'Chalk(limestone) used for drilling mud'};
technology.Tags(nc).DefaultValue = 5.4; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Water used for drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_water'};
technology.Tags(nc).Description = {'Water(decarbonized) used for drilling mud'};
technology.Tags(nc).DefaultValue = 671.4; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Calcium carbonate used for drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_calc'};
technology.Tags(nc).Description = {'Calcium carbonate used for drilling mud'};
technology.Tags(nc).DefaultValue = 6.7; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Disposal of cuttings removed by drilling mud'};
technology.Tags(nc).TagName = {'drill_mud_disp'};
technology.Tags(nc).Description = {'Disposal of cuttings removed by drilling mud'};
technology.Tags(nc).DefaultValue = 456; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Steel low-alloyed for casing'};
technology.Tags(nc).TagName = {'casing_steel_low'};
technology.Tags(nc).Description = {'Steel low-alloyed for casing'};
technology.Tags(nc).DefaultValue = 69.1; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Steel high-alloyed for casing'};
technology.Tags(nc).TagName = {'casing_steel_high'};
technology.Tags(nc).Description = {'Steel high-alloyed for casing'};
technology.Tags(nc).DefaultValue = 34; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Bentonite for cementation'};
technology.Tags(nc).TagName = {'cement_bento'};
technology.Tags(nc).Description = {'Bentonite for cementation'};
technology.Tags(nc).DefaultValue = 0.2; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Portland limestone cement for cementation'};
technology.Tags(nc).TagName = {'cement_portland'};
technology.Tags(nc).Description = {'Portland limestone cement for cementation'};
technology.Tags(nc).DefaultValue = 23.5; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Silica sand for cementation'};
technology.Tags(nc).TagName = {'cement_sand'};
technology.Tags(nc).Description = {'Silica sand for cementation'};
technology.Tags(nc).DefaultValue = 7; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Cement unspecified for cementation'};
technology.Tags(nc).TagName = {'cement_cement'};
technology.Tags(nc).Description = {'Cement unspecified for cementation'};
technology.Tags(nc).DefaultValue = 7.3; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Water for cementation'};
technology.Tags(nc).TagName = {'cement_water'};
technology.Tags(nc).Description = {'Water(decarbonized) for cementation'};
technology.Tags(nc).DefaultValue = 16.9; % source (Frick et al, 2010)

technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Transport by lorry linked with construction'};
technology.Tags(nc).TagName = {'trs_constr_lorry'};
technology.Tags(nc).Description = {'Transport by lorry linked with construction'};
technology.Tags(nc).DefaultValue = 144*10^3; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'tkm/well'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Transport by rail linked with construction'};
technology.Tags(nc).TagName = {'trs_constr_rail'};
technology.Tags(nc).Description = {'Transport by rail linked with construction'};
technology.Tags(nc).DefaultValue = 413*10^3; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'tkm/well'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'DA expected lifetime'};
technology.Tags(nc).TagName = {'da_lifetime'};
technology.Tags(nc).Description = {'DA expected lifetime'};
technology.Tags(nc).DefaultValue = 50; % this value can be linked to a LCIA parameter defined in the frontend if necessary
technology.Tags(nc).Unit = {'yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Transport for residues disposal'};
technology.Tags(nc).TagName = {'op_disp_lorry'};
technology.Tags(nc).Description = {'Transport for residues and scaling disposal during operation'};
technology.Tags(nc).DefaultValue = 0; % to be completed with accurate data!
technology.Tags(nc).Unit = {'tkm/yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Disposal of residues'};
technology.Tags(nc).TagName = {'op_disp_landfill'};
technology.Tags(nc).Description = {'Disposal of residues and scalin in sanitary landfill during operation'};
technology.Tags(nc).DefaultValue = 0; % % to be completed with accurate data!
technology.Tags(nc).Unit = {'kg/yr*m3/h'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Gravel required for dismantling'};
technology.Tags(nc).TagName = {'disp_gravel'};
technology.Tags(nc).Description = {'Gravel required for dismantling'};
technology.Tags(nc).DefaultValue = 51.1; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Cement required for dismantling'};
technology.Tags(nc).TagName = {'disp_cement'};
technology.Tags(nc).Description = {'Cement required for dismantling'};
technology.Tags(nc).DefaultValue = 4.9; % source (Frick et al, 2010)
technology.Tags(nc).Unit = {'kg/m'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

%% Streams definition
ns=0;
ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','geo_deep','geo_heat','@geo_t+273','@geo_load_calc','@geo_inj_t+273',0,'@geo_dtmin/2','@geo_h'};

%% Life Cycle Inventory
% Remark: it is assumed that a proper environmental management of the used
% geofluid is implemented and that it is reinjected. If this is not the
% case, this inventory should be completed with emissions of pollutants in
% water or in soil. Emissions in the air are assumed to be zero in the
% construction phase, since temperature of the geofluid is likely to be >
% 100C in Swiss conditions. If this is not the case, this should be
% accounated for by changing the emissions factors with accurate data.

nlup=0;
nlce=0;
nlcc=0;

% EXPLORATION, DRILLING, CASING, ENHANCEMENT PHASE (CONSTRUCTION)

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_site_prep_diesel'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Diesel used for drilling site preparation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00559'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_site_prep_diesel'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'MJ'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_site_prep_cement'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Cement used for drilling site preparation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00484'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_site_prep_cement'};
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_rig_drive_diesel'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Diesel used for drilling rig drive'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00559'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_rig_drive_diesel*@geo_z*@n_wells'};
technology.LCIA.LCI.UProcess(nlup).Unit = {'MJ'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_diesel'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Diesel used for drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00559'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_diesel*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'MJ'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_bento'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Bentonite used for drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00459'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_bento*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_starch'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Starch used for drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'10457'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_starch*@geo_z*@n_wells/@success'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_chalk'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Chalk used for drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00468'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_chalk*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_water'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Water used for drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'02291'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_water*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_calc'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Calcium carbonate used for drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00468'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_calc*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'drill_mud_disp'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Disposal of cuttings removed by drilling mud'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'02221'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@drill_mud_disp*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'casing_steel_low'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Steel low-alloyed for casing'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01154'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@casing_steel_low*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'casing_steel_high'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Steel high-alloyed for casing'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01072'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@casing_steel_high*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'cement_bento'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Bentonite used for cementation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00459'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@cement_bento*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'cement_portland'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Portland limestone cement used for cementation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00489'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@cement_portland*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'cement_sand'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Silica sand used for cementation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00479'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@cement_sand*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'cement_cement'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Cement unspecified used for cementation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00484'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@cement_cement*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'cement_water'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Water used for cementation'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'02291'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@cement_water*@geo_z*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'trs_constr_lorry'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Transport by lorry linked with construction'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01942'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@trs_constr_lorry*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'tkm'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'trs_constr_rail'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Transport by rail linked with construction'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01983'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@trs_constr_rail*@n_wells'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'tkm'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'C'};

% OPERATION

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'op_elec_pump'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Electricity consumed for the downhole pump'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'11362'}; % electricity, medium voltage, consumer mix, at grid, CH (this can be changed if a neat power balance is made on overall electricity production and that power is produced from the DA)
technology.LCIA.LCI.UProcess(nlup).Value = {'@da_lifetime*@demand_profiles.op_time*@pump_power*@geo_deep_mult'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kWh'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};

% DECOMMISSIONING
nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'disp_gravel'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Gravel required for disposal'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00465'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@disp_gravel*@n_wells*@geo_z'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'E'};

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'disp_cement'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Cement required for disposal'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'00484'};
technology.LCIA.LCI.UProcess(nlup).Value = {'@disp_cement*@n_wells*@geo_z'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'kg'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'E'};

% PROCESS EQUIPMENT

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'pump'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Pump for extraction'};
technology.LCIA.LCI.Components(nlcc).Type = {'Pump'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@pump_power*@geo_deep_mult'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).Data.Pressure = {'@pump_hp'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Pressure = {'bar'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;
