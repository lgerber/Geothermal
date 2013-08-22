function o = CdF_PostCompute_cogen_wood(o)

% This function calculates the thermo-economic performance of the system 
% for the current period

if o.Silent == 0
    disp(['Calculating thermo-economic performance for period ',num2str(o.Period),'...'])
end

% multiplying factors for utilities

geo_mult = osmose_getTag(o,'@geo_deep_mult','Value');
steam_mult = osmose_getTag(o,'@steam_network_mult','Value');
cridor_mult = osmose_getTag(o,'@heat_cridor_mult','Value');
wood_mult = osmose_getTag(o,'@wood_boiler_mult','Value');
wood_deb_mult = osmose_getTag(o,'@wood_boiler_debrosse_mult','Value');
gn_boil_mult = osmose_getTag(o,'@gas_boiler_mult','Value');

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

wood_heat_load = osmose_getTag(o,'@heat_load','Value');
wood_heat = wood_heat_load * wood_mult * op_time; % kWh
wood_amount = wood_heat/wood_eff; % kWh
wood_cost = wood_amount * wood_price/100; % CHF

wood_deb_load = osmose_getTag(o,'@debrosse_load','Value');
wood_deb_heat = wood_deb_load * wood_deb_mult * op_time; % kWh
wood_deb_amount = wood_deb_heat/wood_eff; % kWh
wood_deb_cost = wood_deb_amount * wood_price/100; % CHF

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
steam_w1_prod = osmose_getTag(o,'@rnk_w1_power','Value');
steam_w1_prod = steam_w1_prod *steam_mult;
steam_w2_prod = osmose_getTag(o,'@rnk_w2_power','Value');
steam_w2_prod = steam_w2_prod *steam_mult;
steam_w3_prod = osmose_getTag(o,'@rnk_w3_power','Value');
steam_w3_prod = steam_w3_prod *steam_mult;
steam_w1_cons = osmose_getTag(o,'@rnk_w4_power','Value');
steam_w1_cons = steam_w1_cons *steam_mult;
steam_w2_cons = osmose_getTag(o,'@rnk_w5_power','Value');
steam_w2_cons = steam_w2_cons *steam_mult;
steam_w3_cons = osmose_getTag(o,'@rnk_w6_power','Value');
steam_w3_cons = steam_w3_cons *steam_mult;

steam_w_net = (steam_w1_prod + steam_w2_prod + steam_w3_prod - steam_w1_cons - steam_w2_cons - steam_w3_cons) * 0.97; % net power produced by orc, accounting generation efficiency

elec_sell_steam = steam_w_net * elec_price_cridor/100 * op_time; % assumption: electricity can be sold at same price than the one produced by cridor 

c_op_tot = ng_cost + wood_cost + wood_deb_cost + geo_cost + crid_op_cost - elec_sell_cridor - elec_sell_steam;

if o.Silent == 0
    disp(['Natural Gas Cost: ',num2str(ng_cost),'CHF'])
    disp(['Wood Cost: ',num2str(wood_cost),'CHF'])
    disp(['Wood Debrosse Cost: ',num2str(wood_deb_cost),'CHF'])
    disp(['Geothermal Cost: ',num2str(geo_cost),'CHF'])
    disp(['Electricity selling cridor: ',num2str(elec_sell_cridor),'CHF'])
    disp(['Electricity selling Steam cycle: ',num2str(elec_sell_steam),'CHF'])
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

if steam_mult == 0
   turb1_costs_usd = 0;
   turb2_costs_usd = 0;
   turb3_costs_usd = 0;
   pump1_costs_usd = 0;
   pump2_costs_usd = 0;
   pump3_costs_usd = 0;
else  
   turb_costs1 = cost_SteamTurbines(c, steam_w1_prod);
   turb1_costs_usd = turb_costs1.GR;
   turb_costs2 = cost_SteamTurbines(c, steam_w2_prod);
   turb2_costs_usd = turb_costs2.GR;
   turb_costs3 = cost_SteamTurbines(c, steam_w3_prod);
   turb3_costs_usd = turb_costs3.GR;
   
   pump_pressure = osmose_getTag(o,'@rnk_1_p','Value');
   pump1_costs = cost_CentrifugalPumps(c, steam_w1_cons, pump_pressure);
   pump1_costs_usd = pump1_costs.GR;
   pump2_costs = cost_CentrifugalPumps(c, steam_w2_cons, pump_pressure);
   pump2_costs_usd = pump2_costs.GR;
   pump3_costs = cost_CentrifugalPumps(c, steam_w3_cons, pump_pressure);
   pump3_costs_usd = pump3_costs.GR;
end

if wood_deb_mult == 0
    wood_deb_boil_costs_usd = 0;
else
    wood_deb_duty = wood_deb_heat/op_time;
    wood_deb_boil_costs = cost_SteamBoilers(c, 'packaged', 'solid', wood_deb_duty, 1, 1);
    wood_deb_boil_costs_usd = wood_deb_boil_costs.GR;
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
Tags(i).DisplayName = {'Cost of Wood'};
Tags(i).TagName = {'wood_deb_cost'};
Tags(i).Value = wood_deb_cost;
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
Tags(i).DisplayName = {'Net electricity produced by steam cycle'};
Tags(i).TagName = {'steam_w_net'};
Tags(i).Value = steam_w_net;
Tags(i).Units = {'kW'};

i=i+1;
Tags(i).DisplayName = {'Electricity sellings from Steam cycle'};
Tags(i).TagName = {'elec_sell_steam'};
Tags(i).Value = elec_sell_steam;
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
Tags(i).DisplayName = {'Costs of Steam turbine USD'};
Tags(i).TagName = {'turb1_costs_usd'};
Tags(i).Value = turb1_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Water pump USD'};
Tags(i).TagName = {'pump1_costs_usd'};
Tags(i).Value = pump1_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Steam turbine USD'};
Tags(i).TagName = {'turb2_costs_usd'};
Tags(i).Value = turb2_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Water pump USD'};
Tags(i).TagName = {'pump2_costs_usd'};
Tags(i).Value = pump2_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Steam turbine USD'};
Tags(i).TagName = {'turb3_costs_usd'};
Tags(i).Value = turb3_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Water pump USD'};
Tags(i).TagName = {'pump3_costs_usd'};
Tags(i).Value = pump3_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Wood boiler, debrosse'};
Tags(i).TagName = {'wood_deb_boil_costs_usd'};
Tags(i).Value = wood_deb_boil_costs_usd;
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
