function technology = electricity_production_muschelkalk_wood_steam
%% OSMOSE parameters
technology.OSMOSEVersion = {'2.7.8'};
technology.ETVersion = {'2.0.0'};
technology.Version = {'0.8.0'};

%% Direct access
[path,name,extension] = fileparts(which(mfilename));
technology.FileName                  = {[name,extension],'rankine_cycle_compute.bls'};
technology.MainFile                  = {'rankine_cycle_compute.bls'};
technology.Location                  = {path};
technology.Software                  = {'vali'};
technology.PreModelMFunction         = {'geo_deep_compute','cridor_compute','demand_profiles_compute','Rankine_PreCompute','debrosse_compute'};   
technology.PostEIMFunction                  = {'CdF_PostCompute_cogen_wood'};
technology.PostMultiperiodMFunction                   = {'CdF_PostMultiPeriod_cogen_wood'};
  
%% User tagging definition
technology.TagName                    = {'elec_prod'};     % User-defined tag name 
technology.DisplayName                = {'Group for electricity production'};     % User-defined pretty short name
technology.Description               = {'Group for electricity production (Steam cycle, Muschelkalk, Wood, Cold source, Cridor, GN boiler, DHN)'};     % Short paragraph containing the technology description

%% Groups
ng=0;

ng = ng+1;
technology.EI.Groups(ng).Type = {''};
technology.EI.Groups(ng).TagName = {'utilities'};
technology.EI.Groups(ng).DisplayName = {'utilities'};
technology.EI.Groups(ng).AddToProblem =  1;
technology.EI.Groups(ng).Parent =  {'main'};
technology.EI.Groups(ng).IsANode =  1;

ng = ng+1;
technology.EI.Groups(ng).Type = {''};
technology.EI.Groups(ng).TagName = {'steam'};
technology.EI.Groups(ng).DisplayName = {'steam'};
technology.EI.Groups(ng).AddToProblem =  1;
technology.EI.Groups(ng).Parent =  {'main'};
technology.EI.Groups(ng).IsANode =  1;

ng = ng+1;
technology.EI.Groups(ng).Type = {''};
technology.EI.Groups(ng).TagName = {'dhn'};
technology.EI.Groups(ng).DisplayName = {'dhn'};
technology.EI.Groups(ng).AddToProblem =  1;
technology.EI.Groups(ng).Parent =  {'main'};
technology.EI.Groups(ng).IsANode =  0;

ng = ng+1;
technology.EI.Groups(ng).Type = {''};
technology.EI.Groups(ng).TagName = {'demand_dh'};
technology.EI.Groups(ng).DisplayName = {'demand_dh'};
technology.EI.Groups(ng).AddToProblem =  1;
technology.EI.Groups(ng).Parent =  {'main'};
technology.EI.Groups(ng).IsANode =  1;

%% Units
nu=0;
  
nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'steam_network'};
technology.EI.Units(nu).DisplayName = {'Steam network'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent = {'steam'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'1'};
technology.EI.Units(nu).Cost1 = {'0'};
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'-100000'};
technology.EI.Units(nu).Cost2 = {'@rnk_w4_power + @rnk_w5_power + @rnk_w6_power - (@rnk_w1_power-@rnk_w2_power-@rnk_w3_power)*3600*1'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'@rnk_w4_power + @rnk_w5_power + @rnk_w6_power - (@rnk_w1_power-@rnk_w2_power-@rnk_w3_power)'};
% technology.EI.Units(nu).HeadersMaxNumber = {'@HeadersMaxNumber'};
% technology.EI.Units(nu).TurbPowerMin = {'@TurbPowerMin'};
% technology.EI.Units(nu).TurbPowerMax = {'@TurbPowerMax'};
% technology.EI.Units(nu).TurbBackPressEff = {'@TurbBackPressEff'};
% technology.EI.Units(nu).TurbCondEff = {'@TurbCondEff'};
% technology.EI.Units(nu).PumpEff = {'@PumpEff'};

nu = nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'wood_boiler_debrosse'};
technology.EI.Units(nu).DisplayName = {'wood_boiler_debrosse'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent = {'steam'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'@wood_resources_factor'}; %if this represents the actual wood boiler,
%then Fmax = 4000 and investment cost = 0 
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'0.06/0.95 * 3600 * @heat_load'}; % CHF/kW, 0.06 and 95% efficiency based on Luc's report
%technology.EI.Units(nu).Cost2 = {'100'};
technology.EI.Units(nu).Cost2 = {'0.06/0.95 * 3600 * @debrosse_load'};
%this assumption is OK (higher efficiency than gas) since we consider it
%will be operating in a steady state mode
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

nu = nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'wood_boiler'};
technology.EI.Units(nu).DisplayName = {'wood_boiler'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent = {'utilities'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'1'}; %if this represents the actual wood boiler,
%then Fmax = 4000 and investment cost = 0 
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'0.06/0.95 * 3600 * @heat_load'}; % CHF/kW, 0.06 and 95% efficiency based on Luc's report
%technology.EI.Units(nu).Cost2 = {'100'};
technology.EI.Units(nu).Cost2 = {'0.06/0.95 * 3600 * @heat_load'};
%this assumption is OK (higher efficiency than gas) since we consider it
%will be operating in a steady state mode
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'geo_deep'};
technology.EI.Units(nu).DisplayName = {'geothermal resource deep'};
technology.EI.Units(nu).Parent = {'steam'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'@geo_volumef_max/@geo_volumef_ref'};
technology.EI.Units(nu).Cost1 = {'0'};
% technology.EI.Units(nu).Cost2 = {'@pump_power*3600*0.01'};
% technology.EI.Units(nu).Cost2 = {'0'};
technology.EI.Units(nu).Cost2 = {'@pump_power*3600*0.15'};
technology.EI.Units(nu).Cinv1 = {'@inv_costs'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'@pump_power'};

nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'cold_source'};
technology.EI.Units(nu).DisplayName = {'cold source'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent = {'steam'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'1'};
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'100'};
technology.EI.Units(nu).Cost2 = {'10'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'heat_cridor'};
technology.EI.Units(nu).DisplayName = {'Heat supplied by Cridor'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent =  {'utilities'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'1'};
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'-1000'};
technology.EI.Units(nu).Cost2 = {'0'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

nu = nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'gas_boiler'};
technology.EI.Units(nu).DisplayName = {'gas_boiler'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent =  {'utilities'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'540000'};
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'0.11/0.82 * 3600 * 0.01'}; % CHF/kWh
%technology.EI.Units(nu).Cost2 = {'100'};
technology.EI.Units(nu).Cost2 = {'0.11/0.82*3600*@power'};
% first 2 numbers are for gas cost and CO2 tax
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

nu=nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'dh_network'};
technology.EI.Units(nu).DisplayName = {'district heating network'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent =  {'dhn'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'1000'};
technology.EI.Units(nu).Cost1 = {'0'};
%technology.EI.Units(nu).Cost2 = {'-10000'};
technology.EI.Units(nu).Cost2 = {'0'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

nu=nu+1;
technology.EI.Units(nu).Type = {'process'};
technology.EI.Units(nu).TagName = {'demand_district_heating'};
technology.EI.Units(nu).DisplayName = {'district heating demand'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).Parent =  {'demand_dh'};
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'0'};
technology.EI.Units(nu).Cost1 = {'0'};
technology.EI.Units(nu).Cost2 = {'0'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};

%% Tags definition

% Steam network
nc=0;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Steam production temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_3_t'};
technology.Tags(nc).DefaultValue = 255;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Superheating temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_4_t'};
technology.Tags(nc).DefaultValue = 300;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'DT superheating'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'dt_rnk_supheat'};
technology.Tags(nc).DefaultValue = 55;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Draw-off 1 temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_14_t'};
technology.Tags(nc).DefaultValue = 100;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Resuperheating 1 temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_8_t'};
technology.Tags(nc).DefaultValue = 310;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'DT resuperheating 1'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'dt_rnk_resupheat1'};
technology.Tags(nc).DefaultValue = 15;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Draw-off 2 temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_18_t'};
technology.Tags(nc).DefaultValue = 82;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Resuperheating 2 temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_12_t'};
technology.Tags(nc).DefaultValue = 320;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'DT resuperheating 2'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'dt_rnk_resupheat2'};
technology.Tags(nc).DefaultValue = 0;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Condensation temperature'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'rnk_16_t'};
technology.Tags(nc).DefaultValue = 14;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Splitting fraction for draw-off 1 (for DH)'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'s_1_frac1'};
technology.Tags(nc).DefaultValue = 0.45;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Splitting fraction for draw-off 2 (for DH)'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'s_2_frac1'};
technology.Tags(nc).DefaultValue = 0.35;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Heat load wood boiler'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'heat_load'};
technology.Tags(nc).DefaultValue = 1000;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Wood resources factor'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'wood_resources_factor'};
technology.Tags(nc).DefaultValue = 0.2358; % 1 if normal resources, 1.2358 if bois de débrosse are used
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'wood_price'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'wood_price'};
technology.Tags(nc).DefaultValue = 6.32; % source: Mégel, 2011
technology.Tags(nc).Unit = {'cts/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'en_eff_wood'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'en_eff_wood'};
technology.Tags(nc).DefaultValue = 0.95; % source: Mégel, 2011
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Period for debrosse use'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'debrosse_p'};
technology.Tags(nc).DefaultValue = 1;
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Debrosse wood availability'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'debrosse_av'};
technology.Tags(nc).DefaultValue = 3600000;
technology.Tags(nc).Unit = {'kWh/yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'Debrosse heat load'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'debrosse_load'};
technology.Tags(nc).DefaultValue = 4000;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Temperature of geothermal water'};
technology.Tags(nc).TagName = {'geo_t'};
technology.Tags(nc).Description = {'Temperature of geothermal water, at well.'};
technology.Tags(nc).DefaultValue = 51; % temperature at well estimated by PDGN,2010
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Depth of the aquifer'};
technology.Tags(nc).TagName = {'geo_z'};
technology.Tags(nc).Description = {'Depth at which is the aquifer'};
technology.Tags(nc).DefaultValue = 1450; % estimated by PDGN,2010
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
technology.Tags(nc).DefaultValue = 15; % estimated by PDGN,2010 - values from 10-15
technology.Tags(nc).Unit = {'l/s'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Maximal mass flow rate'};
technology.Tags(nc).TagName = {'geo_volumef_max'};
technology.Tags(nc).Description = {'Maximal mass flow rate of geothermal water.'};
technology.Tags(nc).DefaultValue = 15 ;
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
technology.Tags(nc).DefaultValue = 4.1816; % estimated with RefProp for 51°C, 1 bar
technology.Tags(nc).Unit = {'kJ/kg/C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Density of geothermal water'};
technology.Tags(nc).TagName = {'geo_rho'};
technology.Tags(nc).Description = {'Density of geothermal water'};
technology.Tags(nc).DefaultValue = 987.58; % estimated with RefProp for 51°C, 1 bar
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
technology.Tags(nc).DefaultValue = 30; % estimated by PDGN,2010
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
technology.Tags(nc).DefaultValue = 7; % data from Riehen (Grass et al, 2008)
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
technology.Tags(nc).Description = {'Heat transfer coefficient for geothermal water in the heat exchanger'}; % this is estimated using the Dittus-Boelter correlation for 12.5 kg/s of water at 51°C and 1 bar
technology.Tags(nc).DefaultValue = 1.27;
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

nc=nc+1;
technology.Tags(nc).DisplayName = {'Cold source inlet temperature'};
technology.Tags(nc).TagName = {'cold_t_in'};
technology.Tags(nc).Description = {'Cold source inlet temperature'};
technology.Tags(nc).DefaultValue = 10;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Cold source outlet temperature'};
technology.Tags(nc).TagName = {'cold_t_out'};
technology.Tags(nc).Description = {'Cold source outlet temperature'};
technology.Tags(nc).DefaultValue = 10;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat load transfered to cold source'};
technology.Tags(nc).TagName = {'cold_load'};
technology.Tags(nc).Description = {'Heat load transfered to cold source'};
technology.Tags(nc).DefaultValue = 10000;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =2;

nc=nc+1;
technology.Tags(nc).DisplayName = {'DTmin cold source'};
technology.Tags(nc).TagName = {'dtmin'};
technology.Tags(nc).Description = {'DTmin cold source'};
technology.Tags(nc).DefaultValue = 2;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Available heat from steam'};
technology.Tags(nc).TagName = {'Q_av'};
technology.Tags(nc).Description = {'Available heat from steam'};
technology.Tags(nc).DefaultValue = 17600; % taken from Mégel, 2011
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat transfered to DHN'};
technology.Tags(nc).TagName = {'Q_dhn'};
technology.Tags(nc).Description = {'Heat transfered to district heating network'};
technology.Tags(nc).DefaultValue = 5000; 
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Electricity produced by turbine'};
technology.Tags(nc).TagName = {'E_prod'};
technology.Tags(nc).Description = {'Electricity produced by turbine'};
technology.Tags(nc).DefaultValue = 2500; % turbine maximum capacity
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Turbine efficiency'};
technology.Tags(nc).TagName = {'eff_elec'};
technology.Tags(nc).Description = {'Turbine efficiency'};
technology.Tags(nc).DefaultValue = 0.31; % taken from Mégel, 2011
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat losses'};
technology.Tags(nc).TagName = {'Q_loss'};
technology.Tags(nc).Description = {'Heat losses'};
technology.Tags(nc).DefaultValue = 0; 
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Steam temperature'};
technology.Tags(nc).TagName = {'steam_t'};
technology.Tags(nc).Description = {'Steam temperature'};
technology.Tags(nc).DefaultValue = 390; 
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Operating costs'};
technology.Tags(nc).TagName = {'op_cost'};
technology.Tags(nc).Description = {'Operating costs'};
technology.Tags(nc).DefaultValue = 0.0356; 
technology.Tags(nc).Unit = {'CHF/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'gas_boiler'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'power'};
technology.Tags(nc).DefaultValue = 1;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'ng_price'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'ng_price'};
technology.Tags(nc).DefaultValue = 11.61; % source: Mégel, 2011
technology.Tags(nc).Unit = {'cts/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc = nc+1;
technology.Tags(nc).DisplayName = {'en_eff_ng'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'en_eff_ng'};
technology.Tags(nc).DefaultValue = 0.82; % source: Mégel, 2011
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Aquifer used as hot source'};
technology.Tags(nc).TagName = {'hot_source'};
technology.Tags(nc).Description = {'Aquifer used as hot source'};
technology.Tags(nc).DefaultValue = 2; % 1 is for Dogger, 2 is for Muschelkalk
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'-'};
technology.Tags(nc).isVIT =1;

% District heating network parameters

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating return temperature'};
technology.Tags(nc).TagName = {'dhn_ret_t'};
technology.Tags(nc).Description = {'District heating return temperature'};
technology.Tags(nc).DefaultValue = 58;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating feeding temperature'};
technology.Tags(nc).TagName = {'dhn_fed_t'};
technology.Tags(nc).Description = {'District heating feeding temperature'};
technology.Tags(nc).DefaultValue = 90;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating load'};
technology.Tags(nc).TagName = {'dhn_load'};
technology.Tags(nc).Description = {'District heating load'};
technology.Tags(nc).DefaultValue = 0; % to be calculated
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Heat losses'};
technology.Tags(nc).TagName = {'losses'};
technology.Tags(nc).Description = {'Heat losses in district heating network, in percentage'};
technology.Tags(nc).DefaultValue = 0.08; % Mégel, 2011
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'DTmin district heating'};
technology.Tags(nc).TagName = {'dtmin_dh'};
technology.Tags(nc).Description = {'DTmin district heating'};
technology.Tags(nc).DefaultValue = 2;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Multiplying factor for DHN'};
technology.Tags(nc).TagName = {'mult_fact'};
technology.Tags(nc).Description = {'Multiplying factor for DHN from composite curves'};
technology.Tags(nc).DefaultValue = 5.89; % Mégel, 2011 % 5.89
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

% Parameters of the demand in district heating
nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating return temperature'};
technology.Tags(nc).TagName = {'dh_ret_t1'};
technology.Tags(nc).Description = {'District heating return temperature'};
technology.Tags(nc).DefaultValue = 50;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating feeding temperature'};
technology.Tags(nc).TagName = {'dh_fed_t1'};
technology.Tags(nc).Description = {'District heating feeding temperature'};
technology.Tags(nc).DefaultValue = 60;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating load'};
technology.Tags(nc).TagName = {'dh_load1'};
technology.Tags(nc).Description = {'District heating load'};
technology.Tags(nc).DefaultValue = 100;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating return temperature'};
technology.Tags(nc).TagName = {'dh_ret_t2'};
technology.Tags(nc).Description = {'District heating return temperature'};
technology.Tags(nc).DefaultValue = 40;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating feeding temperature'};
technology.Tags(nc).TagName = {'dh_fed_t2'};
technology.Tags(nc).Description = {'District heating feeding temperature'};
technology.Tags(nc).DefaultValue = 50;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating load'};
technology.Tags(nc).TagName = {'dh_load2'};
technology.Tags(nc).Description = {'District heating load'};
technology.Tags(nc).DefaultValue = 3000;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating return temperature'};
technology.Tags(nc).TagName = {'dh_ret_t3'};
technology.Tags(nc).Description = {'District heating return temperature'};
technology.Tags(nc).DefaultValue = 10;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating feeding temperature'};
technology.Tags(nc).TagName = {'dh_fed_t3'};
technology.Tags(nc).Description = {'District heating feeding temperature'};
technology.Tags(nc).DefaultValue = 40;
technology.Tags(nc).Unit = {'C'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating load'};
technology.Tags(nc).TagName = {'dh_load3'};
technology.Tags(nc).Description = {'District heating load'};
technology.Tags(nc).DefaultValue = 200;
technology.Tags(nc).Unit = {'kW'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Conversion factor USD to CHF'};
technology.Tags(nc).TagName = {'conv_usd2chf'};
technology.Tags(nc).Description = {'Conversion factor for USD to CHF'};
technology.Tags(nc).DefaultValue = 1.002; 
technology.Tags(nc).Unit = {'CHF'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Salary per capita'};
technology.Tags(nc).TagName = {'salary'};
technology.Tags(nc).Description = {'Yearly salary of one operator'};
technology.Tags(nc).DefaultValue = 60000; 
technology.Tags(nc).Unit = {'CHF/yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Number of operators'};
technology.Tags(nc).TagName = {'n_operators'};
technology.Tags(nc).Description = {'Number of operators'};
technology.Tags(nc).DefaultValue = 1; 
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Lifetime'};
technology.Tags(nc).TagName = {'lifetime'};
technology.Tags(nc).Description = {'Lifetime, used for economic calculations'};
technology.Tags(nc).DefaultValue = 50; % source: Mégel, 2011
technology.Tags(nc).Unit = {'yr'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Interest rate'};
technology.Tags(nc).TagName = {'ir'};
technology.Tags(nc).Description = {'Interest rate'};
technology.Tags(nc).DefaultValue = 0.08; % source: Mégel, 2011
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'District heating selling price'};
technology.Tags(nc).TagName = {'dh_sell_price'};
technology.Tags(nc).Description = {'District heating selling price to the consumer'};
technology.Tags(nc).DefaultValue = 0.1;  % source: Mégel, 2011
technology.Tags(nc).Unit = {'CHF/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Integer decision for variable electricity price'};
technology.Tags(nc).TagName = {'var_elec_price'};
technology.Tags(nc).Description = {'Integer decision for variable electricity price'};
technology.Tags(nc).DefaultValue = 0; % 1 = variable, 0 = fixed above
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Ratio between electricity and heat price'};
technology.Tags(nc).TagName = {'elec_price_ratio'};
technology.Tags(nc).Description = {'Ratio between electricity and heat price'};
technology.Tags(nc).DefaultValue = 5; 
technology.Tags(nc).Unit = {'CHF'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =3;

nc=nc+1;
technology.Tags(nc).DisplayName = {'Electricity price Cridor'};
technology.Tags(nc).TagName = {'elec_price_cridor'};
technology.Tags(nc).Description = {'Electricity price, sellings from Cridor'};
technology.Tags(nc).DefaultValue = 26.58; % source: tarifs viteos 2011
technology.Tags(nc).Unit = {'cts/kWh'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT =1;

%% Streams definition
ns=0;

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','preheat1','@rnk_19_t+273','0','@rnk_21_t+273','@rnk_preheat3_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','preheat2','@rnk_18_t+273','0','@rnk_20_t+273','@rnk_preheat2_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','preheat3','@rnk_1_t+273','0','@rnk_2_t+273','@rnk_preheat_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','evap','@rnk_2_t+273','0','@rnk_3_t+273','@rnk_evap_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','supheat','@rnk_3_t+273','0','@rnk_4_t+273','@rnk_supheat_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','resupheat1','@rnk_7_t+273','0','@rnk_8_t+273','@rnk_resupheat_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','resupheat2','@rnk_11_t+273','0','@rnk_12_t+273','@rnk_resupheat2_load',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','drawoff1','@rnk_6_t+273','@rnk_dr1_load','@rnk_14_t+273','0',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','drawoff2','@rnk_24_t+273','@rnk_dr2_load','@rnk_15_t+273','0',1};

% ns = ns+1;
% technology.EI.Streams(ns).Short = {'qt','steam_network','drawoff2_1','@rnk_10_t+273','@rnk_dr3_load','@rnk_24_t+273','0',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','steam_network','condensation','@rnk_25_t+273','@rnk_c1_load','@rnk_16_t+273','0',1};

% ns = ns+1;
% technology.EI.Streams(ns).Short = {'qt','steam_network','condensation_1','@rnk_13_t+273','@rnk_dr4_load','@rnk_25_t+273','0',1};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','wood_boiler','wood_boiler_actual','1300','@heat_load','100+273.15','0',4};

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','wood_boiler_debrosse','wood_boiler_steam','1300','@debrosse_load','100+273.15','0',4};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','geo_deep','geo_heat','@geo_t+273','@geo_load_calc','@geo_inj_t+273',0,'@geo_dtmin/2','@geo_h'};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','cold_source','cold_source_load','@cold_t_in+273',0,'@cold_t_out+273','@cold_load','@dtmin/2'};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','heat_cridor','dhn_cridor','150+273','@Q_dhn','100+273',0,4}; % values taken from Mégel, 2011

ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','gas_boiler','gas_boilerst','150+273.15','@power','100+273.15','0',4};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','dh_network','dhn_load','@dhn_ret_t+273',0,'@dhn_fed_t+273','@dhn_load',4};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','dh_network','dhn_sink','@dhn_fed_t+273','@dhn_load','@dhn_ret_t+273',0,4};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','demand_district_heating','dh_load1','@dh_ret_t1+273',0,'@dh_fed_t1+273','@dh_load1',2};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','demand_district_heating','dh_load2','@dh_ret_t2+273',0,'@dh_fed_t2+273','@dh_load2',2};

ns=ns+1;
technology.EI.Streams(ns).Short = {'qt','demand_district_heating','dh_load3','@dh_ret_t3+273',0,'@dh_fed_t3+273','@dh_load3',2};

%% Life Cycle Inventory

nlup=0;
nlce=0;
nlcc=0;

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'wood_burned'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Wood burned in boiler'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'02424'}; % wood chips, from forest, mixed, burned in furnace 1000 kW
technology.LCIA.LCI.UProcess(nlup).Value = {'@heat_load/@en_eff_wood*@demand_profiles.op_time*@wood_boiler_mult*@demand_profiles.lifetime*3.6'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'MJ'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};

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

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'nat_gas'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Natural gas burned in boiler'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01362'}; % natural gas, burned in boiler modulating > 100 kW
technology.LCIA.LCI.UProcess(nlup).Value = {'@power/@en_eff_ng*@demand_profiles.op_time*3.6*@gas_boiler_mult*@demand_profiles.lifetime'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'MJ'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};

% PROCESS EQUIPMENT

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'turbine'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Turbine'};
technology.LCIA.LCI.Components(nlcc).Type = {'Turbine'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@orc_mult*@orc_wprod_power'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'pump'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Pump'};
technology.LCIA.LCI.Components(nlcc).Type = {'Pump'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@orc_mult*@orc_wcons_power'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).Data.Pressure = {'@orc_wf1_p'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Pressure = {'bar'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'wood_boiler'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Wood boiler'};
technology.LCIA.LCI.Components(nlcc).Type = {'Boiler'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@heat_load*@wood_boiler_mult'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'pump'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Pump for extraction'};
technology.LCIA.LCI.Components(nlcc).Type = {'Pump'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@pump_power*@geo_deep_mult'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).Data.Pressure = {'@pump_hp'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Pressure = {'bar'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'gas_boiler'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Gas boiler'};
technology.LCIA.LCI.Components(nlcc).Type = {'Boiler'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@power*@gas_boiler_mult'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;

% Heat exchanger network not included in the baseline model!!! (can be 
% taken from EI if necessary, since area is directly calculated)
