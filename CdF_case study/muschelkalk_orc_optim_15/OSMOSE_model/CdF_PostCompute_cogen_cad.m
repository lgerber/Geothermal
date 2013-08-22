function o = CdF_PostCompute_cogen_cad(o)

% This function calculates the thermo-economic performance of the system 
% for the current period

if o.Silent == 0
    disp(['Calculating thermo-economic performance for period ',num2str(o.Period),'...'])
end

% multiplying factors for utilities

geo_mult = osmose_getTag(o,'@geo_deep_mult');
cridor_mult = osmose_getTag(o,'@heat_cridor_mult','Value');
wood_mult = osmose_getTag(o,'@wood_boiler_mult','Value');
gn_boil_mult = osmose_getTag(o,'@gas_boiler_mult','Value');
orc_mult = osmose_getTag(o,'@orc_cycle_mult','Value');

if isfield(geo_mult,'Value')
    geo_mult = geo_mult.Value;
else
    geo_mult = 0;
end
if isempty(cridor_mult)
    cridor_mult = 0;
end
if isempty(wood_mult)
    wood_mult = 0;
end
if isempty(gn_boil_mult)
    gn_boil_mult = 0;
end
if isempty(orc_mult)
    orc_mult = 0;
end

%% thermodynamic performance

% heat transfered to district heating
loss = osmose_getTag(o,'@losses','Value');
dhn_heat = osmose_getTag(o,'@dhn_load','Value');
op_time = osmose_getTag(o,'@op_time','Value');
tot_dhn_heat = op_time * dhn_heat * (1-loss); % kWh

%% economic performance

%operating costs

ng_price = osmose_getTag(o,'@ng_price','Value');
ng_eff = osmose_getTag(o,'@en_eff_ng','Value');
ng_heat = osmose_getTag(o,'@power','Value');
ng_heat = ng_heat * gn_boil_mult * op_time; % kWh
ng_amount = ng_heat/ng_eff; % kWh
ng_cost = ng_amount * ng_price/100; % CHF

wood_price = osmose_getTag(o,'@wood_price','Value');
wood_eff = osmose_getTag(o,'@en_eff_wood','Value');
wood_heat = osmose_getTag(o,'@heat_load','Value');
wood_heat = wood_heat * wood_mult * op_time; % kWh
wood_amount = wood_heat/wood_eff; % kWh
wood_cost = wood_amount * wood_price/100; % CHF

var_elec_price = osmose_getTag(o,'@var_elec_price','Value');

if var_elec_price == 1
    dh_sell_price = osmose_getTag(o,'@dh_sell_price','Value');
    elec_price_ratio = osmose_getTag(o,'@elec_price_ratio','Value');
    elec_price = elec_price_ratio * dh_sell_price;
else
    elec_price = osmose_getTag(o,'@elec_price','Value');
end

geo_power = osmose_getTag(o,'@pump_power','Value');

geo_power = geo_power * op_time * geo_mult; % kWh
geo_cost = geo_power * elec_price; % CHF

crid_heat = osmose_getTag(o,'@Q_dhn','Value');
crid_op_cost = osmose_getTag(o,'@op_cost','Value');
crid_op_cost = crid_op_cost * cridor_mult * crid_heat * op_time;

E_prod_crid = osmose_getTag(o,'@E_prod','Value');
elec_price_cridor = osmose_getTag(o,'@elec_price_cridor','Value');

% satisfying first internal needs in electricity for cridor
if E_prod_crid * cridor_mult < 1000
    elec_sell_cridor = 0;
else
    elec_sell_cridor = (E_prod_crid * cridor_mult - 1000) * elec_price_cridor/100 * op_time;
end

% income from electricity selling from orc
orc_w_prod = osmose_getTag(o,'@orc_wprod_power','Value');
orc_w_prod = orc_w_prod *orc_mult;
orc_w_cons = osmose_getTag(o,'@orc_wcons_power','Value');
orc_w_cons = orc_w_cons *orc_mult;

orc_w_net = (orc_w_prod - orc_w_cons) * 0.97; % net power produced by orc, accounting generation efficiency

elec_sell_orc = orc_w_net * elec_price_cridor/100 * op_time; % assumption: electricity can be sold at same price than the one produced by cridor 

c_op_tot = ng_cost + wood_cost + geo_cost + crid_op_cost - elec_sell_cridor - elec_sell_orc;

if o.Silent == 0
    disp(['Natural Gas Cost: ',num2str(ng_cost),'CHF'])
    disp(['Wood Cost: ',num2str(wood_cost),'CHF'])
    disp(['Geothermal Cost: ',num2str(geo_cost),'CHF'])
    disp(['Electricity selling cridor: ',num2str(elec_sell_cridor),'CHF'])
    disp(['Electricity selling ORC: ',num2str(elec_sell_orc),'CHF'])
end

% investment costs

c = cost_defaults;
c.LifeTime = osmose_getTag(o,'@lifetime','Value');
c.InterestRate = osmose_getTag(o,'@ir','Value');
conv_usd2chf = osmose_getTag(o,'@conv_usd2chf','Value');

if geo_mult == 0
    drill_costs_usd = 0;
    cost_pump_da_usd = 0;
    pipe_dhn_cost = 0;
else
    drill_costs_chf = osmose_getTag(o,'@inv_costs','Value');
    pump_da_power = osmose_getTag(o,'@pump_power','Value');
    p_pump_da = osmose_getTag(o,'@pump_hp','Value');

    drill_costs_usd = drill_costs_chf/conv_usd2chf;
    pump_da_power = pump_da_power * geo_mult;
    n_units_pumps = ceil(pump_da_power/250);
    pump_da_unit_power = pump_da_power/n_units_pumps;
    cost_unit_pump = cost_CentrifugalPumps(c, pump_da_unit_power, p_pump_da);
    cost_pump_da_usd = cost_unit_pump.GR * n_units_pumps;
    pipe_dhn_cost = 1500000; % CHF, estimated price for the pipe to connect geothermal well to DHN
end

if orc_mult == 0
   turb_costs_usd = 0;
   pump_costs_usd = 0;
else  
   turb_costs = cost_SteamTurbines(c, orc_w_prod);
   turb_costs_usd = turb_costs.GR;
   
   pump_pressure = osmose_getTag(o,'@orc_wf1_p','Value');
   pump_costs = cost_CentrifugalPumps(c, orc_w_cons, pump_pressure);
   pump_costs_usd = pump_costs.GR;
end

% income from service selling and net profit

dh_sell_price = osmose_getTag(o,'@dh_sell_price','Value');
dh_income = dh_sell_price * tot_dhn_heat;

%% update model tags
Tags = struct;
i=0;

i=i+1;
Tags(i).DisplayName = {'Total heat supplied to consumer'};
Tags(i).TagName = {'tot_dhn_heat'};
Tags(i).Value = tot_dhn_heat;
Tags(i).Units = {'kWh'};

i=i+1;
Tags(i).DisplayName = {'Cost of Natural Gas'};
Tags(i).TagName = {'ng_cost'};
Tags(i).Value = ng_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Wood'};
Tags(i).TagName = {'wood_cost'};
Tags(i).Value = wood_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Geothermal exploitation'};
Tags(i).TagName = {'geo_cost'};
Tags(i).Value = geo_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Cridor'};
Tags(i).TagName = {'crid_op_cost'};
Tags(i).Value = crid_op_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Electricity produced by ORC, net'};
Tags(i).TagName = {'orc_w_net'};
Tags(i).Value = orc_w_net;
Tags(i).Units = {'kW'};

i=i+1;
Tags(i).DisplayName = {'Electricity sellings from ORC'};
Tags(i).TagName = {'elec_sell_orc'};
Tags(i).Value = elec_sell_orc;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Electricity sellings from Cridor'};
Tags(i).TagName = {'elec_sell_cridor'};
Tags(i).Value = elec_sell_cridor;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total operating cost'};
Tags(i).TagName = {'c_op_tot'};
Tags(i).Value = c_op_tot;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Drilling costs USD'};
Tags(i).TagName = {'drill_costs_usd'};
Tags(i).Value = drill_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Geothermal pump cost USD'};
Tags(i).TagName = {'cost_pump_da_usd'};
Tags(i).Value = cost_pump_da_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Pipe for DHN connection cost CHF'};
Tags(i).TagName = {'pipe_dhn_cost'};
Tags(i).Value = pipe_dhn_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Costs of ORC turbine USD'};
Tags(i).TagName = {'turb_costs_usd'};
Tags(i).Value = turb_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of ORC pump USD'};
Tags(i).TagName = {'pump_costs_usd'};
Tags(i).Value = pump_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Income from district heating selling'};
Tags(i).TagName = {'dh_income'};
Tags(i).Value = dh_income;
Tags(i).Units = {'CHF'};

o = update_model_tags(o,Tags);

%% update functional unit for LCA
lifetime = osmose_getTag(o,'@lifetime','Value');
o.LCIA.FunctionalUnit.Value = tot_dhn_heat*lifetime;
