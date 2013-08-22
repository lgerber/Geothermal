function technology = gas_boiler
% 
% 
% 
% $Id: EI_problem_1s.m 191 2008-03-28 13:05:08Z bolliger $
% -------------------------------------------------------------------------


%% Classification by grouping
technology.Group                      = {'Other'};       % Frist level of classification
technology.Type                       = {'utility'};       % Second level of classification
technology.SubType                    = {''};       % Third level of classification

%% OSMOSE parameters
technology.OSMOSEVersion = {'2.7.8'};
technology.ETVersion = {'2.0.0'};
technology.Version = {'0.8.1'};

%% technology detail level
technology.PhysicalRepresentation     = {'1d'};       % Provides information about the level of detail of the technology.

%% Direct access
[path,name,extension] = fileparts(which(mfilename));
technology.FileName                  = {[name,extension]};        % Direct access method
technology.Location                  = {path};
technology.Software                  = {'matlab'};

%
%% User tagging
technology.TagName                    = {'gas_boiler'};       % User-defined tag name
technology.DisplayName                = {'gas_boiler'};       % User-defined pretty short name
technology.Description                = {'represents dhn gas boiler'};       % Short paragraph containing the technology description

%% PinchLight Tagging
technology.Keywords(1)          = {'pinchlight:type=process'};
technology.Keywords(2)          = {'pinchlight:sector=any'};
technology.Keywords(3)          = {'pinchlight:subsector=any'};
technology.Keywords(4)          = {'pinchlight:technology=any'};
technology.Keywords(5)          = {'pinchlight:name=blackbox'};
technology.DescriptionImageFileName = {''};
technology.Documentation.Url = {''};

%% Technology authoring

technology.Changesets.Id              = [1];         % Changeset identifier (integer)
technology.Changesets.Author          = {'Olivier Megel'};       % Author's name
technology.Changesets.Date            = {'20-dec-2010'};       % Date of changeset
technology.Changesets.ChangeLog       = {''};       % Text describing the changes
technology.Changesets.ReferenceId     = {''};       % Link to references (same DefaultValue as technology.References.Id)

technology.References.Id              = [];         % Reference Identifier (integer)
technology.References.Source          = {''};       % Source of information. Use BibTeX style
technology.References.Comments        = {''};       % Comments

technology.Tags                       = struct;   % This tructure contains all the internal parameters of the model.

%% Material Streams

technology.MatStreams                = struct;  % this structure contains information about materail streams entering or leaving the technology.
 
%% technology validation
technology.Validation              = struct;    % Contains all the validation fields
technology.Validation.Status       = {'toDo'};      % Validation stage: toDo, Valid, toUpdate, inProgress   --> available states are defined in ET_validationStatus_list.m
technology.Validation.Comments     = {''};      % Any comment about validation can be put here
technology.Validation.Rating       = {''};      % Provides a rating for the technology. A rating procedure must be defined 




%% Units
nu = 0;
ns = 0;
nc = 0;


nu = nu+1;
technology.EI.Units(nu).Type = {'utility'};
technology.EI.Units(nu).TagName = {'gas_boiler'};
technology.EI.Units(nu).DisplayName = {'gas_boiler'};
technology.EI.Units(nu).AddToProblem =  1;
technology.EI.Units(nu).ITY = {'0'};
technology.EI.Units(nu).Fmin = {'0'};
technology.EI.Units(nu).Fmax = {'100000'};
technology.EI.Units(nu).Cost1 = {'0'};
% technology.EI.Units(nu).Cost2 = {'3600*@power*@ng_price'}; % CHF/kWh
% first 2 numbers are for gas cost and CO2 tax
technology.EI.Units(nu).Cost2 = {'10000'};
technology.EI.Units(nu).Cinv1 = {'0'};
technology.EI.Units(nu).Cinv2 = {'0'};
technology.EI.Units(nu).Power1 = {'0'};
technology.EI.Units(nu).Power2 = {'0'};


%% Tags
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
technology.Tags(nc).DisplayName = {'en_eff'};
technology.Tags(nc).Description = technology.Tags(nc).DisplayName;
technology.Tags(nc).TagName = {'en_eff'};
technology.Tags(nc).DefaultValue = 0.82; % source: Mégel, 2011
technology.Tags(nc).Unit = {'-'};
technology.Tags(nc).Status = {'CST'};
technology.Tags(nc).isVIT = 1;

%% Streams
ns = 0;
ns = ns+1;
technology.EI.Streams(ns).Short = {'qt','gas_boiler','gas_boilerst','150+273.15','@power','100+273.15','0',4};
%Dtmin/2 OK ici

%% Life Cycle Inventory

nlup=0;
nlce=0;
nlcc=0;

nlup = nlup+1;
technology.LCIA.LCI.UProcess(nlup).TagName = {'nat_gas'};
technology.LCIA.LCI.UProcess(nlup).DisplayName = {'Natural gas burned in boiler'};
technology.LCIA.LCI.UProcess(nlup).UProcessID = {'01362'}; % natural gas, burned in boiler modulating > 100 kW
technology.LCIA.LCI.UProcess(nlup).Value = {'@power/@en_eff*@demand_profiles.op_time*3.6*@gas_boiler_mult*@demand_profiles.lifetime'}; 
technology.LCIA.LCI.UProcess(nlup).Unit = {'MJ'};
technology.LCIA.LCI.UProcess(nlup).AddToProblem = 1;
technology.LCIA.LCI.UProcess(nlup).LifeCycleStage = {'O'};

% PROCESS EQUIPMENT

nlcc = nlcc+1;
technology.LCIA.LCI.Components(nlcc).TagName = {'gas_boiler'};
technology.LCIA.LCI.Components(nlcc).DisplayName = {'Gas boiler'};
technology.LCIA.LCI.Components(nlcc).Type = {'Boiler'};
technology.LCIA.LCI.Components(nlcc).Data.Power = {'@power*@gas_boiler_mult'}; 
technology.LCIA.LCI.Components(nlcc).Unit.Power = {'kW'};
technology.LCIA.LCI.Components(nlcc).AddToProblem = 1;
